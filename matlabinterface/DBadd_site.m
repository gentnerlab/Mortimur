function [query, anerror, errormsg, output] = DBadd_site(conn, penetrationid, depth)

penetrationid = DBtool_num2strNULL(penetrationid);
depth = DBtool_num2strNULL(depth);


query = ['select add_site(' penetrationid ',' depth ')'];

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