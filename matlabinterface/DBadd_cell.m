function [query, anerror, errormsg, output] = DBadd_cell(conn, cellname, regionid, siteid, sortmarkercode)

siteid = DBtool_num2strNULL(siteid);
sortmarkercode = ['''' DBtool_num2strNULL(sortmarkercode) ''''];
cellname = DBtool_num2strNULL(cellname);
regionid = DBtool_num2strNULL(regionid);


query = ['select add_cell(' cellname ',' regionid ',' siteid ',' sortmarkercode ')'];

curs = exec(conn, query);      
if (isempty(curs.Message))
    data = fetch(curs);
    anerror = 0;
    errormsg = '';
    close(curs);
    output = data.Data{1};
else
    anerror = 1;
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    output = [];
end

end