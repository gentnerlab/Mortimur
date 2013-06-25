function [trialids subjectidout] = DBget_trial_subject(conn,subjectid)
%[trialids cellidout] = DBget_trial_cell(conn,cellid)

query = ['SELECT trial.trialid, epoch.subjectid '...
    ' FROM trial JOIN epoch ON epoch.epochid = trial.epochid '...
    ' WHERE epoch.subjectid IN ' DBtool_inlist(subjectid) ...
    ' ORDER BY trial.trialtime '];

trialsubids = cell2mat(DBget_x(conn, query));

trialids=[];
subjectidout=[];
for i = 1:length(subjectid)
    inds = trialsubids(:,2)==subjectid(i);
    trialids = [trialids ; trialsubids(inds,1)];
    subjectidout = [subjectidout ; trialsubids(inds,2)];
end

end