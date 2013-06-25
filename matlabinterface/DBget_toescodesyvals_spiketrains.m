function [toes rastcodes yvals trange] = DBget_toescodesyvals_spiketrains(conn,spiketrainids,varargin)
%[toes rastcodes yvals] = DBget_toesncodes_spiketrain(conn,spiketrainid, varargin)
%varargin can be any of: 'starttimecode' 'endtimecode' 'zerotimereferencecode' 'ymode'
%you can pass in the exact y values you want and they will be passed right back out

%% deal with varargin
if ~isempty(varargin)
    ind = 1;
    while ind <= length(varargin)
        if ischar(varargin{ind})
            switch lower(varargin{ind})
                case {'starttimecode'}
                    starttimecode = varargin{ind+1};
                    ind=ind+1; %skip next value (we already assigned it!)
                case {'endtimecode'}
                    endtimecode = varargin{ind+1};
                    ind=ind+1; %skip next value (we already assigned it!)
                case {'zerotimereferencecode'}
                    zerotimereferencecode = varargin{ind+1};
                    ind=ind+1; %skip next value (we already assigned it!)
                case {'ymode'}
                    ymode = varargin{ind+1};
                    ind=ind+1; %skip next value (we already assigned it!)
                otherwise
                    error('don''t know what to do with input: %s',varargin{ind});
            end
        end
        ind=ind+1;
    end
end

if ~exist('starttimecode','var')
    starttimecode = 'beginrange';
end

if ~exist('endtimecode','var')
    endtimecode = 'endrange';
end

if ~exist('zerotimereferencecode','var')
    zerotimereferencecode = '<';
end

if ~exist('ymode','var')
    ymode = 'repnum';
end

%%

[metaspiketrains] = DBget_metaspiketrains(conn,spiketrainids);
[metatrialevents] = DBget_metatrialevents(conn,DBget_trialeventidsfromspiketrainids(conn,spiketrainids));
engmodetrains = DBget_engmode_trial(conn,DBget_trial_spiketrain(conn,spiketrainids)); %1 = passive; 2 = engaged



for stNum = 1:length(spiketrainids)
    
    [currmetatrialevents] = metatrialevents([metatrialevents{:,2}]==spiketrainids(stNum),:);
    
    [windowedspiketrains{stNum}, timerange(stNum), codes{stNum}] = DBcalc_windowspiketrain(metaspiketrains(stNum,:),currmetatrialevents,starttimecode,endtimecode,zerotimereferencecode);
    
    idx_cmte = cell2mat(currmetatrialevents(:,5)) == 1 & cell2mat(currmetatrialevents(:,3)) > codes{stNum}.starttime & cell2mat(currmetatrialevents(:,3)) < codes{stNum}.endtime;
    
    toes{stNum,1} = [windowedspiketrains{stNum};cell2mat(currmetatrialevents(idx_cmte,3))-codes{stNum}.zerotime];
    rastcodes{stNum,1} = [engmodetrains(stNum).*ones(size(windowedspiketrains{stNum},1),1);cell2mat(currmetatrialevents(idx_cmte,6))];
    
    trange(stNum,1) = codes{stNum}.starttime-codes{stNum}.zerotime;
    trange(stNum,2) = codes{stNum}.endtime-codes{stNum}.zerotime;
    
    if ischar(ymode)
    switch ymode
        case 'repnum'
            yvals(stNum)=stNum;
        case {'timesincemidnight','time','reltime','secsincemidnight'}
            trialtime = metaspiketrains{stNum,1};
            [Y, M, D, H, MN, S] = datevec(trialtime);
            %yvals(stNum,1) = datenum(trialtime);
            yvals(stNum) = (H*60*60+MN*60+S); %seconds since midnight
        otherwise
    end
    else
        if length(ymode) == length(spiketrainids)
            yvals=ymode;
        else
            error('if passing array of y values, there must be the same number of these as spiketrainids')
        end
    end
    
end

if strmatch(starttimecode,'beginrange')
    brange = cell2mat(DBx(conn,['SELECT relstarttime FROM trial WHERE trialid IN ' DBtool_inlist(DBget_trial_spiketrain(conn,spiketrainids))]));
    for i = 1:length(toes) 
        toes{i} = [toes{i};brange(i)];
        rastcodes{i} = [rastcodes{i};1000];
    end
end
if strmatch(endtimecode,'endrange')
    erange = cell2mat(DBx(conn,['SELECT relendtime FROM trial WHERE trialid IN ' DBtool_inlist(DBget_trial_spiketrain(conn,spiketrainids))]));
    for i = 1:length(toes) 
        toes{i} = [toes{i};erange(i)];
        rastcodes{i} = [rastcodes{i};1001];
    end
end

% dogetrangelines = 1;
% if dogetrangelines
%     ranges = cell2mat(DBx(conn,['SELECT relstarttime, relendtime FROM trial WHERE trialid IN ' DBtool_inlist(DBget_trial_spiketrain(conn,spiketrainids))]));
%     for i = 1:length(toes) 
%         toes{i} = [toes{i};ranges(i,:)'];
%         rastcodes{i} = [rastcodes{i};1000;1001];
%     end
% end

if ischar(ymode)
if strcmpi(ymode,'reltime')
    [zz,yvals] = sort(yvals,'ascend');
end
end

end