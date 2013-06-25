function [epochid sstrialid] = DBget_epoch_sstrial(conn,sstrialid)
%[epochid sstrialid] = DBget_epoch_sstrial(conn,sstrialid)
%NOPE...this is a malformed idea - it's possible to have SStrials not in an
%epoch because sstrials include ndege data, which has no concept of epoch -
%well it's built in there with the infostart info end but do we really want
%to be dealing with that? especially old type ones that dont have those
%distinctions...
% 
% % get sstrialtimes, subjectids
% query = [ 'SELECT epoch.epochid, sstrial.sstrialid FROM epoch ' ...
%     ' JOIN sstrial ON (( epoch.starttimestamp , epoch.endtimestamp ) ' ...
%     ' OVERLAPS ( sstrial.sstrialtime  , INTERVAL ''1 millisecond'') ' ...
%     ' AND (sstrial.subjectid = epoch.subjectid)) ' ...
%     ' WHERE sstrialid IN ' DBtool_inlist(sstrialid) ];
% 
% epochidsstrialid = DBget_x(conn,query);
% 
% epochid = zeros(length(sstrialid),1);
% for i = 1:length(sstrialid)
%     epochid(i) = epochidsstrialid{cell2mat(epochidsstrialid(:,2))==sstrialid(i),1};
% end

end
