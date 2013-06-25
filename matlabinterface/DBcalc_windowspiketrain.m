function [spikes timeinterval codes] = DBcalc_windowspiketrain(metaspiketrain,metatrialevent,startTimeCode,endTimeCode,zeroTimeReferenceCode,StartEndRelativetoNewZero)
%[spikes timeinterval codes] = DBcalc_windowspiketrain(metaspiketrain,metatrialevent,startTimeCode,endTimeCode,zeroTimeReferenceCode,StartEndRelativetoNewZero)
%IN GENERAL, THIS FUNCTION SHOULD ONLY BE CALLED FROM WITHIN ANOTHER FUNCTION
%   use DBcalc_windowspiketrainids.m to specify only the spiketrainids and not the metaspiketrain/metatrialevents
%
%
%STARTIMECODE can be:
%   a 1 character string   	corresponding to a digimark code
%   a scalar                this will be used as the start window time for all trials (relative to the default time reference, stimulus start, given by the code '<')
%   <NOT YET SUPPORTED IN DB VERSION> a vector                you must supply a different start time for each of desTrials (relative to the default time reference, stimulus start, given by the code '<')
%                           spike times will be referenced to the 'start' value given for each trial
%                           if used, 'endTimeCode' must be a vector of the same size
%   'beginrange'          	this will use the value of trial.relstarttime  -- the time after which spikes were included from the datafile
%   'ss###'                 this will use the start time of the stimulus + ### seconds, where ### is a string value that can be converted to a double
%                           eg. 'ss-1.23' would use 1.23 seconds before the stimulus onset as the start value
%   'se###'                 this will use the end time of the stimulus + ### seconds, where ### is a string value that can be converted to a double
%                           eg. 'ss+0.8' would use 0.8 seconds after the
%                           stimulus offset as the start value
%   'er###'                 this will use the endrange time of the trial + ### seconds, where ### is a string value that can be converted to a double
%                           eg. 'ss-0.8' would use 0.8 seconds before the endrange as the start value
%
%ENDIMECODE can be:
%   a 1 character string   	corresponding to a digimark code
%   a numerical value      	this will be used as the end window time for all trials (relative to the default time reference, stimulus start, given by the code '<')
%   <NOT YET SUPPORTED IN DB VERSION> a vector                you must supply a different stop time for each of desTrials (relative to the default time reference, stimulus start, given by the code '<')
%                           if used, 'startTimeCode' must be a vector of the same size and spike times will be referenced to the 'startTimeCode' value given for each trial
%   'endrange'            	this will use the value of trial.relendtime  -- the time before which spikes were included from the datafile
%   'ss###'                 this will use the start time of the stimulus + ### seconds, where ### is a string value that can be converted to a double
%                           eg. 'ss-1.23' would use 1.23 seconds before the stimulus onset as the end value
%   'se###'                 this will use the end time of the stimulus + ### seconds, where ### is a string value that can be converted to a double
%                           eg. 'ss+0.8' would use 0.8 seconds after the stimulus offset as the end value
%   'er###'                 this will use the endrange time of the trial + ### seconds, where ### is a string value that can be converted to a double
%                           eg. 'ss-0.8' would use 0.8 seconds before the endrange as the end value
%
%ZEROTIMEREFERENCECODE can be:
%   blank (default)         the default value is '<' and the spike times will not be rereferenced, unless start and stop are both vectors
%   a 1 character string   	corresponding to a digimark code
%   a scalar                the zero reference time for all trials (relative to the zero time reference given by STARTENDRELATIVETONEWZERO)
%   <NOT YET SUPPORTED IN DB VERSION> a vector                the zero reference time for each trial (relative to the default time reference (stimulus start, given by the code '<')
%   'beginrange'           	this will use the value of trial.relstarttime  -- the time after which spikes were included from the datafile
%   'endrange'              this will use the value of trial.relendtime  -- the time before which spikes were included from the datafile
%   'ss###'                 this will use the start time of the stimulus + ### seconds, where ### is a string value that can be converted to a double
%                           eg. 'ss-1.23' would use 1.23 seconds before the stimulus onset as the zero reference value
%   'se###'                 this will use the end time of the stimulus + ### seconds, where ### is a string value that can be converted to a double
%                           eg. 'ss+0.8' would use 0.8 seconds after the stimulus offset as the zero reference value
%
%STARTENDRELATIVETONEWZERO can be:
%   blank, 0 (default)      The start time and end time given by STARTIMECODE and ENDTIMECODE are relative to the native time as stored in DESTRIALS (ie times relative
%                           to stimulus onset). This allows for setting windows whose times correspond to event times that are zeroed to something besides
%                           the ZEROTIMEREFERENCECODE (eg motif onsets, offsets).
%   1                       The start time and end time given by STARTIMECODE and ENDTIMECODE are applied after the spike times are recalculated according
%                           to ZEROTIMEREFERENCECODE. This allows for setting windows that are a certain absolute time before and after a certain event.

if ~exist('StartEndRelativetoNewZero','var');	StartEndRelativetoNewZero   = 0;	end     %The start time and end time given by STARTIMECODE and ENDTIMECODE are relative to the native time as stored in DESTRIALS
if ~exist('zeroTimeReferenceCode','var');       zeroTimeReferenceCode       = '<';	end     %'<' stimstart - this is the default used by reads2mat() to reference spike times to


%% Check for possible Errors
if StartEndRelativetoNewZero == 1
    if ischar(startTimeCode) || ischar(endTimeCode) || (ischar(zeroTimeReferenceCode) && ~strcmp(zeroTimeReferenceCode,'<'))
        beep()
        disp('******')
        disp('******')
        warning('STARTENDRELATIVETONEWZERO == 1 and one of: STARTTIMECODE, ENDTIMECODE, ZEROTIMEREFERENCECODE is of class ''char''\nIt is very likely that this will produce undesired behavior, please check');
        disp('******')
        disp('******')
    end
end

%% setup variables
teDMcodes = cell2mat(metatrialevent(cell2mat(metatrialevent(:,5))==1,6));
teDMtimes = cell2mat(metatrialevent(cell2mat(metatrialevent(:,5))==1,3));

spikes = cell2mat(metaspiketrain(:,4));
ststartrange = metaspiketrain{1,5};
stendrange = metaspiketrain{1,6};
trialid = metaspiketrain{1,7};

starttime = NaN(1,1);
endtime = NaN(1,1);
zerotime = NaN(1,1);

%% decode startTimeCode
if ischar(startTimeCode)
    if length(startTimeCode) == 1                   %user has entered a single character string which is interpreted as a digimark code
        starttimetype = 'digmarkcode';
    else                                            %user has entered one of the special strings described in the help section
        starttimetype = 'specialstring';
    end
elseif isnumeric(startTimeCode)
    if length(startTimeCode) == 1                   %user has entered a scalar value which will be used for all trials
        starttimetype = 'scalar';
    else                                            %user has entered a vector value which will be used for all trials
        starttimetype = 'vector';
    end
end
%
%% decode endTimeCode
if ischar(endTimeCode)
    if length(endTimeCode) == 1                     %user has entered a single character string which is interpreted as a digimark code
        endtimetype = 'digmarkcode';
    else                                            %user has entered one of the special strings described in the help section
        endtimetype = 'specialstring';
    end
elseif isnumeric(endTimeCode)
    if length(endTimeCode) == 1                     %user has entered a scalar value which will be used for all trials
        endtimetype = 'scalar';
    else                                            %user has entered a vector value which will be used for all trials
        endtimetype = 'vector';
    end
end
%
%% decode zeroTimeReferenceCode
if ischar(zeroTimeReferenceCode)
    if length(zeroTimeReferenceCode) == 1           %user has entered a single character string which is interpreted as a digimark code
        zerotimetype = 'digmarkcode';
    else                                            %user has entered one of the special strings described in the help section
        zerotimetype = 'specialstring';
    end
elseif isnumeric(zeroTimeReferenceCode)
    if length(zeroTimeReferenceCode) == 1           %user has entered a scalar value which will be used for all trials
        zerotimetype = 'scalar';
    else                                            %user has entered a vector value which will be used for all trials
        zerotimetype = 'vector';
    end
end
%

%% loop through trials, get proper start, end, zero values then window spikes

%% get start time for windowing current trial
switch starttimetype
    case 'digmarkcode'
        starttime = teDMtimes(teDMcodes == double(startTimeCode));
    case 'specialstring'
        switch lower(startTimeCode)
            case {'beginrange','startrange'}
                starttime = ststartrange;
            otherwise
                if strcmp(startTimeCode(1:2),'ss')
                    stimstartplus = str2double(startTimeCode(3:end));
                    starttime = teDMtimes(teDMcodes == 60);
                    starttime = starttime+stimstartplus;
                elseif strcmp(startTimeCode(1:2),'se')
                    stimendplus = str2double(startTimeCode(3:end));
                    starttime = teDMtimes(teDMcodes == 62);
                    starttime = starttime+stimendplus;
                elseif strcmp(startTimeCode(1:2),'er')
                    endrangeplus = str2double(startTimeCode(3:end));
                    if sign(endrangeplus) == 1
                        error('can''t look past the endrange, sorry');
                    end
                    starttime = stendrange+endrangeplus;
                else
                    error('I don''t know what to do with a startTimeCode of %s',startTimeCode)
                    
                end
        end
    case 'scalar'
        starttime = startTimeCode;
        %         case 'vector'
        %             starttime = startTimeCode(trialNum);
end
%
%% get end time for windowing current trial
switch endtimetype
    case 'digmarkcode'
        endtime = teDMtimes(teDMcodes == double(endTimeCode));
    case 'specialstring'
        switch lower(endTimeCode)
            case {'endrange'}
                endtime = stendrange;
            otherwise
                if strcmp(endTimeCode(1:2),'ss')
                    stimstartplus = str2double(endTimeCode(3:end));
                    endtime = teDMtimes(teDMcodes == 60);
                    endtime = endtime+stimstartplus;
                elseif strcmp(endTimeCode(1:2),'se')
                    stimendplus = str2double(endTimeCode(3:end));
                    endtime = teDMtimes(teDMcodes == 62);
                    endtime = endtime+stimendplus;
                elseif strcmp(endTimeCode(1:2),'er')
                    endrangeplus = str2double(endTimeCode(3:end));
                    if sign(endrangeplus) == 1
                        error('can''t look past the endrange, sorry');
                    end
                    endtime = stendrange+endrangeplus;
                else
                    error('I don''t know what to do with a endTimeCode of %s',endTimeCode)
                    
                end
        end
    case 'scalar'
        endtime = endTimeCode;
        %         case 'vector'
        %             endtime = endTimeCode(trialNum);
end
%
%% get zero time for referencing current trial
switch zerotimetype
    case 'digmarkcode'
        zerotime = teDMtimes(teDMcodes == double(zeroTimeReferenceCode));
    case 'specialstring'
        switch lower(zeroTimeReferenceCode)
            case {'beginrange','startrange'}
                zerotime = ststartrange;
            case {'endrange'}
                zerotime = stendrange;
            otherwise
                if strcmp(zeroTimeReferenceCode(1:2),'ss')
                    stimstartplus = str2double(zeroTimeReferenceCode(3:end));
                    zerotime = teDMtimes(teDMcodes == 60);
                    zerotime = zerotime+stimstartplus;
                elseif strcmp(zeroTimeReferenceCode(1:2),'se')
                    stimendplus = str2double(zeroTimeReferenceCode(3:end));
                    zerotime = teDMtimes(teDMcodes == 62);
                    zerotime = zerotime+stimendplus;
                elseif strcmp(zeroTimeReferenceCode(1:2),'er')
                    endrangeplus = str2double(zeroTimeReferenceCode(3:end));
                    if sign(endrangeplus) == 1
                        error('can''t look past the endrange, sorry');
                    end
                    zerotime = stendrange+endrangeplus;
                else
                    error('I don''t know what to do with a zeroTimeReferenceCode of %s',zeroTimeReferenceCode)
                    
                end
        end
    case 'scalar'
        zerotime = zeroTimeReferenceCode;
        %         case 'vector'
        %             zerotime = zeroTimeReferenceCode(trialNum);
end
%
%% Window and Reference
if StartEndRelativetoNewZero == 0
    
    % watch out for a couple of things
    if ststartrange > starttime
        warning('You have selected a start time before the beginning of recording for the current trial\ttrialid=%d\nDO NOT USE THIS DATA TO CALCULATE SPIKE RATES',trialid);
        beep
    end
    if stendrange < endtime
        warning('You have selected an end time after the end of recording for the current trial.\ttrialid=%d\nDO NOT USE THIS DATA TO CALCULATE SPIKE RATES',trialid);
        beep
    end
    try
        spikes = spikes(spikes > starttime & spikes < endtime); %window the spikes to be between starttime and endtime, relative to the time of '<'
    catch
        zz=1;
    end
    spikes = spikes - zerotime; %adjust the spiketimes to reflect the desired zeroTime
    timeinterval = endtime-starttime;  %get the time over which spikes are returned
    if timeinterval < 0
        warning('timeinterval<0\ttrialid=%d\nReturning NANs',trialid);
        beep
        timeinterval = NaN;
        spikes = NaN;
    end
elseif StartEndRelativetoNewZero == 1
    
    % watch out for a couple of things
    if ststartrange > starttime - zerotime;
        warning('You have selected a start time before the beginning of recording for the current trial\ttrialid=%d\nDO NOT USE THIS DATA TO CALCULATE SPIKE RATES',trialid);
        beep
    end
    if stendrange < endtime - zerotime;
        warning('You have selected an end time after the end of recording for the current trial.\ttrialid=%d\nDO NOT USE THIS DATA TO CALCULATE SPIKE RATES',trialid);
        beep
    end
    
    spikes = spikes - zerotime; %adjust the spiketimes to reflect the desired zeroTime
    spikes = spikes(spikes > starttime & spikes < endtime); %window the spikes to be between starttime and endtime, relative to the desired zero time
    timeinterval = endtime-starttime;  %get the time over which spikes are returned
    if timeinterval < 0
        warning('timeinterval<0\ttrialid=%d\nReturning NANs',trialid);
        beep
        timeinterval = NaN;
        spikes = NaN;
    end
else
    error('huh??');
end

%% format output
codes.startTimeCode = startTimeCode;
codes.endTimeCode = endTimeCode;
codes.zeroTimeReferenceCode = zeroTimeReferenceCode;
codes.starttime = starttime;   %relative to '<' in each trial
codes.endtime = endtime;       %relative to '<' in each trial
codes.zerotime = zerotime;    %relative to '<' in each trial

if isempty(spikes)
    spikes = [];
end
end
