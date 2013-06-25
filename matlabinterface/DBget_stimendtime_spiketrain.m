function [stimendtime, spiketrainids] = DBget_stimendtime_spiketrain(conn,spiketrainids)


query = ['SELECT eventtime, spiketrainid '...
    ' FROM trialeventmeta ' ...
    ' WHERE spiketrainid in ' DBtool_inlist(spiketrainids) ...
    ' AND trialeventtypeid = 1' ...
    ' AND eventcode1 = 62 '];

tmp = cell2mat(DBx(conn, query));

stimendtime = zeros(length(spiketrainids),1);
for i = 1:length(spiketrainids)
   stimendtime(i) = tmp(tmp(:,2)==spiketrainids(i),1); 
end

end