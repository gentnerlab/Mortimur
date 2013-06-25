function [epochidout trialidout] = DBprocessIU_protocolntrials_nontrainingstims(conn,subjectid)
%[epochidout trialidout] = DBprocessIU_protocol_nontrainingstims(conn,subjectid,nontrainingstimids)
% 'IU' indicates that the database will be '[I]nserted'/'[U]pdated' with new info
% This function will find all the epochs with the stimuli represented by
% nontrainingstimids included and will set their protocoltype to


if any(size(subjectid)>1)
    error('only one subjectid at a time please');
end

nontrainingstimids = DBget_nontraininstims_subject(conn,subjectid);


epochidout = [];
trialidout = [];

%first get all affected epochs
query = ['SELECT DISTINCT epoch.epochid '...
    ' FROM stimulus '...
    ' JOIN trial ON trial.stimulusid = stimulus.stimulusid '...
    ' JOIN epoch ON epoch.epochid = trial.epochid ' ...
    ' JOIN subject ON subject.subjectid = epoch.subjectid ' ...
    ' WHERE subject.subjectid = ' DBtool_num2strNULL(subjectid) ...
    ' AND stimulus.stimulusid IN ' DBtool_inlist(nontrainingstimids) ...
    ' ORDER BY epoch.epochid'];
desepochs = cell2mat(DBx(conn,query));

if isempty(desepochs)
    epochidout = [];
    return;
end

nontrainstimsprotocoltypeid = cell2mat(DBx(conn,'SELECT protocoltypeid FROM protocoltype WHERE protocoltypename = ''hasnontrainingstims'' '));

for i = 1:length(desepochs)
    displaywhereinloop(i,length(desepochs),'epochsloop in DBprocessIU_protocolntrials_nontrainingstims.m')
    currepoch = desepochs(i);
    query = ['SELECT DISTINCT protocoltype.protocoltypeid'...
        ' FROM protocol '...
        ' JOIN epoch ON epoch.protocolid = protocol.protocolid ' ...
        ' JOIN protocoltype ON protocoltype.protocoltypeid = protocol.protocoltypeid ' ...
        ' WHERE epoch.epochid = ' DBtool_num2strNULL(currepoch)];
    protocoltypeid = cell2mat(DBx(conn,query));
    
    if protocoltypeid ~= nontrainstimsprotocoltypeid
        %here need to update epoch, maybe also protocol
        
        %look for proper protocol
        query = ['SELECT DISTINCT protocol.protocolmodeid, protocol.stimulusselectionid'...
            ' FROM protocol '...
            ' JOIN epoch ON epoch.protocolid = protocol.protocolid ' ...
            ' WHERE epoch.epochid = ' DBtool_num2strNULL(currepoch)];
        modeidssid = cell2mat(DBx(conn,query));
        modeid = modeidssid(1);
        ssid = modeidssid(2);
        query = ['SELECT DISTINCT protocolid'...
            ' FROM protocol '...
            ' WHERE protocolmodeid = ' DBtool_num2strNULL(modeid) ...
            ' AND stimulusselectionid = ' DBtool_num2strNULL(ssid) ...
            ' AND protocoltypeid = ' DBtool_num2strNULL(nontrainstimsprotocoltypeid)];
        protocolid = DBx(conn,query);
        
        if ~isempty(protocolid)
            %update epoch with this protocol
            columnstoupdate = {'protocolid'};
            valuestoupdate = {cell2mat(protocolid)};
            update(conn,'epoch',columnstoupdate,valuestoupdate,['WHERE epochid = ' DBtool_num2strNULL(currepoch)]);
            epochidout = [epochidout currepoch];
        else
            %make new protocol entry and then update epoch with this value
            maxid = DBx(conn,'SELECT MAX(protocolid) from protocol');
            protocolid = maxid{1}+1;
            columnstoinsert = {'protocolid' , 'protocoltypeid' , 'protocolmodeid' , 'stimulusselectionid'};
            valuestoinsert = {protocolid, nontrainstimsprotocoltypeid, modeid, ssid};
            fastinsert(conn,'protocol',columnstoinsert,valuestoinsert);
            columnstoupdate = {'protocolid'};
            valuestoupdate = {protocolid};
            update(conn,'epoch',columnstoupdate,valuestoupdate,['WHERE epochid = ' DBtool_num2strNULL(currepoch)]);
            epochidout = [epochidout currepoch];
        end
    end
    
    %now do trials
    query = ['SELECT DISTINCT trialid FROM trial WHERE epochid = ' DBtool_num2strNULL(currepoch) 'AND stimulusid IN ' DBtool_inlist(nontrainingstimids)];
    tids = cell2mat(DBx(conn,query));
    for j = 1:length(tids)
        displaywhereinloop(j,length(tids),'trialsloop in DBprocessIU_protocolntrials_nontrainingstims.m')
        
        currtrial = tids(j);
        trialcalctrialid = DBget_x(conn,['SELECT DISTINCT trialcalc.trialid FROM trialcalc WHERE trialcalc.trialid = ' DBtool_num2strNULL(currtrial)]);
        if isempty(trialcalctrialid) %need to insert to trialcalc table
            maxid = DBget_x(conn,'SELECT MAX(trialcalcid) from trialcalc');
            fastinsert(conn,'trialcalc',{'trialcalcid' , 'trialid' , 'nontrainingstim'},{maxid{1}+1, currtrial, 1});
            trialidout = [trialidout currtrial];
        else %need to update cellcalc table
            update(conn,'trialcalc',{'nontrainingstim'},{1},['WHERE trialid IN ' DBtool_inlist(cell2mat(trialcalctrialid))]);
            trialidout = [trialidout currtrial];
        end
    end
end
end