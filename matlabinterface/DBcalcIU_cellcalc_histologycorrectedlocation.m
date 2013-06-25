function [cellid] = DBcalcIU_cellcalc_histologycorrectedlocation(conn,cellid)
%[cellidout] = DBcalcIU_cell_histologycorrectedlocation(conn,cellid)
% 'IU' indicates that the database will be '[I]nserted'/'[U]pdated' with new info
% check out: DBtool_histology.m


if any(size(cellid)>1)
   error('only one cell at a time please'); 
end

siteid = cell2mat(DBx(conn,['SELECT siteid FROM cell WHERE cellid = ' DBtool_num2strNULL(cellid)]));

%get penetration , depth 

peniddepth = cell2mat(DBx(conn,['SELECT penetrationid, depth FROM site WHERE siteid = ' DBtool_num2strNULL(siteid)]));
penid = peniddepth(1);
depth = peniddepth(2);

%check for hemisphere
currhem = DBget_x(conn,['SELECT hemispherename FROM hemisphere JOIN penetration ON penetration.hemisphereid = hemisphere.hemisphereid WHERE penetration.penetrationid = ' DBtool_num2strNULL(penid)]);
if ~strcmpi(currhem,'left')
error('have NOT coded this for right hemisphere yet. probably will have issues with the electrode pad maps for 2x2 tet');
end

%get AP, ML, correction factors
RLCrClCv = cell2mat(DBx(conn,['SELECT rostral, lateral, histologycorrectionrostral, histologycorrectionlateral, histologycorrectionventral FROM penetration WHERE penetrationid = ' DBtool_num2strNULL(penid)]));

rostral = RLCrClCv(1);
lateral = RLCrClCv(2);

Cr = RLCrClCv(3);
Cl = RLCrClCv(4);
Cv = RLCrClCv(5);


%get proper electrodepad
%issue here - some cells have multiple sorts and although bad it is
%conceivable that there might be different electrode pads attributed to each
%additionally, there are up to 4 electrode channels (stereo and tetrode sorts)
%for now: pick chan1_electrodepad. throw a warning if they differ between sorts.
%for later, code up getting the 'primarysourcechan' into the sort table -
%then the decision is made on a by cell basis during sorting.

sortids = cell2mat(DBx(conn,['SELECT DISTINCT sortid FROM sortmeta WHERE cellid = ' DBtool_num2strNULL(cellid)]));
electrodepadid = cell2mat(DBx(conn,['SELECT DISTINCT chan1_electrodepadid FROM sort WHERE sortid IN ' DBtool_inlist(sortids)]));

if length(electrodepadid) ~= 1
   warning(sprintf('found %d chan1_electrodepadids for cellid: %d\n',length(electrodepadid),cellid));
   electrodepadid = electrodepadid(1);
   zz=1;
end

%get cell electrodepad info
CxCy = cell2mat(DBx(conn,['SELECT xposition, yposition FROM electrodepad WHERE electrodepadid = ' DBtool_num2strNULL(electrodepadid)]));
Cx = CxCy(1);
Cy = CxCy(2);

%do some math
histologycorrectedposition_rostral = rostral + Cr;
histologycorrectedposition_lateral = lateral + Cl + Cx;
histologycorrectedposition_ventral = depth + Cv + Cy;




       cellcalccellid = DBx(conn,['SELECT DISTINCT cellcalc.cellid FROM cellcalc WHERE cellcalc.cellid = ' DBtool_num2strNULL(cellid)]);
    if isempty(cellcalccellid) %need to insert to cellcalc table
        maxid = DBx(conn,'SELECT MAX(cellcalcid) from cellcalc');
        columnstoinsert = {'cellcalcid' , 'cellid' , 'correctedposition_rostral' , 'correctedposition_lateral' , 'correctedposition_ventral'};
        valuestoinsert = {maxid{1}+1, cellid, histologycorrectedposition_rostral, histologycorrectedposition_lateral, histologycorrectedposition_ventral};
        fastinsert(conn,'cellcalc',columnstoinsert,valuestoinsert);
    else %need to update cellcalc table
        columnstoupdate = {'correctedposition_rostral' , 'correctedposition_lateral' , 'correctedposition_ventral'};
        valuestoupdate = {histologycorrectedposition_rostral, histologycorrectedposition_lateral, histologycorrectedposition_ventral};
        update(conn,'cellcalc',columnstoupdate,valuestoupdate,['WHERE cellid IN ' DBtool_inlist(cell2mat(cellcalccellid))]);
    end
    

end