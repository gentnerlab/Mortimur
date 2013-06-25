function [query, anerror, errormsg, output] = DBadd_SStrial(conn, sstrialtime, trialid, sstriallocationid, stimulusid, stimulusclass, iscorrectiontrial, respselectionid, respaccuracyid, isreinforced, subjectid, protocolmodeid)

sstrialtime = DBtool_num2strNULL(sstrialtime);
trialid = DBtool_num2strNULL(trialid);
sstriallocationid = DBtool_num2strNULL(sstriallocationid);
stimulusid = DBtool_num2strNULL(stimulusid);
stimulusclass = DBtool_num2strNULL(stimulusclass);
iscorrectiontrial = DBtool_num2strNULL(iscorrectiontrial);
respselectionid = DBtool_num2strNULL(respselectionid);
respaccuracyid = DBtool_num2strNULL(respaccuracyid);
isreinforced = DBtool_num2strNULL(isreinforced);
subjectid = DBtool_num2strNULL(subjectid);
protocolmodeid = DBtool_num2strNULL(protocolmodeid);

query = ['select add_sstrial(' sstrialtime '::timestamp without time zone ,' trialid ',' sstriallocationid ',' stimulusid ',' stimulusclass ',' iscorrectiontrial '::boolean ,' respselectionid ',' respaccuracyid ',' isreinforced '::boolean ,' subjectid ',' protocolmodeid ')'];

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