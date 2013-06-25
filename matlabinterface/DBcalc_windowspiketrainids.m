function [windowedspiketrains timerange codes] = DBcalc_windowspiketrainids(conn,spiketrainids,starttimecode,endtimecode,zerotimereferencecode,startendrelativetonewzero)
%[windowedspiketrains timerange codes] = DBcalc_windowspiketrainids(conn,spiketrainids,starttimecode,endtimecode,zerotimereferencecode,startendrelativetonewzero)

if ~exist('StartEndRelativetoNewZero','var');	startendrelativetonewzero   = 0;	end     %The start time and end time given by STARTIMECODE and ENDTIMECODE are relative to the native time as stored in DESTRIALS
if ~exist('zeroTimeReferenceCode','var');       zerotimereferencecode       = '<';	end     %'<' stimstart - this is the default used by reads2mat() to reference spike times to

timerange = NaN(length(spiketrainids),1);
windowedspiketrains = cell(length(spiketrainids),1);
codes = cell(length(spiketrainids),1);

[metaspiketrains] = DBget_metaspiketrains(conn,spiketrainids);
[metatrialevents] = DBget_metatrialevents(conn,DBget_trialeventidsfromspiketrainids(conn,spiketrainids));

for stNum = 1:length(spiketrainids)
    [currmetatrialevents] = metatrialevents([metatrialevents{:,2}]==spiketrainids(stNum),:);
    try
        [windowedspiketrains{stNum}, timerange(stNum), codes{stNum}] = DBcalc_windowspiketrain(metaspiketrains(stNum,:),currmetatrialevents,starttimecode,endtimecode,zerotimereferencecode,startendrelativetonewzero);
    catch ME1
        zz=1;
    end
end

end