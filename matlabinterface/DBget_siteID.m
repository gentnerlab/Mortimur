function [ID, allData] = DBget_siteID(conn, penetrationID, depth)

query = ['SELECT siteid, penetrationid, depth FROM site WHERE penetrationid = ' DBtool_num2strNULL(penetrationID) 'AND depth = ' DBtool_num2strNULL(depth)];

curs = exec(conn, query);


if (isempty(curs.Message))
    data = fetch(curs);
    errormsg = '';
    close(curs);
else
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    error(['Error retreiving site data: ' errormsg]);
end

if (strcmp(data.Data{1}, 'No Data'))
    allData = {};
    ID = [];
else
    allData = data.Data;
    ID = cell2mat(data.Data(:,1));
end

end