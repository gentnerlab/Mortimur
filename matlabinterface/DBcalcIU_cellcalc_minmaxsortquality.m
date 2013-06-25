function [cellid minq maxq] = DBcalcIU_cellcalc_minmaxsortquality(conn,cellid)
%[cellidout] = DBcalcIU_cell_histologycorrectedlocation(conn,cellid)
% 'IU' indicates that the database will be '[I]nserted'/'[U]pdated' with new info

if any(size(cellid)>1)
    error('only one cell at a time please');
end

sortqualities = cell2mat(DBx(conn,['SELECT DISTINCT sortquality FROM sortmeta WHERE cellid = ' DBtool_num2strNULL(cellid)]));

minq = min(sortqualities);
maxq = max(sortqualities);

cellcalccellid = DBget_x(conn,['SELECT DISTINCT cellcalc.cellid FROM cellcalc WHERE cellcalc.cellid = ' DBtool_num2strNULL(cellid)]);
if isempty(cellcalccellid) %need to insert to cellcalc table
    maxid = DBget_x(conn,'SELECT MAX(cellcalcid) from cellcalc');
        fastinsert(conn,'cellcalc',{'cellcalcid' , 'cellid' , 'minsortquality' , 'maxsortquality'},{maxid{1}+1, cellid, minq, maxq});
else %need to update cellcalc table
    columnstoupdate = {'minsortquality' , 'maxsortquality'};
    valuestoupdate = {minq , maxq};
    update(conn,'cellcalc',columnstoupdate,valuestoupdate,['WHERE cellid IN ' DBtool_inlist(cell2mat(cellcalccellid))]);
end


end