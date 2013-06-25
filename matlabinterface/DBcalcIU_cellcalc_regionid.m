function [cellid] = DBcalcIU_cellcalc_regionid(conn,cellid)
%[cellidout] = DBcalcIU_cell_histologycorrectedlocation(conn,cellid)
% 'IU' indicates that the database will be '[I]nserted'/'[U]pdated' with new info

if any(size(cellid)>1)
    error('only one cell at a time please');
end

siteid = cell2mat(DBx(conn,['SELECT siteid FROM cell WHERE cellid = ' DBtool_num2strNULL(cellid)]));

%get penetration , depth

penid = cell2mat(DBx(conn,['SELECT penetrationid FROM site WHERE siteid = ' DBtool_num2strNULL(siteid)]));

%get cm bounds
CMtCMb = cell2mat(DBx(conn,['SELECT cmtop, cmbottom FROM penetration WHERE penetrationid = ' DBtool_num2strNULL(penid)]));

CMt = CMtCMb(1);
CMb = CMtCMb(2);


% get cell depth
rostrallateralventral = cell2mat(DBx(conn,['SELECT DISTINCT correctedposition_rostral, correctedposition_lateral, correctedposition_ventral FROM cellcalc WHERE cellid = ' DBtool_num2strNULL(cellid)]));
rostral = rostrallateralventral(1);
lateral = rostrallateralventral(2);
ventral = rostrallateralventral(3);

if (ventral <= CMt)
    calcregion = 'HPC';
elseif (ventral > CMt) && (ventral <= CMb)
    calcregion = 'CM'; %add in lateral to narrow it to CMM or CLM
elseif (ventral > CMb)
    calcregion = 'FieldL'; %add in lateral to narrow it to CMM or CLM
end


%get region data
regionidregionname = DBx(conn,['SELECT DISTINCT regionid, regionname FROM region ORDER BY regionid']);

regionid = regionidregionname{strcmpi(calcregion,regionidregionname(:,2)),1};


cellcalccellid = DBx(conn,['SELECT DISTINCT cellcalc.cellid FROM cellcalc WHERE cellcalc.cellid = ' DBtool_num2strNULL(cellid)]);
if isempty(cellcalccellid) %need to insert to cellcalc table
    error();
else %need to update cellcalc table
    columnstoupdate = {'regionid'};
    valuestoupdate = {regionid};
    update(conn,'cellcalc',columnstoupdate,valuestoupdate,['WHERE cellid IN ' DBtool_inlist(cell2mat(cellcalccellid))]);
end


end