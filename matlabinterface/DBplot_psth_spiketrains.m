function [ax,psth,xbins,ymax,start,stop,psthC] = DBplot_psth_spiketrains(conn,spiketrainids,varargin)
%[psthout,xbins,ymax] = SM_plot_psth(desTrials,varargin)
%
%


%% deal with varargin

ind = 1;
while ind <= length(varargin)
    if ischar(varargin{ind})
        switch lower(varargin{ind})
            case {'ax','axis','axes'}
                ax = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'start'}
                start = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'stop'}
                stop = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'binsize'}
                binsize = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'smoothmethod'}
                smoothmethod = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'smoothparam'}
                smoothparam = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'dobar'}
                dobar = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'doerr'}
                doerr = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'dosslines'}
                dosslines = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'dossshade'}
                dossshade = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'nolabels'}
                nolabels = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
                
            case {'legendnames'}
                legendnames = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'zeroreference'}
                zeroreference = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'linewidth'}
                linewidth = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'ymax'}
                inymax = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'psthcolor','color'}
                psthcolor = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'pstherrcolor','errcolor'}
                pstherrcolor = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'coloroverride'}
                coloroverride = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            case {'linestyle'}
                linestyle = varargin{ind+1};
                ind=ind+1; %skip next value (we already assigned it!)
            otherwise
                error(sprintf('don''t know what to do with input: %s',varargin{ind}));
        end
    end
    ind=ind+1;
end

%% deal with potential variables

if ~exist('psthcolor','var')
    [colors] = PTget_colors();
    psthcolor = colors.default;
else
    if isempty(psthcolor) || size(psthcolor,2) ~= 3
        [colors] = PTget_colors();
        psthcolor = colors.default;
    end
end
if ~exist('pstherrcolor','var')
    [colors] = PTget_colors();
    pstherrcolor = colors.defaulterr;
else
    if isempty(pstherrcolor) || size(pstherrcolor,2) ~= 3
        [colors] = PTget_colors();
        pstherrcolor = colors.defaulterr;
    end
end
if ~exist('ax','var')
    figure;
    set(gcf, 'Position', [360 635 883 286]);
    ax = gca();
    hold on
else
    if ~ax
        figure;
        set(gcf, 'Position', [360 635 883 286]);
        ax = gca();
    else
        axes(ax);
    end
    hold on
end

ranges = cell2mat(DBx(conn,['SELECT relstarttime, relendtime FROM trial WHERE trialid IN ' DBtool_inlist(DBget_trial_spiketrain(conn,spiketrainids))]));
if ~exist('stop','var');stop = min(ranges(:,2));elseif isempty(stop); stop = min(ranges(:,2)); end;
if ~exist('start','var'); start = max(ranges(:,1)); elseif isempty(start); start = max(ranges(:,1)); end;
if ~exist('nolabels','var'); nolabels = 0; end
if ~exist('dosslines','var'); dosslines = 0; end
if ~exist('dossshade','var'); dossshade = 1; end
if ~exist('inymax','var'); inymax = 0; end;
if ~exist('dobar','var')
    if ~exist('smoothmethod','var') && ~exist('smoothparam','var')
        dobar = 1;
    elseif exist('smoothmethod','var') && ~exist('smoothparam','var')
        dobar = 0;
        smoothparam = 10;
    elseif ~exist('smoothmethod','var') && exist('smoothparam','var')
        dobar = 0;
        smoothmethod = 'ma';
    else
        dobar = 0;
    end
elseif exist('smoothmethod','var') || exist('smoothparam','var')
    if dobar ~= 0
        warning('both dobar and dosmooth were indicated by inputs - defaulting to dobar');
        dobar = 1;
        smoothmethod = '';
        smoothparam = [];
    end
end;
if ~exist('smoothmethod','var'); smoothmethod = 0; end;
if ~exist('binsize','var'); binsize = 20; end;
if ~exist('linewidth','var'); linewidth = 2; end;
if ~exist('doerr','var'); doerr = 0; end;
if ~exist('zeroreference','var'); zeroreference = '<'; end;
if ~exist('coloroverride','var');coloroverride=0;end
if ~exist('linestyle','var');linestyle='-';end

%% do the PSTHing
windowedspiketrains = DBcalc_windowspiketrainids(conn,spiketrainids,start,stop,zeroreference);

if doerr == 1
    [psth xedges psthC psth_std psth_sem] = STcalc_psth(windowedspiketrains,start,stop,binsize);
else
    [psth xedges psthC] = STcalc_psth(windowedspiketrains,start,stop,binsize);
end
xbins = PTcalc_bincentersfrombinedges(xedges);

%% get proper colors
%check to see if trials are engaged or passive
engmodetrains = DBget_engmode_trial(conn,DBget_trial_spiketrain(conn,spiketrainids)); %1 = passive; 2 = engaged
color = PTget_colors();
if ~coloroverride
    if all(engmodetrains == 1)
        psthcolor = color.nonengaged;
        pstherrcolor = color.nonengagederr;
    elseif all(engmodetrains == 2)
        psthcolor = color.engaged;
        pstherrcolor = color.engagederr;
    else
        psthcolor = color.enggagedandnonengaged;
        pstherrcolor = color.enggagedandnonengagederr;
    end
end

%% do the smoothing


if dobar == 1
    bar(xbins,psth,'facecolor',psthcolor,'edgecolor',psthcolor);
    if doerr == 1
        hold on
        h = errorbar(xbins,psth,-psth_sem,+psth_sem,'color',psthcolor,'linestyle','none','marker','none');%,'facecolor',psthcolor,'edgecolor',psthcolor)
        errorbar_tick(h,0); %gets rid of the errorbar cross bars
    end
else
    if ~isempty(psth)
        psth = SM_smooth_psth(psth,xbins,smoothmethod,smoothparam);
        hold on
        %plot(xbins,psth,'color',psthcolor,'linewidth',linewidth);
        if doerr == 1
            hold on
            for repnum = 1:size(psthC,1)
                psthC(repnum,:) = SM_smooth_psth(psthC(repnum,:),xbins,smoothmethod,smoothparam);
            end
            bps = 1000/binsize;
            psth_std = std(psthC)*bps;
            psth_sem = stderr(psthC)*bps;
            %jbfill(xbins,psth'+psth_sem,psth'-psth_sem,psthcolor,'none',1,.2);
        end
    end
end



if ~isempty(psth)
    hold on
    lineheight = 1000;
    
    if zeroreference == '<'
        if dosslines == 1
            v = axis;
            %        line([0 0],[v(3) v(4)],'color',[0.3 0.3 0.3],'linewidth',2)
            line([0 0],[-lineheight lineheight],'color',[0.3 0.3 0.3],'linewidth',2)
            if size(SM_getstims(desTrials),1) == 1
                stimend = SM_get_trial_stimendtime(desTrials(1,:));
                %           line([stimend stimend],[v(3) v(4)],'color','k','linewidth',3)
                line([stimend stimend],[-lineheight lineheight],'color',[0.3 0.3 0.3],'linewidth',2)
            end
        end
        if dossshade == 1
            if size(DBget_stimid_spiketrain(conn,spiketrainids),1) == 1
                stimend = DBget_stimendtime_spiketrain(conn,spiketrainids(1));
                
                jbfill([0,stimend],[lineheight,lineheight],[-lineheight,-lineheight],[0.75 0.75 0.75],'none',1,1);
            end
        end
    end
    
    
    if doerr == 1
        hold on
        if dobar ~= 1
            jbfill(xbins,psth'+psth_sem,psth'-psth_sem,pstherrcolor,'none',1,1);
        end
        
        ymax = 1.1*max(psth(:)+psth_sem(:));
        ymax = max(ymax,inymax);
        if ymax == 0
            ymax=1;
        end
        axis([min(xbins) max(xbins) 0 ymax]);
    else
        
        ymax = 1.1*max(psth);
        ymax = max(ymax,inymax);
        if ymax == 0
            ymax=1;
        end
        inymax=ymax;
        axis([min(xbins) max(xbins) 0 ymax]);
    end
end

if ~isempty(psth)
    hold on
    
    if dobar ~= 1
        plot(xbins,psth,'color',psthcolor,'linewidth',linewidth,'linestyle',linestyle);
    end
    
end





if ~nolabels
    ylabel('sp/sec');
    xlabel('sec');
    if exist('legendnames','var')
        legend(legendnames,'location','best')
        legend('boxoff')
    end
    %title(sprintf('Subject: %s || Pen: %s || Site: %s || Unit: %d',Unit.subject,Unit.pen,Unit.site,Unit.marker),'Interpreter','none');
end



hold off

end
