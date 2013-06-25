function [query, error, errormsg, output] = DBadd_epoch(conn, starttime, endtime, epochname, protocolid, subjectid)
%[query, error, errormsg, output] = DBadd_epoch(conn, starttime, endtime, protocolid, subjectid)

starttime = DBtool_num2strNULL(starttime);
endtime = DBtool_num2strNULL(endtime);
epochname = DBtool_num2strNULL(epochname);
protocolid = DBtool_num2strNULL(protocolid);
subjectid = DBtool_num2strNULL(subjectid);

query = ['select add_epoch(' starttime ', ' endtime ', ' epochname ',' protocolid ',' subjectid ');'];

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

