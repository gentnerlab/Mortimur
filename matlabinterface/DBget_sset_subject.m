function sset = DBget_sset_subject(conn,subjectid)
% sset = DBget_sset_subject(conn,subjectid)

sset = DBget_sset_setcalc(conn,DBget_setcalc_subject(conn,subjectid));

end