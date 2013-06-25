function [epochid trialid] = DBget_epoch_trial(conn,trialid)
%[stimname stimid trialid] = DBget_trialstim(conn,trialid)

query = ['SELECT epochid, trialid'...
            ' FROM trial'...
            ' WHERE trialid IN ' DBtool_inlist(trialid) ...
            ' ORDER BY trialid;'];

epochidtrialid = DBget_x(conn,query);

epochid = zeros(length(trialid),1);
for i = 1:length(trialid)
   epochid(i) = epochidtrialid{cell2mat(epochidtrialid(:,2))==trialid(i),1};
end

end