function [stimulusid, spiketrainids] = DBget_stimid_spiketrain(conn,spiketrainids)


query = ['SELECT trial.stimulusid, spiketrainid '...
    ' FROM spiketrain ' ...
    ' JOIN trial ON trial.trialid = spiketrain.trialid ' ...
    ' WHERE spiketrainid in ' DBtool_inlist(spiketrainids)];

tmp = cell2mat(DBx(conn, query));


stimulusid = zeros(length(spiketrainids),1);
for i = 1:length(spiketrainids)
   stimulusid(i) = tmp(tmp(:,2)==spiketrainids(i),1); 
end

end