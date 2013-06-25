function [ID, allData] = DBget_cellID(conn, siteid, sortmarkercode)

siteid = DBtool_num2strNULL(siteid);
sortmarkercode = ['''' DBtool_num2strNULL(sortmarkercode) ''''];

query = ['SELECT cellid FROM cell WHERE siteid = ' siteid 'AND sortmarkercode = ' sortmarkercode ];

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