function [engmode trialid] = DBcalcIU_trial_engmode(conn,trialid)
%[engmode trialid] = DBcalcIU_cell_engmode(conn,trialid)
% 'IU' indicates that the database will be '[I]nserted'/'[U]pdated' with new info

engmodeidname = DBget_x(conn,'SELECT DISTINCT engmodeid, engmodename FROM engmode ORDER BY engmodeid');
for i = 1:length(trialid)
    h = waitbar(i/length(trialid));
    currengmode = cell2mat(DBget_x(conn,['SELECT DISTINCT engmodeid FROM trialcalc WHERE trialcalc.trialid = ' DBtool_num2strNULL(trialid(i))]));
    
    if isempty(currengmode)
        tip = DBcalc_trialispassive(conn,trialid(i));
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
    elseif any(size(currengmode)>1)
        error('huh?');
    end
    engmode(i,1) = currengmode;
    
    trialcalctrialid = DBget_x(conn,['SELECT DISTINCT trialcalc.trialid FROM trialcalc WHERE trialcalc.trialid = ' DBtool_num2strNULL(trialid(i))]);
    if isempty(trialcalctrialid) %need to insert to trialcalc table
        maxid = DBget_x(conn,'SELECT MAX(trialcalcid) from trialcalc');
        fastinsert(conn,'trialcalc',{'trialcalcid' , 'trialid' , 'engmodeid'},{maxid{1}+1, trialid(i), engmode(i,1)});
    else %need to update cellcalc table
        update(conn,'trialcalc',{'engmodeid'},engmode(i,1),['WHERE trialid IN ' DBtool_inlist(cell2mat(trialcalctrialid))]);
    end
end

close(h)
end