function  [ID, allData] = DBget_trial(conn, selectionfilter)
%[ID, allData] = DBget_trial(conn, selectionfilter)

query = ['SELECT trialid, epochid, stimulusid, trialtime, relstarttime, relendtime, stimulusplaybackrate FROM trial WHERE ' selectionfilter ' ORDER BY trialtime'];

curs = exec(conn, query);

if (isempty(curs.Message))
    data = fetch(curs);
    errormsg = '';
    close(curs);
else
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    error(['Error retreiving trial data: ' errormsg]);
end

if (strcmp(data.Data{1}, 'No Data'))
    allData = {};
    ID = [];
else
    allData = data.Data;
    ID = cell2mat(data.Data(:,1));
end

end