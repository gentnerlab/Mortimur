function [trialid, spiketrainids] = DBget_trial_spiketrain(conn,spiketrainids)


query = ['SELECT trialid, spiketrainid '...
    ' FROM spiketrain ' ...
    ' WHERE spiketrainid in ' DBtool_inlist(spiketrainids)];

tmp = cell2mat(DBx(conn, query));

trialid = nan(length(spiketrainids),1);
for i = 1:length(spiketrainids)
    try
   trialid(i) = tmp(tmp(:,2)==spiketrainids(i),1); 
    end
end

end