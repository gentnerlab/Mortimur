function [subjectid, penid, siteid, sortid, trialids, trialeventids] = DBadd_SMunit(conn, unit)
%[subjectid, penid, siteid, sortid, trialid, trialeventids] = DBadd_SMunit(conn, unit)

%% get subject ID
subjectid = DBget_subjectID(conn,unit.subject);

%% get penetration ID

%%%get AP
aptmp = regexp(unit.pen,'AP\d+_','match','once');
AP = aptmp(3:end-1);

%%%get ML
mltmp = regexp(unit.pen,'_ML\d+','match','once');
ML = mltmp(4:end);

penid = DBget_penetrationID(conn,subjectid,AP,ML);

%% get electrode and electrodepad info

query = ['SELECT DISTINCT electrodepad.electrodepadid, electrodepad.electrodetypeid, electrodepad.datachannel '...
    ' FROM electrodepad '...
    ' JOIN electrode ON electrode.electrodetypeid = electrodepad.electrodetypeid '...
    ' JOIN penetration ON penetration.electrodeid = electrode.electrodeid '...
    ' WHERE penetration.penetrationid = ' DBtool_num2strNULL(penid)];
etrodepadidetrodetypesmrchan = cell2mat(DBget_x(conn,query));

%% get site ID

tmpdepth = regexp(unit.site,'_Z\d+','match','once');
depth = tmpdepth(3:end);

siteid = DBget_siteID(conn,penid,depth);

%% load trialeventtype only once - saves ~1/4 of inserting time!!
[zz trialeventtypes] = DBget_trialeventtype(conn,'all');

%% get/add sort then trials

for infonum = 1:length(unit.info)
    
    concatfilename = unit.info(infonum).s2MATfile;
    concatfilechan = 'null';
    sortmarkercode = unit.marker;
    sortquality = unit.info(infonum).sortquality;
    isolationtypeid = 1; %WARNING:HARD-CODED: this is the id for single unit - need to code something else up for different datatypes
    template_pre = unit.info(infonum).WMnumPreTriggerPoints;
    template_n = unit.info(infonum).WMnumPointsPerWavemark;
    n_chans = unit.info(infonum).WMtraces;
    
    %dunno what these are - fromJamie
    template_start = 'null';
    template_show = 'null';
    
    
    
    %following needs to be coded into the .matfiles
    primarysourcechan = 'null';
    chan1_electrodepadid = 'null';
    chan1_threshold = 'null';
    chan2_electrodepadid = 'null';
    chan2_threshold = 'null';
    chan3_electrodepadid = 'null';
    chan3_threshold = 'null';
    chan4_electrodepadid = 'null';
    chan4_threshold = 'null';
    
    if ~isempty(etrodepadidetrodetypesmrchan)
        chan1_electrodepadid = etrodepadidetrodetypesmrchan(etrodepadidetrodetypesmrchan(:,3)==unit.info(infonum).smrchan1,1);
        chan2_electrodepadid = etrodepadidetrodetypesmrchan(etrodepadidetrodetypesmrchan(:,3)==unit.info(infonum).smrchan2,1);
        chan3_electrodepadid = etrodepadidetrodetypesmrchan(etrodepadidetrodetypesmrchan(:,3)==unit.info(infonum).smrchan3,1);
        chan4_electrodepadid = etrodepadidetrodetypesmrchan(etrodepadidetrodetypesmrchan(:,3)==unit.info(infonum).smrchan4,1);
    end
    
    template_resolution = unit.info(infonum).WMchanresolution;
    template_interval = unit.info(infonum).WMchaninterval;
    template_scale = unit.info(infonum).WMscale;
    template_offset = unit.info(infonum).WMoffset;
    
    if isempty(DBget_sortID(conn, siteid, concatfilename, sortmarkercode)) %write the sort to the database if it doesn't exist
        [query, anerror, errormsg, output] = DBadd_sort(conn, siteid, concatfilename, concatfilechan, sortmarkercode, sortquality, isolationtypeid, template_start, template_show, template_pre, template_n, primarysourcechan, n_chans, chan1_electrodepadid, chan1_threshold, chan2_electrodepadid, chan2_threshold, chan3_electrodepadid, chan3_threshold, chan4_electrodepadid, chan4_threshold, template_resolution, template_interval, template_scale, template_offset);
        if anerror == 1
            zz=1;
        end
    end
    
    sortid(infonum) = DBget_sortID(conn, siteid, concatfilename, sortmarkercode);
    
    %%%now do cell for this unit
    cellid = DBget_cellID(conn,siteid,sortmarkercode);
    if isempty(cellid) %write the cell to the database if it doesn't exist
        cellname = 'null';
        regionid = 'null';
        [query, anerror, errormsg, output] = DBadd_cell(conn, cellname, regionid, siteid, sortmarkercode);
        cellid = output;
        if anerror == 1
            zz=1;
        end
    end
    
    
    %%%now do trials for this infonum
    % addtrial, add spiketrain, addtrialevent
    
    currsorttrials = unit.trials(unit.info(infonum).trialinds,:);
    
    for trialnum = 1:size(currsorttrials,1)
        currtrial = currsorttrials(trialnum,:);
        
        
        trialtime = gettrialtimestamp(currtrial,unit);
        
        
        epochid = DBget_epoch(conn,['(starttimestamp, endtimestamp) OVERLAPS (TIMESTAMP ' '''' trialtime '''' ', INTERVAL ''1 millisecond'') AND subjectid = ' DBtool_num2strNULL(subjectid)]);
        if length(epochid) > 1
            zz=1;
            error('major problem - found 2 epochs for one trial')
        end
        
        %find stimulus and get stimid/add stim
        stimname = strrep(strrep(currtrial{6},'.smr',''),'.wav','');
        
        if isempty(DBget_stimulus(conn, ['stimulusfilename = '  '''' stimname ''''])) %write the stim to the database if it doesn't exist
            motifboundaries = []; %TODO: get this into DB somehow
            if strcmp(unit.subject,'st517') == 0
                try
                stimdur = wavdurDB(fixfilesep([getstimlibdir filesep() stimname]));
                catch
                    stimdur = 'null';
                end
            else
                stimdur = wavdurDB(fixfilesep([getstimlibdir filesep() 'st517MCstims' filesep() stimname]));
            end
            [query, anerror, errormsg, output] = DBadd_stimulus(conn, stimname, motifboundaries, stimdur);
            if anerror == 1
                zz=1;
            end
        end
        stimulusid = DBget_stimulus(conn, ['stimulusfilename = '  '''' stimname '''']);
        
        stimulusplaybackrate = 'null';
        relstarttime = currtrial{5}(1);
        relendtime = currtrial{5}(2);
        
        trialid = DBget_trial(conn, ['trialtime = ' '''' trialtime '''']);
        if isempty(trialid) %write the trial to the database if it doesn't exist
            [query, anerror, errormsg, output] = DBadd_trial(conn, epochid, stimulusplaybackrate, stimulusid, relstarttime, relendtime, trialtime);
            trialid=output;
            if anerror == 1
                zz=1;
            end
        end
        trialids{infonum}(trialnum) = trialid;
        
        
        %%%now do spiketrain for this trial
        spiketrainid = DBget_spiketrain(conn, ['trialid = ' DBtool_num2strNULL(trialid) ' AND sortid = ' DBtool_num2strNULL(sortid(infonum))]);
        if isempty(spiketrainid) %write the spiketrain to the database if it doesn't exist
            
            spikecount = size(currtrial{10},1);
            
            spiketimes = '';
            for spikenum = 1:spikecount
                spiketimes = sprintf('%s,%6.4f',spiketimes,currtrial{10}(spikenum));
            end
            spiketimes = ['{' spiketimes(2:end) '}'];
            
            [query, anerror, errormsg, output] = DBadd_spiketrain(conn, trialid, sortid(infonum), cellid, spiketimes, spikecount);
            spiketrainid = output;
            if anerror == 1
                zz=1;
            end
        end
        
        
        %%%now do events for this trial
        %
        %first check to see if this trial has events already, if it does,
        %it should be from a different cell and should be identical so we
        %shouldn't need to add anything to the DB, if we do, we need to
        %figure out why
        teidsyet = DBget_x(conn, ['SELECT trialeventid FROM trialevent WHERE trialid = ' DBtool_num2strNULL(trialid)]);
        if ~isempty(teidsyet)
            haveteidsalready = 1;
        else
            haveteidsalready = 0;
        end
        
        trialeventids{infonum}{trialnum} = [];
        %8 = KB, 9 = DM
        for marktype = [8,9]
            for eventnum = 1:size(currtrial{marktype}.times,1)
                eventtime = currtrial{marktype}.times(eventnum);
                
                if marktype == 8
                    trialeventtypename = 'keyboardmarker';
                elseif marktype == 9
                    trialeventtypename = 'digitalmarker';
                end
                
                trialeventtypeid = trialeventtypes{strcmp(trialeventtypename,trialeventtypes(:,2)),1};
                
                eventcode1 = currtrial{marktype}.codes(eventnum,1);
                eventcode2 = currtrial{marktype}.codes(eventnum,2);
                eventcode3 = currtrial{marktype}.codes(eventnum,3);
                eventcode4 = currtrial{marktype}.codes(eventnum,4);
                
                trialeventid = DBget_trialeventid(conn, trialid, eventtime, trialeventtypeid);
                if isempty(trialeventid) %write the trialevent to the database if it doesn't exist
                    if haveteidsalready == 1
                        warning(sprintf('there is a trialevent which differs from previously inserted trial events for a given trial\nassuming this is a rounding error, but please check to be sure\ntrialid: %d\ttrialeventtime: %f\n',trialid,eventtime));
                    else
                        [query, anerror, errormsg, output] = DBadd_trialevent(conn, trialid, eventtime, trialeventtypeid, eventcode1, eventcode2, eventcode3, eventcode4);
                        trialeventid = output;
                        if anerror == 1
                            dbstop;
                            zz=1;
                        end
                        trialeventids{infonum}{trialnum} = [trialeventids{infonum}{trialnum} ; trialeventid];
                    end
                end
            end
        end
        
        %do stimulus markers
        trialeventtypename = 'stimulusmarker';
        trialeventtypeid = trialeventtypes{strcmp(trialeventtypename,trialeventtypes(:,2)),1};
        trialeventid = DBget_trialeventid(conn, trialid, 'null', trialeventtypeid);
        if isempty(trialeventid)
            if haveteidsalready == 1 && trialid ~= 43492
                warning(sprintf('there is a trialevent which differs from previously inserted trial events for a given trial\nassuming this is a rounding error, but please check to be sure\ntrialid: %d\ttrialeventtime: %f\n',trialid,eventtime));
            else
                eventtime = 'null';
                try
                eventcode1 = currtrial{7}(1);
                eventcode2 = currtrial{7}(2);
                eventcode3 = currtrial{7}(3);
                eventcode4 = currtrial{7}(4);
                catch currexception
                    zz=1;
                end
                [query, anerror, errormsg, output] = DBadd_trialevent(conn, trialid, eventtime, trialeventtypeid, eventcode1, eventcode2, eventcode3, eventcode4);
                trialeventid = output;
                if anerror == 1
                    zz=1;
                end
                trialeventids{infonum}{trialnum} = [trialeventids{infonum}{trialnum} ; trialeventid];
            end
        end
        
        
        %do behavioralconsequence
        if size(currtrial,2) >= 12
            trialeventtypename = 'behavioralconsequence';
            trialeventtypeid = trialeventtypes{strcmp(trialeventtypename,trialeventtypes(:,2)),1};
            trialeventid = DBget_trialeventid(conn, trialid, 'null', trialeventtypeid);
            if isempty(trialeventid) %write the trialevent to the database if it doesn't exist   %TODO: write this function
                if haveteidsalready == 1  && trialid ~= 43492
                    warning(sprintf('there is a trialevent which differs from previously inserted trial events for a given trial\nassuming this is a rounding error, but please check to be sure\ntrialid: %d\ttrialeventtime: %f\n',trialid,eventtime));
                else
                    eventtime = 'null';
                    
                    behavioralconsequencename = currtrial{12};
                    behavioralconsequenceid = DBget_behavioralconsequence(conn, ['behavioralconsequencename = ' DBtool_num2strNULL(behavioralconsequencename)]);
                    if isempty(behavioralconsequenceid) %write the behavioralconsequence to the database if it doesn't exist   %TODO: write this function
                        [query, anerror, errormsg, output] = DBadd_behavioralconsequence(conn, behavioralconsequencename);
                        behavioralconsequenceid = output;
                        if anerror == 1
                            zz=1;
                        end
                    end
                    
                    eventcode1 = behavioralconsequenceid;
                    eventcode2 = 'null';
                    eventcode3 = 'null';
                    eventcode4 = 'null';
                    
                    [query, anerror, errormsg, output] = DBadd_trialevent(conn, trialid, eventtime, trialeventtypeid, eventcode1, eventcode2, eventcode3, eventcode4);
                    
                    trialeventid = output;
                    if anerror == 1
                        zz=1;
                    end
                    trialeventids{infonum}{trialnum} = [trialeventids{infonum}{trialnum} ; trialeventid];
                end
            end
        end
        
    end
end
end

function [outtimestamp] = gettrialtimestamp(trial,unit)

[year month day] = yearmonthday(trial{2},unit);

[hours minutes seconds milliseconds] = hoursminutesseconds(trial{3});

outtimestamp = sprintf('%s-%s-%s %s:%s:%s.%s%s',num2str(year),num2str(month),num2str(day),num2str(hours),num2str(minutes),num2str(seconds),num2str(milliseconds));

end

function [year month day] = yearmonthday(SMdate,unit)
%[year month day] = yearmonthday(SMdate)

if length(SMdate) == 10
    year = SMdate(1:4);
    month = SMdate(6:7);
    day = SMdate(9:10);
    
elseif length(SMdate) == 8
    
    if any(strcmp(unit.subject,{'st515','st517','st503'}))  %'06-12-09' ie MM-DD-YY (st515,st517)
        
        year = ['20' SMdate(7:8)];
        month = SMdate(1:2);
        day = SMdate(4:5);
        
    else % '10-08-19' ie YY-MM-DD (st423, st575,st531) - presumably all new birds unless the s2mat code changes
        
        year = ['20' SMdate(1:2)];
        month = SMdate(4:5);
        day = SMdate(7:8);
        
    end
    
else
    error('huh?!');
end

end

function [hours minutes seconds milliseconds microseconds] = hoursminutesseconds(ssm)
%[hours mins secs msec] = hsm(secondssincemidnight)

hours = floor(ssm / (60*60));

minutes = floor((ssm - hours*60*60)/60);

seconds = floor(ssm - hours*60*60 - minutes*60);

milliseconds = floor((ssm - hours*60*60 - minutes*60 - seconds)*1000);

microseconds = floor((ssm - hours*60*60 - minutes*60 - seconds - milliseconds/1000)*1000000);

end


