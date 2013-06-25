function DBcalcIU_cell_pepcalc(conn,cellid)
%[pepcalcids cellidout] = DBcalcIU_cell_pepcalc(conn,cellid)
% 'IU' indicates that the database will be '[I]nserted'/'[U]pdated' with new info

[trialids cellids] = DBget_trial_cell(conn,cellid);
engmodeidname = DBx(conn,'SELECT DISTINCT engmodeid, engmodename FROM engmode ORDER BY engmodeid');
nonengid = engmodeidname{strcmp(engmodeidname(:,2),'nonengagedonly'),1};
engid = engmodeidname{strcmp(engmodeidname(:,2),'engagedonly'),1};

for cid = 1:length(cellid)
    h = waitbar(cid/length(cellid));
    currcellid = cellid(cid);
    
    query = ['SELECT trial.trialid, trial.trialtime '...
        ' FROM trial JOIN spiketrain ON spiketrain.trialid = trial.trialid '...
        ' JOIN cell ON cell.cellid = spiketrain.cellid ' ...
        ' WHERE cell.cellid in ' DBtool_inlist(currcellid) ...
        ' ORDER BY trialtime '];
    celltrialidstimes = DBx(conn,query);
    
    firsttrialtime = DBtool_tstampfromdatenum(addtodate(datenum(celltrialidstimes{1,2}),-1,'millisecond'));
    lasttrialtime = DBtool_tstampfromdatenum(addtodate(datenum(celltrialidstimes{end,2}),1,'millisecond'));
    
    
    
    cellidtrials = cell2mat(celltrialidstimes(:,1));
    
    [trialmodes cellidtrials] = DBget_engmode_trial(conn,cellidtrials);
    
    nonengTrials = cellidtrials(trialmodes == nonengid);
    engTrials = cellidtrials(trialmodes == engid);
    
    %get peps
    clear pe pp peps
    ip = trialmodes == nonengid;
    pe(ip == 0) = 'e';
    pe(ip == 1) = 'p';
    pp(1) = 1;
    pp(length(pe)) = 1;
    for i = 2:length(pe)-1
        if (pe(i-1) == 'p' && pe(i+1) == 'p') || (pe(i-1) == 'e' && pe(i+1) == 'e')
            pp(i) = 0;
        else
            pp(i) = 1;
        end
    end
    ss = find(pp);
    ss = reshape(ss,2,length(ss)/2)';
    
    peps=[];
    pepnamenum = 0;
    if ~ip(1) %always start PEP with passive. if first trial is engaged, then make first PEP empty
        pepnamenum = pepnamenum+1;
        peps = [peps; {['PEP' num2str(pepnamenum)]  []}]; 
    end
    for pepnum = 1:size(ss,1)
        pepnamenum = pepnamenum+1;
        currinds =  false(size(cellidtrials,1),1);
        currinds(ss(pepnum,1):ss(pepnum,2)) = true;
        peps = [peps ; {['PEP' num2str(pepnamenum)] cellidtrials(currinds)}];
    end
    %done getting peps
    
    
    pepnum = 0;
    for pnum = 1:size(peps,1)
        if ~isempty(peps{pnum,2})
            cellid = currcellid;
            pepnum = pepnum+1;
            firstpep = pepnum == 1;
            lastpep = pnum == size(peps,1);
            
            if firstpep == 1
                firstpep = 'TRUE';
            else
                firstpep = 'FALSE';
            end
            if lastpep == 1
                lastpep = 'TRUE';
            else
                lastpep = 'FALSE';
            end
            
            engmodeid = DBget_engmode_trial(conn,peps{pnum,2}(1));
            pepstarttime = DBtool_tstampfromdatenum(addtodate(datenum(cell2mat(DBget_timestamp_trial(conn,peps{pnum,2}(1)))),-1,'millisecond'));
            pependtime = DBtool_tstampfromdatenum(addtodate(datenum(cell2mat(DBget_timestamp_trial(conn,peps{pnum,2}(end)))),1,'millisecond'));
            
            currpepid = DBx(conn,['SELECT DISTINCT pepcalc.pepcalcid FROM pepcalc WHERE pepcalc.cellid = ' DBtool_num2strNULL(currcellid) ' AND pepcalc.pepnum = ' DBtool_num2strNULL(pepnum) ]);
            if isempty(currpepid) %need to insert to cellcalc table
                maxid = DBx(conn,'SELECT MAX(pepcalcid) from pepcalc');
                columnvals = {'pepcalcid' , 'cellid' , 'pepnum' ,'firstpep' ,'lastpep' ,'engmodeid' ,'pepstarttimestamp' ,'pependtimestamp'};
                values = {maxid{1}+1, cellid, pepnum, firstpep, lastpep, engmodeid, pepstarttime, pependtime};
                
                sqlStrings = ['INSERT INTO PEPCALC (PEPCALCID,CELLID,PEPNUM,FIRSTPEP,LASTPEP,ENGMODEID,PEPSTARTTIMESTAMP,PEPENDTIMESTAMP) VALUES ( ' num2str(maxid{1}+1) ' , ' num2str(cellid) ' , ' num2str(pepnum) ' , ' firstpep ' , ' lastpep ' , ' num2str(engmodeid) ' , ' '''' pepstarttime '''' ' , ' '''' pependtime '''' ' )'];
                DBaddbatch(conn,{sqlStrings}); %instead of fastinsert
                %                 fastinsert(conn,'pepcalc',columnvals,values);
            else %need to update cellcalc table
                zz=1;
                %                 columnvals = {'firstpep' ,'lastpep' ,'engmodeid' ,'pepstarttimestamp' ,'pependtimestamp'};
                %                 values = {firstpep, lastpep, engmodeid, pepstarttime, pependtime};
                %
                %                 whereclause = ['WHERE pepcalc.cellid = ' DBtool_num2strNULL(currcellid) ' AND pepcalc.pepnum = ' DBtool_num2strNULL(pepnum)];
                %                 update(conn,'pepcalc',columnvals,values,whereclause);
            end
            
        end
        
    end
    close(h)
    
    
end