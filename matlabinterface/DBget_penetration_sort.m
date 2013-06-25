function [penetrationid sortid] = DBget_penetration_sort(conn, sortid)
%[penetrationid sortid] = DBget_penetration_sort(conn, sortid)

query = ['SELECT site.penetrationid, sort.sortid ' ...
    ' FROM sort ' ...
    ' JOIN site ON site.siteid = sort.siteid ' ...
    ' WHERE sort.sortid IN ' DBtool_inlist(sortid)...
    ' ORDER BY sort.sortid'];

tmp = c2m(DBx(conn,query));

penetrationid = zeros(length(sortid),1);
for i = 1:length(sortid)
   penetrationid(i) = tmp(tmp(:,2)==sortid(i),1); 
end

end