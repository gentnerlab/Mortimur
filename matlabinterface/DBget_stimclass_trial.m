function [stimclass trialidout] = DBget_stimclass_trial(conn,trialid)
%[stimclass trialidout] = DBget_stimclass_trial(conn,trialid)
%this calculates stimclass based on the subjects class 1 and class 2 stims
%in the subject table
%one might also want to calculate it based on the stim marker, but I'm wary
%of getting in to this now

subjectid = DBget_subject_trial(conn,trialid);
if numel(unique(subjectid)) > 1
    error('more than one subject - code me up if you want it');
end

[stimname stimid trialidout] = DBget_stim_trial(conn,trialid);

[trainingstims class1stims class2stims] = DBget_trainingstims_subject(conn,subjectid(1));

for i = 1:numel(stimid)
    if ismember(stimid(i),class1stims)
        stimclass(i,1) = 1;
    elseif ismember(stimid(i),class2stims)
        stimclass(i,1) = 2;
    else
        stimclass(i,1) = nan;
    end
end

% query = ['SELECT behavioralconsequence.behavioralconsequenceid, behavioralconsequence.behavioralconsequencename, trial.trialid '...
%     ' FROM trial JOIN trialevent ON trialevent.trialid = trial.trialid '...
%     ' JOIN trialeventtype ON trialeventtype.trialeventtypeid = trialevent.trialeventtypeid '...
%     ' JOIN behavioralconsequence ON behavioralconsequence.behavioralconsequenceid = trialevent.eventcode1 ' ...
%     ' WHERE trial.trialid in ' DBtool_inlist(trialid) ...
%     ' AND trialeventtype.trialeventtypename = ''behavioralconsequence'''];
%
% btids = DBget_x(conn, query);
%
%
% stimclass=[];
% trialidout=[];
% for i = 1:length(trialid)
%     inds = cell2mat(btids(:,3))==trialid(i);
%     stimclass = [stimclass ; cell2mat(btids(inds,1))];
%     trialidout = [trialidout ; cell2mat(btids(inds,2))];
% end

end