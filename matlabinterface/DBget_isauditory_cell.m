function [isaud cellid] = DBget_isauditory_cell(conn,cellid)
%[isaud cellid] = DBget_isauditory_cell(conn,cellid)


tmp = cell2mat(DBx(conn,['SELECT DISTINCT byeyeaud, cellid FROM cellcalc WHERE cellid IN ' DBtool_inlist(cellid)]));

isaud = zeros(length(cellid),1);
for i = 1:length(cellid)
   isaud(i) = tmp(tmp(:,2)==cellid(i),1); 
end

end