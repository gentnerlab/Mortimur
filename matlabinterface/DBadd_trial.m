function [query, anerror, errormsg, output] = DBadd_trial(conn, epochid, stimulusplaybackrate, stimulusid, relstarttime, relendtime, trialtime)

    epochid =               DBtool_num2strNULL(epochid);
    stimulusplaybackrate =	DBtool_num2strNULL(stimulusplaybackrate);
    stimulusid =            DBtool_num2strNULL(stimulusid);
    relstarttime =          DBtool_num2strNULL(relstarttime,'double4places');
    relendtime =            DBtool_num2strNULL(relendtime,'double4places');
    trialtime =             DBtool_num2strNULL(trialtime);

query = ['select add_trial(' epochid ',' stimulusplaybackrate ',' stimulusid ',' relstarttime ',' relendtime ',' trialtime ')'];

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