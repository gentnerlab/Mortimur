function [trialispassive trialid] = DBcalc_trialispassive(conn,trialid)
%[trialispassive trialidout] = DBcalc_trialispassive(conn,trialid)

query = ['SELECT protocolmodename, trial.trialid'...
            ' FROM protocolmode'...
            ' JOIN protocol ON protocolmode.protocolmodeid = protocol.protocolmodeid'...
            ' JOIN epoch ON protocol.protocolid = epoch.protocolid'...
            ' JOIN trial ON epoch.epochid = trial.epochid '...
            ' WHERE trial.trialid in ' DBtool_inlist(trialid) ...
            ' ORDER BY trial.trialid;'];

protocolmodenametrialid = DBx(conn,query);


tmpispassive = NaN(length(trialid),2);
tmpispassive(:,2) = [protocolmodenametrialid{:,2}];


NOS = strcmp('neuralrecordingonly', protocolmodenametrialid(:,1));
BOS = strcmp('behavioralrecordingonly', protocolmodenametrialid(:,1));
NBS = strcmp('neuralandbehavioralrecording', protocolmodenametrialid(:,1));

tmpispassive(NOS,1) = 1;
tmpispassive(BOS,1) = 0;
tmpispassive(NBS,1) = 0;

trialispassive = zeros(length(trialid),1);
for i = 1:length(trialid)
   trialispassive(i) = logical(tmpispassive(tmpispassive(:,2)==trialid(i),1)); 
end

end