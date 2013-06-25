function [newprotocolids] = DBprocess_insertprotocolinfofromepochname(conn)

%% add protocols to DB
% epochidepochname = DBget_x(conn,'SELECT DISTINCT epochid, epochname, subjectid FROM epoch WHERE epochid > 0 ORDER BY epochid'); %use this to process WHOLE DB - careful!
epochidepochname = DBget_x(conn,'SELECT DISTINCT epochid, epochname, subjectid FROM epoch WHERE epochid > 0 AND epoch.protocolid = 0 ORDER BY epochid'); % use this to process only epochs with unknown protocolids  - careful!
prottypeidname =  DBget_x(conn,'SELECT DISTINCT protocoltypeid, protocoltypename FROM protocoltype ORDER BY protocoltypeid');
protmodeidname =  DBget_x(conn,'SELECT DISTINCT protocolmodeid, protocolmodename FROM protocolmode ORDER BY protocolmodeid');
ssidname =  DBget_x(conn,'SELECT DISTINCT stimulusselectionid, stimulusselectionname FROM stimulusselection ORDER BY stimulusselectionid');

newprotocolids = [];
for i = 1:size(epochidepochname,1)
    last4 = epochidepochname{i,2}(end-3:end);
    if strcmp(last4(end),'_')
        last4 = [last4(2:end) 'X'];
    end
    
    modename = last4(1:2);
    if strcmpi(modename,'no')
        modeid = protmodeidname{strcmpi(protmodeidname(:,2),'neuralrecordingonly'),1};
    elseif strcmpi(modename,'nb')
        modeid = protmodeidname{strcmpi(protmodeidname(:,2),'neuralandbehavioralrecording'),1};
    elseif strcmpi(modename,'bo')
        modeid = protmodeidname{strcmpi(protmodeidname(:,2),'behavioralrecordingonly'),1};
    else
        modeid = protmodeidname{strcmpi(protmodeidname(:,2),'unknown'),1};
    end    
    

    ss = last4(end);
    if strcmpi(ss,'r')
        ssid = ssidname{strcmpi(ssidname(:,2),'random'),1};
    elseif strcmpi(ss,'b')
        ssid = ssidname{strcmpi(ssidname(:,2),'block'),1};
    elseif strcmpi(ss,'s')
        ssid = ssidname{strcmpi(ssidname(:,2),'sequential'),1};
    else
        ssid = ssidname{strcmpi(ssidname(:,2),'unknown'),1};
    end
    
    
    ptid = prottypeidname{strcmpi(prottypeidname(:,2),'unknown'),1};
    
    
    query = [' SELECT DISTINCT protocolid '...
            ' FROM protocol '...
            ' WHERE protocolmodeid = ' DBtool_num2strNULL(modeid)...
            ' AND protocoltypeid = ' DBtool_num2strNULL(ptid)...
            ' AND stimulusselectionid = ' DBtool_num2strNULL(ssid)...
            ' ORDER BY protocolid '];
   
    protocolid = DBget_x(conn,query);
    
   if isempty(protocolid)
       protocolname = sprintf('Generic_MODE:%s_SELECTION:%s_TYPE:%s',protmodeidname{cell2mat(protmodeidname(:,1))==modeid,2},ssidname{cell2mat(ssidname(:,1))==ssid,2},prottypeidname{cell2mat(prottypeidname(:,1))==ptid,2});
       [query, anerror, errormsg, output] = DBadd_protocol(conn, ptid, modeid, ssid, protocolname);
       protocolid = output;
       newprotocolids = [newprotocolids,protocolid];
   end   
   
   %Now update epoch table
   update(conn, 'epoch', {'protocolid'}, protocolid, ['where epochid =' DBtool_num2strNULL(epochidepochname{i,1})]);
end


end

