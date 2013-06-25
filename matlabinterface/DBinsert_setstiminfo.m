function DBinsert_setstiminfo(conn, subjectinfofile)
%

[subjectinfodata, subjectname] = SM_readsubjectinfofile(subjectinfofile);

subjectid = DBget_subjectID(conn,lower(subjectname));
if isempty(subjectid)
   error('ADD SUBJECT MANUALLY - INCLUDING TRANING STIMS'); 
end

%%

pendat = subjectinfodata(strcmp('Penetration',subjectinfodata(:,6)),:);
etrodedat = subjectinfodata(strcmp('Electrode',subjectinfodata(:,6)),:);
sitedat = subjectinfodata(strcmp('Site',subjectinfodata(:,6)),:);
epochdat = subjectinfodata(strcmp('Epoch',subjectinfodata(:,6)),:);
sessiondat = subjectinfodata(strcmp('Session',subjectinfodata(:,6)),:);
epochdat = [epochdat;sessiondat];
newsetstimfiledat = subjectinfodata(strcmp('NewSetStimFile',subjectinfodata(:,6)),:);

for i=1:size(pendat,1)
   ptime(i) = datenum(convertSMdatetoISOdate(pendat{i,5})); 
end
for i=1:size(etrodedat,1)
   etime(i) = datenum(convertSMdatetoISOdate(etrodedat{i,5})); 
end
for i=1:size(sitedat,1)
   stime(i) = datenum(convertSMdatetoISOdate(sitedat{i,5})); 
end

%% do Epochs
for i=1:size(epochdat,1)
    
    %%%get starttime
    starttime = convertSMdatetoISOdate(epochdat{i,5});
    
    %%%get endtime
    if i ~= size(epochdat,1) %consider end of the epoch to be one second before the start of the next epoch
        endtime = datestr(addtodate(datenum(convertSMdatetoISOdate(epochdat{i+1,5})),-1,'second'),31); %this subtracts a second from the start time of the next epoch
    else %consider end of the epoch to be 11:59 PM the day the epoch started
        dv = datevec(datenum(convertSMdatetoISOdate(epochdat{i,5})));
        t = datenum(dv(1:3)); %get just the day the epoch started
        t = addtodate(t,1,'day'); %add a day
        justbeforemidnight = addtodate(t,-1,'second'); %subtract a second
        
        endtime = datestr(justbeforemidnight,31);
    end
    
    %%%get epochname
    epochname = epochdat{i,7};
    
    %%%get protocolid
    protocolid = 0; %for now, no good way to do this automatically...
    
    %%%get subjectid
    %for now, no good way to do this automatically... see top of m file for value
    
    
    
    if isempty(DBget_epoch(conn, ['starttimestamp = ''' starttime ''''])) %write the epoch to the database if it doesn't exist
        fprintf(1,'adding epoch: starttime %s\n',starttime);
    [query, err, errormsg, output] = DBadd_epoch(conn, starttime, endtime, epochname, protocolid, subjectid);
    end
    
end
%
%

%% do Pens/Electrodes/Sites

for i=1:size(pendat,1)
    
    %%%get penname
    penname = pendat{i,7};
    
    %%%get hemisphere
    if findstr('lft',lower(penname)) || findstr('left',lower(penname)) || findstr('lt',lower(penname))
        hemisphere = 'Left';
    elseif findstr('rgt',lower(penname)) || findstr('right',lower(penname)) || findstr('rt',lower(penname))
        hemisphere = 'Right';
    else
        hemisphere = 'Unknown';
    end
    
    %%%get AP
    aptmp = regexp(penname,'AP\d+_','match','once');
    AP = aptmp(3:end-1);
    
    %%%get ML
    mltmp = regexp(penname,'_ML\d+','match','once');
    ML = mltmp(4:end);
    
    %%%get hemisphereid
    
    hemisphereid = DBget_hemisphereID(conn, hemisphere);

    %%%get electrodeID
    %find proper electrode for this pen
    if i~=size(pendat,1)
       eid = find(ptime(i)<etime & etime<ptime(i+1));
    else
       eid = find(ptime(i)<etime);
    end
    
    ename = etrodedat{eid,7};
    tmpeind = regexp(ename,'_ID_');
    eSN = ename(tmpeind+4:end);
    
    electrodeid = DBget_electrodeID(conn,eSN);
    
    %%%get angles 
    %for now - there is no angle information - inputting 'null'
    alphaangle      = 'null';
    betaangle       = 'null';
    rotationangle   = 'null';
    
    %%%get hist stuff
    %for now - there is no histology information - inputting 'null'
    histcorrAP  = 'null';
    histcorrML  = 'null';
    histcorrDV  = 'null';
    cmtop       = 'null';
    cmbottom    = 'null';
    
    %write pen
    if isempty(DBget_penetrationID(conn, subjectid, AP, ML)) %write the penetration to the database if it doesn't exist
    fprintf(1,'adding penetration: subjectid:%d\tAP:%d\tML:%d\n',subjectid, AP, ML);
        [query, err, errormsg, output] = DBadd_penetration(conn, subjectid, AP, ML, hemisphereid, electrodeid, alphaangle, betaangle, rotationangle, histcorrAP, histcorrML, histcorrDV, cmtop, cmbottom);
    end
    
    %get curr pen DB ID
    penID = DBget_penetrationID(conn,subjectid,AP,ML);
    
    %do sites for this penetration
    %find all sites for this pen
    if i~=size(pendat,1)
       sid = find(ptime(i)<stime & stime<ptime(i+1));
    else
       sid = find(ptime(i)<stime);
    end
    
    %sitesloop
    for j = 1:length(sid)
        tmpdepth = regexp(sitedat{sid(j),7},'_Z\d+','match','once');
        sdepth = tmpdepth(3:end);
        
        if isempty(DBget_siteID(conn, penID, sdepth)) %write the site to the database if it doesn't exist
         fprintf(1,'adding site: penid:%d\tdepth:%d\n',penID, sdepth);
            [query, err, errormsg, output] = DBadd_site(conn, penID, sdepth);
        end
    end
    
end


end
