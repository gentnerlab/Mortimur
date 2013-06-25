function [behavconsids behavconsname trialidout] = DBget_behavioralconsequence_trial(conn,trialid)
%[trialids cellidout] = DBget_trial_cell(conn,cellid)

query = ['SELECT behavioralconsequence.behavioralconsequenceid, behavioralconsequence.behavioralconsequencename, trial.trialid '...
    ' FROM trial JOIN trialevent ON trialevent.trialid = trial.trialid '...
    ' JOIN trialeventtype ON trialeventtype.trialeventtypeid = trialevent.trialeventtypeid '...
    ' JOIN behavioralconsequence ON behavioralconsequence.behavioralconsequenceid = trialevent.eventcode1 ' ...
    ' WHERE trial.trialid in ' DBtool_inlist(trialid) ...
    ' AND trialeventtype.trialeventtypename = ''behavioralconsequence'''];

btids = DBget_x(conn, query);

behavconsids=[];
behavconsname=[];
trialidout=[];
for i = 1:length(trialid)
    inds = cell2mat(btids(:,3))==trialid(i);
    behavconsids = [behavconsids ; cell2mat(btids(inds,1))];
    behavconsname = [behavconsname ; btids(inds,2)];
    trialidout = [trialidout ; cell2mat(btids(inds,3))];
end

end