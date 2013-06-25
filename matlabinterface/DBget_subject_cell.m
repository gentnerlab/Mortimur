function [subjectid subjectname cellid] = DBget_subject_cell(conn, cellid)
%[subjectid subjectname cellid] = DBget_subject_cell(conn, cellid)

query = ['SELECT subject.subjectid, subject.subjectname, cell.cellid ' ...
    ' FROM cell ' ...
    ' JOIN site ON site.siteid = cell.siteid ' ...
    ' JOIN penetration ON penetration.penetrationid = site.penetrationid ' ...
    ' JOIN subject ON subject.subjectid = penetration.subjectid ' ...
    ' WHERE cell.cellid IN ' DBtool_inlist(cellid)];

tmp = DBx(conn,query);


subjectid = zeros(length(cellid),1);
subjectname = cell(length(cellid),1);
for i = 1:length(cellid)
    subjectid(i) = cell2mat(tmp(cell2mat(tmp(:,3))==cellid(i),1));
    subjectname{i} = tmp{cell2mat(tmp(:,3))==cellid(i),2};
end


end