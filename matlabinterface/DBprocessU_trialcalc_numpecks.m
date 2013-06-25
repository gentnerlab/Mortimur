function DBprocessU_trialcalc_numpecks(conn,trialcalcids)


tet_digmark = cell2mat(DBx(conn,'SELECT trialeventtypeid FROM trialeventtype WHERE trialeventtypename = ''digitalmarker''  '));

peckcodes = [76 67 82]; %{'R' 'L' 'C'}


for trid = 1:length(trialcalcids)
    currtrialcalcid = trialcalcids(trid);
    
    pecks = DBx(conn,['SELECT trialeventid FROM trialevent JOIN trialcalc ON trialcalc.trialid = trialevent.trialid WHERE trialevent.trialid = ' DBtool_num2strNULL(currtrialcalcid) ' AND trialeventtypeid = ' DBtool_num2strNULL(tet_digmark) ' AND trialevent.eventcode1 IN ' DBtool_inlist(peckcodes)]);
    
    update(conn,'trialcalc',{'numpecks'},{numel(pecks)},['WHERE trialcalc.trialid = ' DBtool_num2strNULL(currtrialcalcid)]);
    
    
end

end