function [trialids cellidout epochidout] = DBget_trial_cellid_epochid(conn,cellid,epochid)
%[trialids cellidout] = DBget_trial_cell(conn,cellid)

query = ['SELECT trial.trialid, cell.cellid, trial.epochid'...
    ' FROM trial JOIN spiketrain ON spiketrain.trialid = trial.trialid '...
    ' JOIN cell ON cell.cellid = spiketrain.cellid ' ...
    ' WHERE cell.cellid in ' DBtool_inlist(cellid) ...
    ' AND trial.epochid in ' DBtool_inlist(epochid) ...
    ' ORDER BY trial.trialid ' ];

trialcellidsepochids = cell2mat(DBget_x(conn, query));

trialids=[];
cellidout=[];
epochidout=[];
for i = 1:length(cellid)
    for j = 1:length(epochid)
    inds = trialcellidsepochids(:,2)==cellid(i) & trialcellidsepochids(:,3)==epochid(j);
    trialids = [trialids ; trialcellidsepochids(inds,1)];
    cellidout = [cellidout ; trialcellidsepochids(inds,2)];
    epochidout = [epochidout ; trialcellidsepochids(inds,3)];
    end
end

end