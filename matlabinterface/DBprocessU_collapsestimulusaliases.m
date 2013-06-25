function [trialids, sstrialids, stimcalcids] = DBprocessU_collapsestimulusaliases(conn,keepstimulusid,redundantstimulusids)
%[trialids, sstrialids] = DBprocessU_collapsestimulusaliases(conn,keepstimulusid,redundantstimulusids)
% the same stimuli have been used with different names across ndege, and multiple instances of recording on chron rig
%this function will allow the user to manually reassign the stimulusids in the trial, sstrial, and stimcalc tables of
%the redundant names to the accepted canonical database name
%the redundant rows will NOT be removed from the stimulus table, rather
%references to their stimulusid will be modified in the trial, sstrial, and stimcalc tables
%AHH ALSO need to do the training stims!! DPK 20110916 - will do these manually -- hopefully never need to do again!!


%% checks
if numel(keepstimulusid) > 1
    error('found multiple keeperids: this function is intended for use as a many-to-one solution')
end

if ~isnumeric(keepstimulusid)
    error('just what the hell do you think you''re doing?');
end

%% update trial table
update(conn,'trial',{'stimulusid'},keepstimulusid,['WHERE stimulusid IN ' DBtool_inlist(redundantstimulusids)]);

trialids = cell2mat(DBx(conn,['SELECT DISTINCT trialid FROM trial WHERE stimulusid IN ' DBtool_inlist(redundantstimulusids)]));

%% update sstrial table
update(conn,'sstrial',{'stimulusid'},keepstimulusid,['WHERE stimulusid IN ' DBtool_inlist(redundantstimulusids)]);

sstrialids = cell2mat(DBx(conn,['SELECT DISTINCT sstrialid FROM sstrial WHERE stimulusid IN ' DBtool_inlist(redundantstimulusids)]));


%% update stimcalc table
update(conn,'stimcalc',{'stimulusid'},keepstimulusid,['WHERE stimulusid IN ' DBtool_inlist(redundantstimulusids)]);

stimcalcids = cell2mat(DBx(conn,['SELECT DISTINCT stimcalcid FROM stimcalc WHERE stimulusid IN ' DBtool_inlist(redundantstimulusids)]));

end