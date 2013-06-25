function Tsec = wavdurDB(wav_id)
%Tsec = wavdurDB(wav_id); returns [] if cannot open wav_id
%returns the time in seconds of a wav file
%wav_id is the file name of the wav file you want to know the time of

try
    [Y,fs,nbits] = wavread(wav_id);
catch exception
    if strcmp(exception.identifier, 'wavread:InvalidFile')
        warning('wav_id:\t%s cannot be opened, returning []\n',wav_id);
        Tsec = [];
        return
    else
        zz=1;
    end
end
Tsec = size(Y,1)/fs;

end