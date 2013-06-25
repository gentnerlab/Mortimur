function [duration trialidout] = DBget_stimduration_trialid(conn,trialid)
%[duration trialidout] = DBget_stimduration_trialid(conn,trialid)

query = ['SELECT stimulus.duration, trial.trialid '...
    ' FROM stimulus '...
    ' JOIN trial ON trial.stimulusid = stimulus.stimulusid '...
    ' WHERE trial.trialid IN ' DBtool_inlist(trialid)];

snids = DBget_x(conn, query);

duration=[];
trialidout=[];
for i = 1:length(trialid)
    inds = cell2mat(snids(:,2))==trialid(i);
    duration = [duration ; cell2mat(snids(inds,1))];
    trialidout = [trialidout ; cell2mat(snids(inds,2))];
end

if any(isnan(duration)) 
    %probably have a motif concat bird where the duration was not 
    %put in the database - try to calculate using digmarks
    stendcodes = [60,62];
    for i = 1:length(duration)
        if isnan(duration(i))
            ct = trialidout(i);
            stimstartendtime = c2m(DBx(conn,['select eventtime from '...
                ' trialevent where trialid = ' DBtool_num2strNULL(trialidout(i)) ...
                ' AND trialeventtypeid = 1 AND eventcode1 IN ' DBtool_inlist(stendcodes)]));
            if numel(stimstartendtime) ~= 2
                disp('WHA?!')
                keyboard
            end
            duration(i) = abs(stimstartendtime(2)-stimstartendtime(1));
        end
    end
end


end