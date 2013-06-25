function sset = DBget_sset_cell(conn,cellid)
% sset = DBget_sset_subject(conn,cellid)

sset = DBget_sset_setcalc(conn,DBget_setcalc_cell(conn,cellid));

end