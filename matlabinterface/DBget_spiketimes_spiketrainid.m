function  [spiketimes, spiketrainidout] = DBget_spiketimes_spiketrainid(conn, spiketrainid)
%[spiketimes, spiketrainidout] = DBget_spiketimes_spiketrainid(conn, spiketrainid)

query = ['SELECT spiketrain.spiketrainid, spiketrain.spiketimes '...
    ' FROM spiketrain '...
    ' WHERE spiketrainid in ' DBtool_inlist(spiketrainid)];

spiketrainidsspiketimes = DBx(conn, query);

sptmp = cell2mat(spiketrainidsspiketimes(:,1));

spiketrainidout=nan(size(spiketrainidsspiketimes,1),1);
spiketimes = cell(size(spiketrainidsspiketimes,1),1);
for i = 1:length(spiketrainid)
    ind = sptmp==spiketrainid(i);
    spiketrainidout(i) = spiketrainidsspiketimes{ind,1};
    spiketimes{i} = DBtool_JarraytoMarray(spiketrainidsspiketimes{ind,2});
end

end
