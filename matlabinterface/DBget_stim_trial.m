function [stimname stimid trialid] = DBget_stim_trial(conn,trialid)
%[stimname stimid trialid] = DBget_trialstim(conn,trialid)

query = ['SELECT stimulus.stimulusid, stimulus.stimulusfilename, trial.trialid'...
            ' FROM stimulus'...
            ' JOIN trial ON stimulus.stimulusid = trial.stimulusid'...
            ' WHERE trial.trialid in ' DBtool_inlist(trialid) ...
            ' ORDER BY trial.trialid;'];

stimidstimnametrialid = DBget_x(conn,query);

stimname = cell(length(trialid),1);
stimid = zeros(length(trialid),1);
for i = 1:length(trialid)
   stimname{i} = stimidstimnametrialid{cell2mat(stimidstimnametrialid(:,3))==trialid(i),2}; 
   stimid(i) = stimidstimnametrialid{cell2mat(stimidstimnametrialid(:,3))==trialid(i),1};
end

end