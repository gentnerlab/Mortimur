function [trialtime trialid trialdatenum] = DBget_timestamp_trial(conn,trialid)
%[trialtime trialid trialdatenum] = DBget_timestamp_trial(conn,trialid)
%
%datestr((datenum(trialtime{1})),'yyyy-mm-dd HH:MM:SS.FFF')

query = ['SELECT DISTINCT trialtime, trialid FROM trial WHERE trialid IN ' DBtool_inlist(trialid)];

tmp = DBx(conn,query);

trialtime = cell(length(trialid),1);
for i = 1:length(trialid)
   trialtime(i) = tmp(cell2mat(tmp(:,2))==trialid(i),1);
end

if nargout > 2
% trialdatenum = datenum([trialtime{:}]);
trialdatenum = datenum(trialtime);
end


end