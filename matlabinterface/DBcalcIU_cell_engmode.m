function [engmode cellidout] = DBcalcIU_cell_engmode(conn,cellid)
%[engmode cellidout] = DBcalcIU_cell_engmode(conn,cellid)
% 'IU' indicates that the database will be '[I]nserted'/'[U]pdated' with new info

[zz,order] = sort(cellid,'ascend');

[trialids cellids] = DBget_trial_cell(conn,cellid);


[cellidout] = sort(unique(cellids),'ascend');
cellidout=cellidout(order);

engmodeidname = DBx(conn,'SELECT DISTINCT engmodeid, engmodename FROM engmode ORDER BY engmodeid');


for i = 1:length(cellidout)
    h = waitbar(i/length(cellidout));
    currengmode = DBx(conn,['SELECT DISTINCT engmode.engmodeid FROM engmode JOIN cellcalc ON cellcalc.engmodeid = engmode.engmodeid WHERE cellcalc.cellid = ' DBtool_num2strNULL(cellidout(i))]);
    
    if isempty(currengmode)
        tip = DBcalc_trialispassive(conn,trialids(cellids==cellidout(i)));
        haspass = any(tip);
        hasengaged = any(~tip);
        
        if haspass == 1
            if hasengaged == 1
                currengmodename = 'nonengagedandengaged';
            else
                currengmodename = 'nonengagedonly';
            end
        else
            currengmodename = 'engagedonly';
        end
        currengmode = engmodeidname{strcmp(currengmodename,engmodeidname(:,2)),1};
    end
    try
    engmode(i,1) = currengmode;
    catch
        zz=1;
    end
    cellcalccellid = DBx(conn,['SELECT DISTINCT cellcalc.cellid FROM cellcalc WHERE cellcalc.cellid = ' DBtool_num2strNULL(cellidout(i))]);
    if isempty(cellcalccellid) %need to insert to cellcalc table
        maxid = DBx(conn,'SELECT MAX(cellcalcid) from cellcalc');
        fastinsert(conn,'cellcalc',{'cellcalcid' , 'cellid' , 'engmodeid'},{maxid{1}+1, cellidout(i), engmode(i,1)});
    else %need to update cellcalc table
        update(conn,'cellcalc',{'engmodeid'},engmode(i,1),['WHERE cellid IN ' DBtool_inlist(cell2mat(cellcalccellid))]);
    end
    
end
close(h)
end