function [trialids] = DBget_trials_trainingstims_cell(conn,cellid)
%[trialids cellidout] = DBget_trial_cell(conn,cellid)

if numel(cellid) > 1
   error('only one cell at a time please!'); 
end

query = ['SELECT trial.trialid FROM trial ' ...
    ' WHERE stimulusid IN ' DBtool_inlist(DBget_trainingstims_cell(conn,cellid)) ...
    ' AND trialid IN ' DBtool_inlist(DBget_trial_cell(conn,cellid))];

trialids = cell2mat(DBget_x(conn, query));

end