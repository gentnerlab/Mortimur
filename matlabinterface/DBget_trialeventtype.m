function  [ID, allData] = DBget_trialeventtype(conn, selectionfilter)
%[ID, allData] = DBget_trialeventtype(conn, selectionfilter)

if strcmp(selectionfilter,'all')
query = ['SELECT trialeventtypeid, trialeventtypename FROM trialeventtype'];
else
query = ['SELECT trialeventtypeid, trialeventtypename FROM trialeventtype WHERE ' selectionfilter ' ORDER BY trialeventtypename'];
end

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