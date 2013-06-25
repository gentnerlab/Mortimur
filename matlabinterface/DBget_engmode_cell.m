function [engmode cellid] = DBget_engmode_cell(conn,cellid)


tmp = cell2mat(DBget_x(conn,['SELECT DISTINCT engmodeid, cellid FROM cellcalc WHERE cellid IN ' DBtool_inlist(cellid) ' ORDER BY cellid']));

engmode = zeros(length(cellid),1);
for i = 1:length(cellid)
    engmode(i) = tmp(tmp(:,2)==cellid(i),1);
end

end