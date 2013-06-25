function [spiketrainids, cellidout, trialidout] = DBget_spiketrainids(conn,cellid,trialid)
%[spiketrainids, query, anerror, errormsg] = DBget_spiketrainids(conn,cellid,trialids)
%trialid may be omitted and all trials for the given cell will be used

if ~exist('trialid','var')
    trialid = DBget_trial_cell(conn,cellid);
end

query = ['SELECT spiketrain.spiketrainid, spiketrain.trialid, cell.cellid'...
    ' FROM trial JOIN spiketrain ON spiketrain.trialid = trial.trialid '...
    ' JOIN cell ON cell.cellid = spiketrain.cellid ' ...
    ' WHERE cell.cellid = ' DBtool_num2strNULL(cellid) ...
    ' AND spiketrain.trialid in ' DBtool_inlist(trialid) ...
    ' ORDER BY spiketrain.trialid;'];

stidcellidtrialid = DBx(conn,query);

spiketrainids = [];
trialidout = [];
cellidout = [];
for cid = 1:length(cellid)
    for tid = 1:length(trialid)
        currrows = cell2mat(stidcellidtrialid(:,2))==trialid(tid)&cell2mat(stidcellidtrialid(:,3))==cellid(cid);
        spiketrainids = [spiketrainids stidcellidtrialid{currrows,1}];
        trialidout = [trialidout stidcellidtrialid{currrows,2}];
        cellidout = [cellidout stidcellidtrialid{currrows,3}];
    end
end

end
