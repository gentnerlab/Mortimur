function [stimid stimname subjectidout] = DBget_stim_subject(conn,subjectid)
%[stimid stimname subjectidout] = DBget_stim_subject(conn,subjectid)

if any(size(subjectid)>1)
    error('only one subjectid at a time please');
end

query = ['SELECT DISTINCT stimulus.stimulusid, stimulus.stimulusfilename, subject.subjectid '...
    ' FROM stimulus '...
    ' JOIN trial ON trial.stimulusid = stimulus.stimulusid '...
    ' JOIN epoch ON epoch.epochid = trial.epochid ' ...
    ' JOIN subject ON subject.subjectid = epoch.subjectid ' ...
    ' WHERE subject.subjectid = ' DBtool_num2strNULL(subjectid) ...
    ' ORDER BY subject.subjectid, stimulus.stimulusid'];

stimidstimnamesubjectid = DBx(conn, query);

if isempty(stimidstimnamesubjectid)
    stimid = [];
    stimname = [];
    subjectidout = [];
else
    stimid = cell2mat(stimidstimnamesubjectid(:,1));
    stimname = stimidstimnamesubjectid(:,2);
    subjectidout = cell2mat(stimidstimnamesubjectid(:,3));
end

end