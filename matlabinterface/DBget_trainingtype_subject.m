function [trainingtypeid trainingtypename subjectidout] = DBget_trainingtype_subject(conn, subjectid)
%[trainingtypeid trainingtypename subjectidout] = DBget_trainingtype_subject(conn, subjectid)

query = ['SELECT trainingtype.trainingtypeid, trainingtype.trainingtypename, subject.subjectid ' ...
    ' FROM subject ' ...
    ' JOIN trainingtype ON trainingtype.trainingtypeid = subject.trainingtypeid ' ...
    ' WHERE subject.subjectid IN ' DBtool_inlist(subjectid)];

tmp = DBx(conn,query);


trainingtypeid = zeros(length(subjectid),1);
trainingtypename = cell(length(subjectid),1);
subjectidout = zeros(length(subjectid),1);
for i = 1:length(subjectid)
    trainingtypeid(i) = cell2mat(tmp(cell2mat(tmp(:,3))==subjectid(i),1));
    trainingtypename{i} = tmp{cell2mat(tmp(:,3))==subjectid(i),2};
    subjectidout(i) = tmp{cell2mat(tmp(:,3))==subjectid(i),3};
end

end