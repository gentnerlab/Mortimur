function weirdthings = DBcalcIU_sssets_subject(conn,subjectid)
%find all sets for a subject and add then to setcalc

if numel(subjectid) > 1
    error('too many subjects')
end

weirdthings=[];

[trainingstims class1stims class2stims] = DBget_trainingstims_subject(conn,subjectid);

%get all sstrials
query = ['SELECT sstrialtime, sstrialid, stimulusid, stimulusclass, '...
    ' iscorrectiontrial, responseselectionid, responseaccuracyid, '...
    ' isreinforced, protocolmodeid '...
    ' FROM sstrial where subjectid = ' DBtool_num2strNULL(subjectid) ...
    ' ORDER BY sstrialtime '];
T = DBx(conn,query);


%get rid of neural only
neuralonlyid = cell2mat(DBx(conn,['SELECT protocolmodeid FROM protocolmode WHERE protocolmodename = ''neuralrecordingonly'' ']));
behavingTinds = cell2mat(T(:,9))~=neuralonlyid;

bT = T(behavingTinds,:);
noT = T(~behavingTinds,:);

SST_behstims=c2m(bT(:,3));
uniqueBehaviorStims = unique(SST_behstims); %now find the set that each of thse belogs to...
uniqueBehaviorStims_nontrainingstim = uniqueBehaviorStims(~ismember(uniqueBehaviorStims,trainingstims));
%first sort out trainingstims
%get time bounds of each stim and see which overlap? - this should give
%appropriate trainingstims too

Bstim = struct('stimulusid',[],'begintime',[],'endtime',[],'otherstims',[]);
for sn = 1:length(uniqueBehaviorStims_nontrainingstim)
    Bstim(sn).stimulusid = uniqueBehaviorStims_nontrainingstim(sn);
    
    start_ind = find(SST_behstims==uniqueBehaviorStims_nontrainingstim(sn),1,'first');
    end_ind = find(SST_behstims==uniqueBehaviorStims_nontrainingstim(sn),1,'last');
    
    cT = bT(start_ind:end_ind,:);
    
    Bstim(sn).begintime = cT{1,1};
    Bstim(sn).endtime = cT{end,1};
    
    Bstim(sn).otherstims.stimulusid = unique(cell2mat(bT(start_ind:end_ind,3)))';
    Bstim(sn).otherstims.istrainingstim = ismember(Bstim(sn).otherstims.stimulusid,trainingstims);
    
    for cs = 1:length(Bstim(sn).otherstims.stimulusid)
        Bstim(sn).otherstims.class(1,cs) = cT{find(cell2mat(cT(:,3))==Bstim(sn).otherstims.stimulusid(cs),1,'first'),4};
    end
    
    %here check for sanity
    if sum(~Bstim(sn).otherstims.istrainingstim) ~= 2
        fprintf(1,'got something different than 2 non-training stims\n')
        weirdthings = [weirdthings; Bstim(sn).stimulusid sn];
        %         keyboard
    end
    
    if ~any(Bstim(sn).otherstims.class==1)
        fprintf(1,'did not find a class 1 stim\n')
        weirdthings = [weirdthings; Bstim(sn).stimulusid sn];
        %         keyboard
    end
    if ~any(Bstim(sn).otherstims.class==2)
        fprintf(1,'did not find a class 2 stim\n')
        weirdthings = [weirdthings; Bstim(sn).stimulusid sn];
        %         keyboard
    end
    if ~any(Bstim(sn).otherstims.class==5)
        fprintf(1,'did not find a class 5 stim\n')
        weirdthings = [weirdthings; Bstim(sn).stimulusid sn];
        %         keyboard
    end
    if ~any(Bstim(sn).otherstims.class==6)
        fprintf(1,'did not find a class 6 stim\n')
        weirdthings = [weirdthings; Bstim(sn).stimulusid sn];
        %         keyboard
    end
    
    if any(Bstim(sn).otherstims.class==3)
        fprintf(1,'found a class 3 stim\n')
        weirdthings = [weirdthings; Bstim(sn).stimulusid sn];
        %         keyboard
    end
    if any(Bstim(sn).otherstims.class==4)
        fprintf(1,'found a class 4 stim\n')
        weirdthings = [weirdthings; Bstim(sn).stimulusid sn];
        %         keyboard
    end
    
end

if ~isempty(weirdthings)
    if ismember(subjectid,[3,7,8,14]) %these are the fixed ones, skip them
        fprintf(1,'yes we got those weird things, but they''ve been manually fixed for subjects 3, 7, 8, 14');
    else
        fprintf(1,'found weirdthings, entering debugger\n')
        %figured out subjectid=3; 2 stimuli were reused (1591,1820; probably didn't update
        %masterstimfile when bird had learned) fix for this one is to look
        %locally to find stim bounds
        % subjectid 7; 2 stimuli reused (1744,1904) these two stims were both paired with
        % eachother - but multiple times with other stims in
        % between...well...these stims are not presented with any cells ignoring them for now...
        keyboard
    end
end

%MAKE SSETS
sSet = struct('subjectid',[],'starttime',[],'endtime',[],'OTL',[],'OTR',[],'NTL',[],'NTR',[]);
bstimstim = [Bstim.stimulusid];
alreadyinset = [];
if subjectid == 3;
    alreadyinset = [1591,1820,1598,1818]; %these will be added manually by DBhack_SSCALC(conn)
end
if subjectid == 7;
    alreadyinset = [1744,1904]; %these will be added manually by DBhack_SSCALC(conn)
end
if subjectid == 8;
    alreadyinset = [1557,1612,1784,1823,1913,1921,1911,1541]; %these will be added manually by DBhack_SSCALC(conn)
end

if subjectid == 14;
    alreadyinset = [1555,1910,1923,1543,1798,1558,1778,1589,1793,1917,1604,1754,1924,1802,1933]; %these will be added manually by DBhack_SSCALC(conn) %1555 only has 2 eng trials...ignore, 1910 only 5 trials, 1923 1 trial,
end

k = 0;
for sn = 1:length(Bstim)
    %this loop assumes that each Bstim has only class 1,2,5,6 stims and that each set has exactly 1 class5 and 1 class6
    if ~ismember(Bstim(sn).stimulusid,alreadyinset);
        
        %find other Bstim
        oBstimid = Bstim(sn).otherstims.stimulusid((Bstim(sn).otherstims.class == 5 | Bstim(sn).otherstims.class == 6)&(Bstim(sn).otherstims.stimulusid ~= Bstim(sn).stimulusid));
        oBstim = Bstim(bstimstim==oBstimid);
        cBstim = Bstim(sn);
        
        k = k+1;
        sSet(k).subjectid = subjectid;
        
        sSet(k).starttime = datestr(min(datenum(oBstim.begintime),datenum(cBstim.begintime)),'yyyy-mm-dd HH:MM:SS.FFF');
        sSet(k).endtime = datestr(max(datenum(oBstim.endtime),datenum(cBstim.endtime)),'yyyy-mm-dd HH:MM:SS.FFF');
        
        sSet(k).OTL = Bstim(sn).otherstims.stimulusid(Bstim(sn).otherstims.class == 1);
        sSet(k).OTR = Bstim(sn).otherstims.stimulusid(Bstim(sn).otherstims.class == 2);
        sSet(k).NTL = Bstim(sn).otherstims.stimulusid(Bstim(sn).otherstims.class == 5);
        sSet(k).NTR = Bstim(sn).otherstims.stimulusid(Bstim(sn).otherstims.class == 6);
        
        alreadyinset = [alreadyinset,oBstim.stimulusid,cBstim.stimulusid];
    end
end

setclassinfo = DBx(conn,'SELECT * FROM setclass');
%add sSet to database
for sn = 1:length(sSet)
    
    %DBadd_setcalc(conn,sSet(sn).subjectid,sSet(sn).starttime,sSet(sn).endtime,sSet(sn).OTL,sSet(sn).OTR,sSet(sn).NTL,sSet(sn).NTR);
    
    query = ['SELECT DISTINCT setcalc.setcalcid FROM setcalc '...
        ' WHERE setcalc.subjectid = ' DBtool_num2strNULL(sSet(sn).subjectid) ...
        ' AND setcalc.starttime = ' DBtool_num2strNULL(DBtool_tstampfromdatenum(datenum(sSet(sn).starttime))) ...
        ' AND setcalc.endtime = ' DBtool_num2strNULL(DBtool_tstampfromdatenum(datenum(sSet(sn).endtime)))];
    currsetcalcid = DBx(conn,query);
    
    if isempty(currsetcalcid) %need to insert to setcalc table
        maxid = DBx(conn,'SELECT MAX(setcalcid) from setcalc');
        starttime = DBtool_tstampfromdatenum(datenum(sSet(sn).starttime));
        endtime = DBtool_tstampfromdatenum(datenum(sSet(sn).endtime));
        sqlStrings = ['INSERT INTO SETCALC (SETCALCID,SUBJECTID,STARTTIME,ENDTIME) VALUES ( ' num2str(maxid{1}+1) ' , ' num2str(subjectid) ' , ' '''' starttime '''' ' , ' '''' endtime '''' ' )'];
        DBdobatch(conn,{sqlStrings}); %instead of fastinsert
        
        currsetcalcid = cell2mat(DBx(conn,query));
        
        %         columnvals = {'setcalcid' , 'subjectid' , 'starttime' ,'endtime'};
        %         values = {maxid{1}+1, subjectid, pepnum, DBtool_tstampfromdatenum(datenum(sSet(sn).starttime)), DBtool_tstampfromdatenum(datenum(sSet(sn).endtime))};
        %         fastinsert(conn,'setcalc',columnvals,values);
        
        %add stims to setcalcstims!
        m = 0;
        clear sqlStringsscs
        %add OTL
        currclass = setclassinfo{ismember(setclassinfo(:,2),'OTL'),1};
        for i = 1:length(sSet(sn).OTL)
            m = m+1;
            sqlStringsscs{m} = ['INSERT INTO SETCALCSTIMS (SETCALCID,STIMULUSID,SETCLASSID) VALUES ( ' num2str(currsetcalcid) ' , ' num2str(sSet(sn).OTL(i)) ' , '  num2str(currclass) ' )'];
        end
        
        %add OTR
        currclass = setclassinfo{ismember(setclassinfo(:,2),'OTR'),1};
        for i = 1:length(sSet(sn).OTR)
            m = m+1;
            sqlStringsscs{m} = ['INSERT INTO SETCALCSTIMS (SETCALCID,STIMULUSID,SETCLASSID) VALUES ( ' num2str(currsetcalcid) ' , ' num2str(sSet(sn).OTR(i)) ' , '  num2str(currclass) ' )'];
        end
        
        %add NTL
        currclass = setclassinfo{ismember(setclassinfo(:,2),'NTL'),1};
        for i = 1:length(sSet(sn).NTL)
            m = m+1;
            sqlStringsscs{m} = ['INSERT INTO SETCALCSTIMS (SETCALCID,STIMULUSID,SETCLASSID) VALUES ( ' num2str(currsetcalcid) ' , ' num2str(sSet(sn).NTL(i)) ' , '  num2str(currclass) ' )'];
        end
        
        %add NTR
        currclass = setclassinfo{ismember(setclassinfo(:,2),'NTR'),1};
        for i = 1:length(sSet(sn).NTR)
            m = m+1;
            sqlStringsscs{m} = ['INSERT INTO SETCALCSTIMS (SETCALCID,STIMULUSID,SETCLASSID) VALUES ( ' num2str(currsetcalcid) ' , ' num2str(sSet(sn).NTR(i)) ' , '  num2str(currclass) ' )'];
        end
        
        DBdobatch(conn,sqlStringsscs); %instead of fastinsert
        
    else %need to update cellcalc table
        %already found this set, ignore for now, maybe add updating/checking code in future
    end
    
end

end

