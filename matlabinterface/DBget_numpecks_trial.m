function [numpecks trialid] = DBget_numpecks_trial(conn,trialid)

tmp = cell2mat(DBx(conn,['SELECT DISTINCT numpecks, trialid FROM trialcalc WHERE trialid IN ' DBtool_inlist(trialid)]));

numpecks = zeros(length(trialid),1);
for i = 1:length(trialid)
   numpecks(i) = tmp(tmp(:,2)==trialid(i),1); 
end

end