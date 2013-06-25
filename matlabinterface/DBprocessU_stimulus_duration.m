function DBprocessU_stimulus_duration(conn,stimulusids)


sn_sid = DBx(conn,['SELECT stimulusfilename, stimulusid FROM stimulus WHERE stimulusid IN ' DBtool_inlist(stimulusids)]);

sqlstrings = {};
for sid = 1:size(sn_sid,1)
    currstimid = sn_sid{sid,2};
    
    currdur = wavdurDB(fixfilesep([getstimlibdir filesep() sn_sid{sid,1}]));
    
    sqlstrings{sid} = ['UPDATE stimulus SET duration = ' DBtool_num2strNULL(currdur) ' WHERE stimulus.stimulusid = ' DBtool_num2strNULL(currstimid)];
    
%     
%     update(conn,'stimulus',{'duration'},{currdur},['WHERE stimulus.stimulusid = ' DBtool_num2strNULL(currstimid)]);
    
end

DBdobatch(conn,sqlstrings);

end