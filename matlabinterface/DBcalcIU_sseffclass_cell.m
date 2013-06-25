function weirdcellidstimid = DBcalcIU_sseffclass_cell(conn,cellidin,onlyaddnew_noupdate)

%% checks and setup
if numel(cellidin) > 1
    error('too many cells')
end

if ~exist('onlyaddnew_noupdate','var') %onlyaddnew_noupdate=2 ;use for debugging; just skips the updating of the database
    onlyaddnew_noupdate = 0;
end

weirdcellidstimid = [];

%get cell things
[subjectid subjectname] = DBget_subject_cell(conn,cellidin);
subjectname = cell2mat(subjectname);
[trainingstims] = DBget_trainingstims_cell(conn,cellidin);

%get protocol mode info
query = ['SELECT protocolmodeid FROM protocolmode WHERE protocolmodename LIKE ''%behavior%'' '];
desENGAGEDprotocolmodes = cell2mat(DBx(conn,query));
query = ['SELECT protocolmodeid FROM protocolmode WHERE protocolmodename = ''neuralrecordingonly'' '];
desNONENGAGEDprotocolmodes = cell2mat(DBx(conn,query));

%% get all stims this cell ever saw
query = ['SELECT trial.stimulusid '...
    ' FROM trial JOIN spiketrain ON spiketrain.trialid = trial.trialid '...
    ' JOIN cell ON cell.cellid = spiketrain.cellid ' ...
    ' WHERE cell.cellid in ' DBtool_inlist(cellidin) ];
cellstimids = unique(cell2mat(DBx(conn,query)));

%% get all sstrials this cell ever saw
query = ['SELECT sstrialid, sstrialtime '...
    ' FROM sstrial JOIN spiketrain ON spiketrain.trialid = sstrial.trialid '...
    ' JOIN cell ON cell.cellid = spiketrain.cellid ' ...
    ' WHERE cell.cellid in ' DBtool_inlist(cellidin) ...
    ' ORDER BY sstrialtime '];
cellsstrialidstimes = DBx(conn,query); %TODO: need an eff class for each of these

%% find time bounds on cell re: sstrials
celltimestart = DBtool_tstampfromdatenum(addtodate(datenum(cellsstrialidstimes{1,2}),-1,'millisecond'));
celltimeend = DBtool_tstampfromdatenum(addtodate(datenum(cellsstrialidstimes{end,2}),1,'millisecond'));

%% now that have sstrials in DB, use these to get eff class
% main assumtion here is that the SS trials represent everything a bird has
% experienced - this should be pretty close to true minus weird fuzzy
% things at the edges (spike2 crashes during sampling etc - should effect only very few trials)
stimtic = tic;
for cus = 1:numel(cellstimids) %cycle through all stims this cell ever saw
    fprintf(1,'on stim %d of %d\t last stim took %4.4f seconds\n',cus,numel(cellstimids),toc(stimtic));
    stimtic = tic;
    currstimid = cellstimids(cus);
    
    %% grab ALL the times this bird saw this stim
    query = ['SELECT DISTINCT sstrialtime, sstrialid ' ...
        ' FROM sstrial WHERE stimulusid = ' DBtool_num2strNULL(currstimid) ...
        ' AND subjectid = ' DBtool_num2strNULL(subjectid) ...
        ' ORDER BY sstrialtime '];
    sstidall = DBx(conn,query);
    % get time bounds on this stim/this bird - eveything the bird does with
    % this stim should be in these time bounds
    substimtimestart = DBtool_tstampfromdatenum(addtodate(datenum(sstidall{1,1}),-1,'millisecond'));
    substimtimeend = DBtool_tstampfromdatenum(addtodate(datenum(sstidall{end,1}),1,'millisecond'));
    
    %% skip if all sstrialids have a sseffectiveclassid
    if onlyaddnew_noupdate == 1 
        tmp = DBget_x(conn,['SELECT DISTINCT sstrialcalcid, sseffectiveclassid FROM sstrialcalc WHERE sstrialid IN ' DBtool_inlist(cell2mat(sstidall(:,2)))]);
        if size(tmp,1) == size(sstidall,1)
        if ~isempty(tmp)
            if ~any(isnan(cell2mat(tmp(:,2))))
                %all sstrialids have an eff class already calculated
                fprintf(1,'all sstrialids have an eff class already calculated\n')
                continue %skip to next stim
            end
        end
        end
    end
    
    %% should only get to here if there are empty sseffectiveclassids or if user requests them to be updated by having onlyaddnew_noupdate ~= 1
    
    %% determine whether stim was ever presented to bird in engaged context
    % get all the times this stim was presented to this bird in an engaged context
    query = ['SELECT DISTINCT sstrialid, stimulusclass, sstrialtime ' ...
        ' FROM sstrial WHERE stimulusid = ' DBtool_num2strNULL(currstimid) ...
        ' AND subjectid = ' DBtool_num2strNULL(subjectid) ...
        ' AND protocolmodeid IN ' DBtool_inlist(desENGAGEDprotocolmodes) ...
        ' ORDER BY sstrialtime '];
    sstidclassE = DBx(conn,query);
    
    % get all the times this stim was presented to this bird in a nonengaged context
    query = ['SELECT DISTINCT sstrialid, stimulusclass, sstrialtime ' ...
        ' FROM sstrial WHERE stimulusid = ' DBtool_num2strNULL(currstimid) ...
        ' AND subjectid = ' DBtool_num2strNULL(subjectid) ...
        ' AND protocolmodeid IN ' DBtool_inlist(desNONENGAGEDprotocolmodes)]; %TODO why aren't we ordering by time here, too??
    sstidclassNE = DBx(conn,query);
    
    if isempty(sstidclassE) %this stimulus was only ever presented in a nonengaged context (should at least get silence here)
        currclassesE = [];
    else
        currclassesE = unique(cell2mat(sstidclassE(:,2)));
    end
    if isempty(sstidclassNE) %this stimulus was only ever presented in an engaged context
        currclassesNE = [];
    else
        currclassesNE = unique(cell2mat(sstidclassNE(:,2)));
    end
    
    %% now loop through each engaged trial of the current stim and calc the effclass
    if isempty(sstidclassE) %all nonengaged
        ceffclass = cell2mat(DBx(conn,['SELECT sseffectiveclassid FROM sseffectiveclass WHERE sseffectiveclassname = ''nonengagedonly'' ']));
        DBaddIU_sstrial_sseffclass_batch(conn,[cell2mat(sstidclassNE(:,1)) repmat(ceffclass,size(sstidclassNE(:,1),1),1)],onlyaddnew_noupdate);
    else %here's all the magic
        %         figure;plot(datenum(currtrialsE(:,1)),cell2mat(currtrialsE(:,3)),'r.');hold on;plot(datenum(currtrialsNE(:,1)),cell2mat(currtrialsNE(:,3)),'b.');datetick('x',0);axrangeY(0,8);
        %         get overtrained stims out of the way
        
        if all(unique([currclassesE(:); currclassesNE(:)]) == 1) %found an OTleft stim
            ceffclass = cell2mat(DBx(conn,['SELECT sseffectiveclassid FROM sseffectiveclass WHERE sseffectiveclassname = ''overtrained-left'' ']));
            DBaddIU_sstrial_sseffclass_batch(conn,[cell2mat(sstidclassNE(:,1)) repmat(ceffclass,size(sstidclassNE(:,1),1),1)],onlyaddnew_noupdate);
            DBaddIU_sstrial_sseffclass_batch(conn,[cell2mat(sstidclassE(:,1)) repmat(ceffclass,size(sstidclassE(:,1),1),1)],onlyaddnew_noupdate);
        elseif all(unique([currclassesE(:); currclassesNE(:)]) == 2) %found an OTright stim
            ceffclass = cell2mat(DBx(conn,['SELECT sseffectiveclassid FROM sseffectiveclass WHERE sseffectiveclassname = ''overtrained-right'' ']));
            DBaddIU_sstrial_sseffclass_batch(conn,[cell2mat(sstidclassNE(:,1)) repmat(ceffclass,size(sstidclassNE(:,1),1),1)],onlyaddnew_noupdate);
            DBaddIU_sstrial_sseffclass_batch(conn,[cell2mat(sstidclassE(:,1)) repmat(ceffclass,size(sstidclassE(:,1),1),1)],onlyaddnew_noupdate);
            
        else %here have something that might not be OT
            
            if any(ismember([1,2],currclassesE)) || any(ismember([1,2],currclassesNE)) %logic: if any of these engaged classes = 1,2 that's weird; should have been taken care of above.
                weirdcellidstimid = [weirdcellidstimid; [cellidin currstimid]];
                %error('ERROR: check me out: found engaged class = 1 or 2')
                
            elseif any(currclassesE == 5) || any(currclassesE == 6) %expecting either a 5 or 6
                %ok need to figure something out here - want to get at actual
                %performance, not just current stim's performance, so need to
                %get all stims presented along with this one...
                currstimfirstengagedtrialtime = sstidclassE{1,3};
                currstimlastengagedtrialtime = sstidclassE{end,3};
                
                stimEtimestart = DBtool_tstampfromdatenum(addtodate(datenum(currstimfirstengagedtrialtime),-1,'millisecond'));
                stimEtimeend = DBtool_tstampfromdatenum(addtodate(datenum(currstimlastengagedtrialtime),1,'millisecond'));
                
                query = ['SELECT sstrialtime, sstrialid, stimulusid, stimulusclass, iscorrectiontrial, responseaccuracyid, trialid ' ...
                    ' FROM sstrial ' ...
                    ' WHERE subjectid = ' DBtool_num2strNULL(subjectid) ...
                    ' AND ( TIMESTAMP WITHOUT TIME ZONE ' DBtool_num2strNULL(stimEtimestart) ', TIMESTAMP WITHOUT TIME ZONE ' DBtool_num2strNULL(stimEtimeend) ') OVERLAPS (sstrialtime , INTERVAL ''1 millisecond'')' ...
                    ' AND protocolmodeid IN ' DBtool_inlist(desENGAGEDprotocolmodes) ...
                    ' AND iscorrectiontrial = ''false'' ' ...
                    ' AND stimulusid NOT IN ' DBtool_inlist(trainingstims) ...
                    ' ORDER BY sstrialtime'];
                allET = DBx(conn,query);
                
       %%%%%CRITERION CALCULATION%%%%%
                %HERE IS CRITERION
                MAwin = 50;
                currclasses = cell2mat(allET(:,4));
                currclasses(currclasses==3|currclasses==5) = 1;
                currclasses(currclasses==4|currclasses==6) = 2;
                
                if any(~(currclasses == 1 | currclasses == 2))
                    weirdcellidstimid = [weirdcellidstimid; [cellidin currstimid]];
                    continue
                end
                [pc,dpr,dprCIhigh,dprCIlow] = MAbehavior(cell2mat(allET(:,6)),MAwin,currclasses);
                
                minnumtrials = round(MAwin/2);
                numtrialsinarow = 1;
                crit2=[];
                crit = dpr>dprCIhigh;
                for i = 1:numel(dpr)
                    if i < minnumtrials+numtrialsinarow
                        crit2(i) = 0;
                    else
                        crit2(i) = all(crit(i-numtrialsinarow+1:i));
                    end
                end
                learningind = find(crit2,1);
                
                %this should help visualize the behavior
                doplot=0;
                if doplot == 1
                    figure;
                    subplot(2,1,1)
                    hold on;
                    plot(dpr,'b');plot(dprCIhigh,'g');plot(dprCIlow,'g');plot(crit2.*3,'m');PTplot_0line();
                    title(sprintf('cellid: %d\tstimid: %d',cellidin,currstimid))
                    
                    [pc1] = MAbehavior(cell2mat(allET(cell2mat(allET(:,4))==5,6)),MAwin,ones(sum(cell2mat(allET(:,4))==5),1));
                    [pc2] = MAbehavior(cell2mat(allET(cell2mat(allET(:,4))==6,6)),MAwin,ones(sum(cell2mat(allET(:,4))==6),1));
                    [pcall] = MAbehavior(cell2mat(allET(:,6)),MAwin,ones(size(allET,1),1));
                    subplot(2,1,2);
                    hold on;
                    plot(find(cell2mat(allET(:,4))==5),pc1,'b');
                    plot(find(cell2mat(allET(:,4))==6),pc2,'r');
                    plot(1:size(allET,1),pcall,'k');
                    axrangeY(0,1);
                end
                %
                %
                
                if isempty(learningind)
                    didlearn = 0;
                else
                    didlearn = 1;
                    sstrialoflearning = allET{learningind,2};
                    sstimeoflearning = allET{learningind,1};
                end
                
                preengagedclass = 0;
                if any(currclassesE == 5)
                    prelearnedclass = 5;
                    postlearnedclass = 3;
                elseif any(currclassesE == 6)
                    prelearnedclass = 6;
                    postlearnedclass = 4;
                end
                
                sshouldbe = [];
                %preengaged
                query = ['SELECT sstrialid ' ...
                    ' FROM sstrial WHERE stimulusid = ' DBtool_num2strNULL(currstimid) ...
                    ' AND subjectid = ' DBtool_num2strNULL(subjectid) ...
                    ' AND ( TIMESTAMP WITHOUT TIME ZONE ' DBtool_num2strNULL(substimtimestart) ', TIMESTAMP WITHOUT TIME ZONE ' DBtool_num2strNULL(stimEtimestart) ') OVERLAPS (sstrialtime , INTERVAL ''1 millisecond'')' ...
                    ' ORDER BY sstrialtime'];
                sstrialidspree = cell2mat(DBx(conn,query));
                sshouldbe = [sshouldbe; [sstrialidspree(:) repmat(preengagedclass,numel(sstrialidspree),1)]];
                
                if didlearn == 1
                    %prelearned
                    query = ['SELECT sstrialid ' ...
                        ' FROM sstrial WHERE stimulusid = ' DBtool_num2strNULL(currstimid) ...
                        ' AND subjectid = ' DBtool_num2strNULL(subjectid) ...
                        ' AND ( TIMESTAMP WITHOUT TIME ZONE ' DBtool_num2strNULL(stimEtimestart) ', TIMESTAMP WITHOUT TIME ZONE ' DBtool_num2strNULL(sstimeoflearning) ') OVERLAPS (sstrialtime , INTERVAL ''1 millisecond'')' ...
                        ' ORDER BY sstrialtime'];
                    sstrialidsprel = cell2mat(DBx(conn,query));
                    sshouldbe = [sshouldbe; [sstrialidsprel(:) repmat(prelearnedclass,numel(sstrialidsprel),1)]];
                    
                    %postlearned
                    query = ['SELECT sstrialid ' ...
                        ' FROM sstrial WHERE stimulusid = ' DBtool_num2strNULL(currstimid) ...
                        ' AND subjectid = ' DBtool_num2strNULL(subjectid) ...
                        ' AND ( TIMESTAMP WITHOUT TIME ZONE ' DBtool_num2strNULL(sstimeoflearning) ', TIMESTAMP WITHOUT TIME ZONE ' DBtool_num2strNULL(substimtimeend) ') OVERLAPS (sstrialtime , INTERVAL ''1 millisecond'')' ...
                        ' ORDER BY sstrialtime'];
                    sstrialidsposte = cell2mat(DBx(conn,query));
                    sshouldbe = [sshouldbe; [sstrialidsposte(:) repmat(postlearnedclass,numel(sstrialidsposte),1)]];
                else %didn't learn
                    query = ['SELECT sstrialid ' ...
                        ' FROM sstrial WHERE stimulusid = ' DBtool_num2strNULL(currstimid) ...
                        ' AND subjectid = ' DBtool_num2strNULL(subjectid) ...
                        ' AND ( TIMESTAMP WITHOUT TIME ZONE ' DBtool_num2strNULL(stimEtimestart) ', TIMESTAMP WITHOUT TIME ZONE ' DBtool_num2strNULL(substimtimeend) ') OVERLAPS (sstrialtime , INTERVAL ''1 millisecond'')' ...
                        ' ORDER BY sstrialtime'];
                    sstrialidsposte = cell2mat(DBx(conn,query));
                    sshouldbe = [sshouldbe; [sstrialidsposte(:) repmat(prelearnedclass,numel(sstrialidsposte),1)]];
                end
                DBaddIU_sstrial_sseffclass_batch(conn,sshouldbe,onlyaddnew_noupdate);
                
            else %fill me in when you figure out how
                weirdcellidstimid = [weirdcellidstimid; [cellidin currstimid]];
                warning('WARNING: found a weirdcellidstimid')
                %error('ERROR: not coded up yet')
            end
        end
    end
    
end
