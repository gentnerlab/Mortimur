function [query, anerror, errormsg, output] = DBadd_protocol(conn, protocoltypeid, protocolmodeid, stimulusselectionid, protocolname)


protocoltypeid =       DBtool_num2strNULL(protocoltypeid);
protocolmodeid =        DBtool_num2strNULL(protocolmodeid);
stimulusselectionid =        DBtool_num2strNULL(stimulusselectionid);
protocolname =	DBtool_num2strNULL(protocolname);


query = ['select add_protocol(' protocoltypeid ',' protocolmodeid ',' stimulusselectionid ',' protocolname ')'];

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