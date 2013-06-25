function [setcalcids subjectid] = DBget_setcalc_subject(conn,subjectid)
%[setcalcid cellid] = DBget_setcalc_cell(conn,cellid)

if length(subjectid) ~= 1
    error('provided more than one subjectid')
end

query = ['SELECT DISTINCT setcalcid, starttime FROM setcalc '...
    ' WHERE setcalc.subjectid = ' DBtool_num2strNULL(subjectid) ...
    ' ORDER BY starttime '];
tmp = DBx(conn,query);

setcalcids = cell2mat(tmp(:,1));

end
