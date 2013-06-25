function [setcalcids cellid] = DBget_setcalc_cell(conn,cellid)
%[setcalcid cellid] = DBget_setcalc_cell(conn,cellid)

if length(cellid) ~= 1
    error('provided more than one cellid')
end

[firsttrialtime lasttrialtime] = DBget_firstlasttrialtimes(conn,cellid);
subjectid = DBget_subject_cell(conn,cellid);


query = ['SELECT DISTINCT setcalc.setcalcid FROM setcalc '...
        ' WHERE setcalc.subjectid = ' DBtool_num2strNULL(subjectid) ...
        ' AND setcalc.starttime >= ' DBtool_num2strNULL(DBtool_tstampfromdatenum(datenum(firsttrialtime))) ...
        ' AND setcalc.endtime <= ' DBtool_num2strNULL(DBtool_tstampfromdatenum(datenum(lasttrialtime)))];
    
setcalcids = cell2mat(DBx(conn,query));

end


