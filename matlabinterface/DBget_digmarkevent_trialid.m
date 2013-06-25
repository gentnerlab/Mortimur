function [eventtime digmarkascii digmarkcode1 trialidout] = DBget_digmarkevent_trialid(conn,trialid)
%[stimname stimid trialid] = DBget_trialstim(conn,trialid)

query = ['SELECT eventtime, eventcode1, trialid'...
    ' FROM trialevent'...
    ' WHERE trialid in ' DBtool_inlist(trialid) ...
    ' AND trialeventtypeid = 1 ' ...
    ' ORDER BY trialid, eventtime;'];

et_ec_tid = DBget_x(conn,query);

eventtime = [];
digmarkcode1 = [];
trialidout = [];
for i = 1:length(trialid)
    eventtime = [eventtime; makecolumn([et_ec_tid{cell2mat(et_ec_tid(:,3))==trialid(i),1}])];
    digmarkcode1 = [digmarkcode1; makecolumn([et_ec_tid{cell2mat(et_ec_tid(:,3))==trialid(i),2}])];
    trialidout = [trialidout; makecolumn([et_ec_tid{cell2mat(et_ec_tid(:,3))==trialid(i),3}])];
end

digmarkascii = char(digmarkcode1);

end