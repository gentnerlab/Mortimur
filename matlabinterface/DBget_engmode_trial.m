function [engmode trialid] = DBget_engmode_trial(conn,trialid)

tmp = cell2mat(DBx(conn,['SELECT DISTINCT engmodeid, trialid FROM trialcalc WHERE trialid IN ' DBtool_inlist(trialid)]));

engmode = zeros(length(trialid),1);
for i = 1:length(trialid)
    try
   engmode(i) = tmp(tmp(:,2)==trialid(i),1); 
    catch
        keyboard
    end
end

end