function DBprocessIU_trialcalcnontrainingstimblanks(conn,trialcalcid)

%SO SUPER SLOW - why not batch it?

if ~exist('trialcalcid','var')
tcid = cell2mat(DBx(conn,'SELECT trialcalcid from trialcalc'));
else
    tcid = trialcalcid;
end

for i = 1:length(tcid)
    currid = tcid(i);
    
    nts = cell2mat(DBx(conn,['SELECT nontrainingstim FROM trialcalc WHERE trialcalcid = ' DBtool_num2strNULL(currid)]));
    
    if isnan(nts)
       columnstoupdate = {'nontrainingstim'};
        valuestoupdate = {0};
        update(conn,'trialcalc',columnstoupdate,valuestoupdate,['WHERE trialcalcid IN ' DBtool_inlist(currid)]);
    end
end