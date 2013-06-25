function ax = DBplot_raster_spiketrains_motifs(conn,spiketrainids,motifnum,ax,codemapname,ymode)
%ax = DBplot_raster_spiketrains_motifs(conn,spiketrainids,motifnum,ax,codemapname,ymode)

if ~exist('ax','var')
    figure;
    ax=gca;
elseif ax == 0
    figure;
    ax=gca;
end

if ~exist('codemapname','var')
    codemapname = 'default';
end

if ~exist('ymode','var')
    ymode = 'reltime';
end

%check here to make sure all spiketrains are the same stimulus - otherwise
%asking for a single motif makes no sense
stimid = unique(DBget_stimid_spiketrain(conn,spiketrainids));
if length(stimid) ~= 1
    error('given spiketrainids come from different stimuli; what does motif id mean in this case?');
end

motbounds = DBget_motifboundaries_stim(conn,stimid);
if isempty(motbounds)
    if motifnum == 1
    motbounds = [0; DBget_duration_stimid(conn,stimid)];
    else
       error('no motif boundaries found'); 
    end
end


motstartstring = sprintf('ss+%2.3f',motbounds(motifnum));
motendstring = sprintf('ss+%2.3f',motbounds(motifnum+1));
[toes rastcodes yvals trange] = DBget_toescodesyvals_spiketrains(conn,spiketrainids,'starttimecode',motstartstring,'endtimecode',motendstring,'zerotimereferencecode',motstartstring,'ymode',ymode);

ax = PTplot_rastertrains(ax,toes,rastcodes,yvals,codemapname);
axrangeX(min(trange(:,1)),max(trange(:,2)));

end