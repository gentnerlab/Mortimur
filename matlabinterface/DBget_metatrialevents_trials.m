function trialeventmeta = DBget_metatrialevents_trials(conn,trialid)
%[stimname stimid trialid] = DBget_trialstim(conn,trialid)

query = ['SELECT * '...
            ' FROM trialeventmeta WHERE trialid in ' DBtool_inlist(trialid) ...
            ' ORDER BY trialid;'];

trialeventmeta = DBget_x(conn,query);


end