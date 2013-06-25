function [trialid sstrialid] = DBget_trial_sstrial(conn,sstrialid)

query = ['SELECT trialid, sstrialid'...
    ' FROM sstrial'...
    ' WHERE sstrialid in ' DBtool_inlist(sstrialid)];

trialidsstrialid = cell2mat(DBx(conn,query));
trialid = nan(length(sstrialid),1);
for sn = 1:length(sstrialid)
    trialid(sn) = trialidsstrialid(trialidsstrialid(:,2)==sstrialid(sn),1);
end

end