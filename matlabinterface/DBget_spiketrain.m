function  [ID, allData] = DBget_spiketrain(conn, selectionfilter)
%[ID, allData] = DBget_spiketrain(conn, selectionfilter)
% REMEMBER that a spiketrain is UNIQUELY defined by (trialid AND cellid)

query = ['SELECT spiketrainid, trialid, sortid, cellid, spiketimes, spikecount FROM spiketrain WHERE ' selectionfilter ' ORDER BY trialid, spiketrainid'];

curs = exec(conn, query);

if (isempty(curs.Message))
    data = fetch(curs);
    errormsg = '';
    close(curs);
else
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    error(['Error retreiving subject data: ' errormsg]);
end

if (strcmp(data.Data{1}, 'No Data'))
    allData = {};
    ID = [];
else
    allData = data.Data;
    ID = cell2mat(data.Data(:,1));
end

end