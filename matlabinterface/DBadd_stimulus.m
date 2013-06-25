function [query, error, errormsg, output] = DBadd_stimulus(conn, stimulusfilename, motifboundaries, stimulusduration)

stimulusfilename =	DBtool_num2strNULL(stimulusfilename);
motifboundaries =	DBtool_num2strNULL(motifboundaries);
stimulusduration =  DBtool_num2strNULL(stimulusduration,'double4places');

query = ['select add_stimulus(' stimulusfilename ',' motifboundaries ',' stimulusduration ')'];

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