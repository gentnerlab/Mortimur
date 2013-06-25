function [metatrialevents, query, anerror, errormsg] = DBget_metatrialevents(conn,trialeventids)

query = ['SELECT trialtime, spiketrainid, eventtime, trialeventid, trialeventtypeid, eventcode1, eventcode2, eventcode3, eventcode4, cellid, epochid, stimulusid  '...
    ' FROM trialeventmeta '...
    ' WHERE trialeventid in ' DBtool_inlist(trialeventids) ...
    ' ORDER BY trialtime, spiketrainid, eventtime, trialeventid;'];

[metatrialevents, query, anerror, errormsg] = DBget_x(conn, query);

end