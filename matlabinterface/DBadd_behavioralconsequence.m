function [query, error, errormsg, output] = DBadd_behavioralconsequence(conn, behavioralconsequencename)

behavioralconsequencename =	DBtool_num2strNULL(behavioralconsequencename);

query = ['select add_behavioralconsequence(' behavioralconsequencename ')'];

curs = exec(conn, query);      
if (isempty(curs.Message))
    data = fetch(curs);
    error = 0;
    errormsg = '';
    close(curs);
    output = data.Data{1};
else
    error = 1;
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    output = [];
end

end