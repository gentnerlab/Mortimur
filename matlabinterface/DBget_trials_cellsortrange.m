function [trialids cellidout sortqualout] = DBget_trials_cellsortrange(conn,cellid,sortrange)
%[trialids cellidout] = DBget_trial_cell(conn,cellid)

query = ['SELECT DISTINCT trial.trialid, cell.cellid, sort.sortquality '...
    ' FROM trial '...
    ' JOIN spiketrain ON spiketrain.trialid = trial.trialid '...
    ' JOIN cell ON cell.cellid = spiketrain.cellid ' ...
    ' JOIN sort ON sort.sortid = spiketrain.sortid ' ...
    ' WHERE cell.cellid in ' DBtool_inlist(cellid) ...
    ' AND sort.sortquality BETWEEN ' DBtool_num2strNULL(sortrange(1)) ' AND ' DBtool_num2strNULL(sortrange(2))];

trialcellidsortqual = cell2mat(DBx(conn, query));

trialids=[];
cellidout=[];
sortqualout=[];
for i = 1:length(cellid)
    inds = trialcellidsortqual(:,2)==cellid(i);
    trialids = [trialids ; trialcellidsortqual(inds,1)];
    cellidout = [cellidout ; trialcellidsortqual(inds,2)];
    sortqualout = [sortqualout ; trialcellidsortqual(inds,3)];
end


end