function DBprocessIU_sstrialprotocolmode(conn,alltrials,subjectname)


subjectid = DBget_subjectID(conn,subjectname);

%h = waitbar(0,'on trial 1');
numtrialsperreport = 100;
tic
for ct = 1:size(alltrials,1)

    if rem(ct,numtrialsperreport) == 0
        displaywhereinloop(ct,size(alltrials,1),sprintf('last %d trials took %2.2f seconds',numtrialsperreport,toc))
        tic
    end


    %waitbar(ct/size(alltrials,1),h,sprintf('on trial %d of %d',ct,size(alltrials,1)));
    %
    
    %get timestamp
    if alltrials{ct,20} == -1
        year = alltrials{ct,1};
        month = alltrials{ct,2};
        day = alltrials{ct,3};
        hours = alltrials{ct,4};
        minutes = alltrials{ct,5};
        seconds = alltrials{ct,6};
        outtimestamp = sprintf('%s-%s-%s %s:%s:%s.%s',num2str(year,'%04d'),num2str(month,'%02d'),num2str(day,'%02d'),num2str(hours,'%02d'),num2str(minutes,'%02d'),num2str(seconds,'%02d'),num2str(000));
    else
        outtimestamp = DBget_timestamp_trial(conn,alltrials{ct,20}); %grab timestamp from trial already in DB
        outtimestamp = outtimestamp{1}{1};
    end
    
    sstrialid = cell2mat(DBx(conn, ['SELECT sstrialid FROM sstrial WHERE sstrialtime = ' DBtool_num2strNULL(outtimestamp) ' AND subjectid = ' DBtool_num2strNULL(subjectid)])); %time SHOULD uniquely identify these trials...
    if isempty(sstrialid) %write the trial to the database if it doesn't exist
        DBadd_SStrialsfromalltrials(conn,alltrials(ct,:),subjectname);
        sstrialid = cell2mat(DBx(conn, ['SELECT sstrialid FROM sstrial WHERE sstrialtime = ' DBtool_num2strNULL(outtimestamp) ' AND subjectid = ' DBtool_num2strNULL(subjectid)])); %time SHOULD uniquely identify these trials...
        if isempty(sstrialid)
            error('huh!?')
        end
        
    end
    
    
    NR = alltrials{ct,10};
    BR = alltrials{ct,11};
    
    if NR == 0 && BR == 1
        pmn = 'behavioralrecordingonly';
    elseif NR == 1 && BR == 0
        pmn = 'neuralrecordingonly';
    elseif NR == 1 && BR == 1
        pmn = 'neuralandbehavioralrecording';
    else
        pmn = 'unknown';
    end
    
    protocolmodeid = cell2mat(DBx(conn,['SELECT protocolmodeid FROM protocolmode WHERE protocolmodename = ' DBtool_num2strNULL(pmn)]));
    
    columnstoupdate = {'protocolmodeid'};
    valuestoupdate = {protocolmodeid};
    
    update(conn,'sstrial',columnstoupdate,valuestoupdate,['WHERE sstrialid = ' DBtool_num2strNULL(sstrialid)]);
    
    
end
%close(h)
end