function [trialids cellidout] = DBget_trial_cell(conn,cellid)
%[trialids cellidout] = DBget_trial_cell(conn,cellid)

query = ['SELECT trial.trialid, cell.cellid '...
    ' FROM trial JOIN spiketrain ON spiketrain.trialid = trial.trialid '...
    ' JOIN cell ON cell.cellid = spiketrain.cellid ' ...
    ' WHERE cell.cellid in ' DBtool_inlist(cellid)];

trialcellids = cell2mat(DBget_x(conn, query));

trialids=[];
cellidout=[];
for i = 1:length(cellid)
    inds = trialcellids(:,2)==cellid(i);
    trialids = [trialids ; trialcellids(inds,1)];
    cellidout = [cellidout ; trialcellids(inds,2)];
end

end