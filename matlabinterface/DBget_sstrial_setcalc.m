function [sstrialids] = DBget_sstrial_setcalc(conn,setcalcid)
%[trialids cellidout] = DBget_trial_cell(conn,cellid)

if length(setcalcid) ~= 1
    error('one setcalc at a time please')
end

query = ['SELECT DISTINCT setcalc.setcalcid, subjectid, starttime, endtime FROM setcalc '...
    ' WHERE setcalc.setcalcid = ' DBtool_num2strNULL(setcalcid)];
tmp = DBx(conn,query);


query = ['SELECT sstrialid '...
    ' FROM sstrial ' ...
    ' WHERE subjectid =  ' DBtool_num2strNULL(tmp{2}) ...
    ' AND sstrialtime >= ' DBtool_num2strNULL(tmp{3}) ...
    ' AND sstrialtime <= ' DBtool_num2strNULL(tmp{4}) ...
    ' ORDER BY sstrial.sstrialid '] ;

sstrialids = cell2mat(DBget_x(conn, query));

end