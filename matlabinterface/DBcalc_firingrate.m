function [meanFR FR stdFR frnanfail] = DBcalc_firingrate(conn,spiketrainids,starttimecode,endtimecode,doreturnwindowedspiketrains)
%[meanFR FR stdFR frnanfail] = DBcalc_firingrate(conn,spiketrainids,starttimecode,endtimecode,doreturnwindowedspiketrains)
%starttimecode defaults to '<'
%endtimecode defaults to '>'
%starttimecode and enddtimecode can take any value that windowspikes() can take
%meanFR gives the mean firing rate over all trials
%FR gives some metadata (value for each trial, stdev, timerange, etc);

if ~exist('doreturnwindowedspiketrains','var'); doreturnwindowedspiketrains   = 0; end;
if ~exist('endtimecode','var'); endtimecode   = '>'; end;                %'>' default will be stim end
if ~exist('starttimecode','var'); starttimecode = '<'; end;                %'<' default will be stim start

timerange = NaN(length(spiketrainids),1);
windowedspiketrains = cell(length(spiketrainids),1);
codes = cell(length(spiketrainids),1);

[metaspiketrains] = DBget_metaspiketrains(conn,spiketrainids);
[metatrialevents] = DBget_metatrialevents(conn,DBget_trialeventidsfromspiketrainids(conn,spiketrainids));



for stNum = 1:length(spiketrainids)
    
    %[metatrialevents] = DBget_metatrialevents(conn,DBget_trialeventidsfromspiketrainids(conn,spiketrainids(stNum)));
    [currmetatrialevents] = metatrialevents([metatrialevents{:,2}]==spiketrainids(stNum),:);
    try
        if doreturnwindowedspiketrains == 1
            [windowedspiketrains{stNum}, timerange(stNum), codes{stNum}] = DBcalc_windowspiketrain(metaspiketrains(stNum,:),currmetatrialevents,starttimecode,endtimecode,starttimecode);
        else
            [windowedspiketrains{stNum}, timerange(stNum), codes{stNum}] = DBcalc_windowspiketrain(metaspiketrains(stNum,:),currmetatrialevents,starttimecode,endtimecode);
        end
    catch ME1
        zz=1;
    end
end

%check for nans and adjust outputs
cellnan = cellfun(@(x) any(isnan(x)),windowedspiketrains); %nans happen if DBcalc_windowspiketrain returns NaN, which happens if timerange < 0 (ie ask for 'se+3.0','endrange' and have se+3 be greater than endrange)
timerange = timerange(~cellnan);
spiketrainids = spiketrainids(~cellnan);
if nargout>3
    frnanfail = spiketrainids(cellnan); %this happens if DBcalc_windowspiketrain returns NaN, which happens if timerange < 0 (ie ask for 'se+3.0','endrange' and have se+3 be greater than endrange)
end

%get counts for each non-nan spiketrain
spikecounts = cellfun(@(x) length(x),windowedspiketrains(~cellnan));

%calc firing rates, mean, std, stderr
allFR = spikecounts./timerange;
meanFR = mean(allFR);
stdFR = std(allFR);
stderrFR = std(allFR)/(sqrt(length(allFR)));

FR.mean = meanFR;
FR.std = stdFR;
FR.stderr = stderrFR;
FR.allFR = allFR;
FR.timerange = timerange;
FR.spiketrainids = spiketrainids;
if doreturnwindowedspiketrains == 1
    FR.windowedspiketrains = windowedspiketrains(~cellnan);
end


end