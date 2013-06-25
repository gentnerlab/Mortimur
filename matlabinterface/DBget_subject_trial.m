function [subjectid subjectname trialidout] = DBget_subject_trial(conn, trialid)
%[subjectid subjectname cellid] = DBget_subject_cell(conn, cellid)

query = ['SELECT subject.subjectid, subject.subjectname, trial.trialid ' ...
    ' FROM trial ' ...
    ' JOIN epoch ON epoch.epochid = trial.epochid ' ...
    ' JOIN subject ON subject.subjectid = epoch.subjectid ' ...
    ' WHERE trial.trialid IN ' DBtool_inlist(trialid)];

tmp = DBx(conn,query);


subjectid = zeros(length(trialid),1);
subjectname = cell(length(trialid),1);
trialidout = zeros(length(trialid),1);
for i = 1:length(trialid)
    subjectid(i) = cell2mat(tmp(cell2mat(tmp(:,3))==trialid(i),1));
    subjectname{i} = tmp{cell2mat(tmp(:,3))==trialid(i),2};
    trialidout(i) = tmp{cell2mat(tmp(:,3))==trialid(i),3};
end

end