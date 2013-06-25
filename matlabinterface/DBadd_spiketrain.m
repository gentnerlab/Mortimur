function [query, anerror, errormsg, output] = DBadd_spiketrain(conn, trialid, sortid, cellid, spiketimes, spikecount)

trialid =       DBtool_num2strNULL(trialid);
sortid =        DBtool_num2strNULL(sortid);
cellid =        DBtool_num2strNULL(cellid);
spiketimes =	DBtool_num2strNULL(spiketimes);
spikecount =	DBtool_num2strNULL(spikecount);


query = ['select add_spiketrain(' trialid ',' spikecount ',' spiketimes ',' cellid ',' sortid ')'];

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