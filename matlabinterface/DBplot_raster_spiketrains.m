function ax = DBplot_raster_spiketrains(conn,spiketrainids,ax,codemapname,ymode)

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

[toes rastcodes yvals] = DBget_toescodesyvals_spiketrains(conn,spiketrainids,'ymode',ymode);

ax = PTplot_rastertrains(ax,toes,rastcodes,yvals,codemapname);


end