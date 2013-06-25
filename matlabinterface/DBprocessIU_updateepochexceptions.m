function DBprocessIU_updateepochexceptions(conn)

%load EEL
EEL = fixfilesep('Z:\experiments\analysis\workingdata\EpochExceptionLibrary.csv');

ED = importdata(EEL);
EE = ED.textdata(2:end,:);

for currepc = 1:size(EE,1)
    
    %get values
    starttimestamp = EE{currepc,3};
    endtimestamp = EE{currepc,4};
    subjectname = EE{currepc,1};
    protocolname = EE{currepc,5};
    
    subjectid = DBget_subjectID(conn,subjectname);
    currprotocolid = cell2mat(DBx(conn,['SELECT protocolid FROM protocol WHERE protocolname = ' DBtool_num2strNULL(protocolname)]));
    
    epochid = DBget_epoch(conn,['starttimestamp = ' DBtool_num2strNULL(starttimestamp) ' AND endtimestamp = ' DBtool_num2strNULL(endtimestamp) ' AND subjectid = ' DBtool_num2strNULL(subjectid)]);
    
    if isempty(epochid) %this is bad, can't find epoch of interest
        error(sprintf('did not find the epoch of interest for currepc %d - this is bad\n',currepc));
    else %need to update epoch table
        columnstoupdate = {'protocolid'};
        valuestoupdate = {currprotocolid};
        update(conn,'epoch',columnstoupdate,valuestoupdate,['WHERE epochid = ' DBtool_num2strNULL(epochid)]);
    end
end


end