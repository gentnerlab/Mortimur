function  [ID, allData] = DBget_epoch(conn, selectionfilter)
%[ID, allData] = DBget_epoch(conn, selectionfilter)

query = ['SELECT epochid, starttimestamp, endtimestamp, protocolid, epochname FROM epoch WHERE ' selectionfilter];

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