function [sset setcalcid] = DBget_sset_setcalc(conn,setcalcid)
%[setcalcid cellid] = DBget_setcalc_cell(conn,cellid)


sset = struct('setcalcid',[],'subjectid',[],'starttime',[],'endtime',[],'OTL',[],'OTR',[],'NTL',[],'NTR',[]);

for sn = 1:length(setcalcid)
    
    query = ['SELECT DISTINCT setcalc.setcalcid, subjectid, starttime, endtime FROM setcalc '...
        ' WHERE setcalc.setcalcid = ' DBtool_num2strNULL(setcalcid(sn)) ...
        ' ORDER BY starttime'];
    setcalc = DBx(conn,query);
    
    sset(sn).setcalcid = setcalc{1};
    sset(sn).subjectid = setcalc{2};
    sset(sn).starttime = setcalc{3};
    sset(sn).endtime = setcalc{4};
    
    setclassinfo = DBx(conn,'SELECT * FROM setclass');
    
    OTLclassid = setclassinfo{ismember(setclassinfo(:,2),'OTL'),1};
    OTLquery = ['SELECT stimulusid FROM setcalcstims '...
        ' WHERE setcalcid = ' DBtool_num2strNULL(setcalcid(sn)) ...
        ' AND setclassid = ' DBtool_num2strNULL(OTLclassid) ...
        ' ORDER BY stimulusid '];
    sset(sn).OTL = cell2mat(DBx(conn,OTLquery));
    
    OTRclassid = setclassinfo{ismember(setclassinfo(:,2),'OTR'),1};
    OTRquery = ['SELECT stimulusid FROM setcalcstims '...
        ' WHERE setcalcid = ' DBtool_num2strNULL(setcalcid(sn)) ...
        ' AND setclassid = ' DBtool_num2strNULL(OTRclassid) ...
        ' ORDER BY stimulusid '];
    sset(sn).OTR = cell2mat(DBx(conn,OTRquery));
    
    NTLclassid = setclassinfo{ismember(setclassinfo(:,2),'NTL'),1};
    NTLquery = ['SELECT stimulusid FROM setcalcstims '...
        ' WHERE setcalcid = ' DBtool_num2strNULL(setcalcid(sn)) ...
        ' AND setclassid = ' DBtool_num2strNULL(NTLclassid) ...
        ' ORDER BY stimulusid '];
    sset(sn).NTL = cell2mat(DBx(conn,NTLquery));
    
    NTRclassid = setclassinfo{ismember(setclassinfo(:,2),'NTR'),1};
    NTRquery = ['SELECT stimulusid FROM setcalcstims '...
        ' WHERE setcalcid = ' DBtool_num2strNULL(setcalcid(sn)) ...
        ' AND setclassid = ' DBtool_num2strNULL(NTRclassid) ...
        ' ORDER BY stimulusid '];
    sset(sn).NTR = cell2mat(DBx(conn,NTRquery));
    
    sset(sn).sstrialid = DBget_sstrial_setcalc(conn,setcalcid(sn));   
end

end


