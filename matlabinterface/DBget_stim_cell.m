function [stimname stimid cellidout] = DBget_stim_cell(conn,cellid)
%[stimname stimid cellidout] = DBget_stim_cell(conn,cellid)

query = ['SELECT DISTINCT stimulus.stimulusid, stimulus.stimulusfilename, cell.cellid '...
    ' FROM trial '...
    ' JOIN spiketrain ON spiketrain.trialid = trial.trialid '...
    ' JOIN stimulus ON trial.stimulusid = stimulus.stimulusid ' ...
    ' JOIN cell ON cell.cellid = spiketrain.cellid ' ...
    ' WHERE cell.cellid in ' DBtool_inlist(cellid) ...
    ' ORDER BY cell.cellid, stimulus.stimulusid'];

stimidstimnamecellid = DBget_x(conn, query);

stimname=[];
stimid=[];
cellidout=[];
for i = 1:length(cellid)
    inds = cell2mat(stimidstimnamecellid(:,3))==cellid(i);
    stimname = [stimname ; stimidstimnamecellid(inds,2)];
    stimid = [stimid , stimidstimnamecellid{inds,1}];
    cellidout = [cellidout , stimidstimnamecellid{inds,3}]; 
end

stimid = stimid';
cellidout = cellidout';

end