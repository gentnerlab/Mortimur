function [metaspiketrains, spiketrainids] = DBget_metaspiketrains(conn,spiketrainids)

query = ['SELECT trialtime, spiketrainid, spikecount, spiketimes, relstarttime, relendtime, trialid, cellid, sortid, epochid, stimulusid  '...
    ' FROM spiketrainmeta '...
    ' WHERE spiketrainid in ' DBtool_inlist(spiketrainids) ...
    ' ORDER BY spiketrainid;'];

tmp = DBx(conn, query);

metaspiketrains = cell(length(spiketrainids),11);
for i = 1:length(spiketrainids)
    metaspiketrains(i,:) = tmp(cell2mat(tmp(:,2))==spiketrainids(i),:);
end

for i = 1:size(metaspiketrains, 1)
    metaspiketrains{i,4} = DBtool_JarraytoMarray(metaspiketrains{i,4});
end

end