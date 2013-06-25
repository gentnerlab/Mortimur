function [trialeventids, query, anerror, errormsg] = DBget_trialeventidsfromspiketrainids(conn,spiketrainids)

query = ['SELECT trialeventid, spiketrainid '...
    ' FROM trialeventmeta ' ...
    ' WHERE spiketrainid in ' DBtool_inlist(spiketrainids) ...
    ' ORDER BY spiketrainid, trialeventid;'];

[trialeventids, query, anerror, errormsg] = DBget_x(conn, query);

trialeventids = cell2mat(trialeventids);

end