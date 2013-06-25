function [regionname regionid cellidout] = DBget_region_cell(conn,cellid)
%[regionname regionid cellidout] = DBget_region_cell(conn,cellid)

query = ['SELECT DISTINCT cellmeta.regionid, cellmeta.region, cellmeta.cellid '...
    ' FROM cellmeta WHERE cellmeta.cellid IN ' DBtool_inlist(cellid)];

regidregnamecellid = DBx(conn, query);

regionname={};
regionid=[];
cellidout=[];
for i = 1:length(cellid)
    inds = cell2mat(regidregnamecellid(:,3))==cellid(i);
    regionname = [regionname ; regidregnamecellid{inds,2}];
    regionid = [regionid , regidregnamecellid(inds,1)];
    cellidout = [cellidout , regidregnamecellid(inds,3)]; 
end

regionid = regionid';
cellidout = cellidout';

end