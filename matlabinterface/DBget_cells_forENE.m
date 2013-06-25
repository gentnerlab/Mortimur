function [cellids] = DBget_cells_forENE(conn,SORTRANGE,DESIREDREGIONNAMES,AUDITORY)
%[desiredTrials, desiredTrialsInds] = ND_picktrials(ND_trials,varargin)
%
%
%% get a list of all valid cellids to start with
if ~exist('SORTRANGE','var')
    SORTRANGE = [2.5 5];
end
minsortqual = SORTRANGE(1);
maxsortqual = SORTRANGE(2);

if ~exist('DESIREDREGIONNAMES','var')
    DESIREDREGIONNAMES = {'CMM' 'CM' 'CLM' 'Unknown-Prehistology'};
end

if ~exist('AUDITORY','var')
    AUDITORY = 1;
end

DESIREDCELLSSENGMODE = 3;
DESIREDTRIALSENGMODE = [1 2]; %nonengaged and engaged

%----------GET REGIONIDs----------

desnames = '';
for i = 1:length(DESIREDREGIONNAMES)
    desnames = sprintf('%s ''%s'' ,',desnames,DESIREDREGIONNAMES{i});
end
desnames = desnames(1:end-1);
query = ['SELECT DISTINCT regionid FROM region WHERE regionname IN (' desnames ')'];
desregionids = cell2mat(DBx(conn,query));

%----------GET CELLIDs----------
query = ['SELECT DISTINCT cell.cellid FROM trial ' ...
    ' JOIN epoch on trial.epochid = epoch.epochid ' ...
    ' JOIN trialcalc on trial.trialid = trialcalc.trialid ' ...
    ' JOIN protocol on epoch.protocolid = protocol.protocolid ' ...
    ' JOIN protocoltype on protocoltype.protocoltypeid = protocol.protocoltypeid ' ...
    ' JOIN spiketrain ON spiketrain.trialid = trial.trialid ' ...
    ' JOIN cell ON spiketrain.cellid = cell.cellid ' ...
    ' JOIN cellcalc ON cellcalc.cellid = cell.cellid ' ...
    ' JOIN sort ON sort.sortid = spiketrain.sortid ' ...
    ' WHERE sort.sortquality BETWEEN ' DBtool_num2strNULL(minsortqual) ' AND ' DBtool_num2strNULL(maxsortqual) ...
    ' AND protocoltype.protocoltypename <> ''special-withhold'' ' ...
    ' AND trialcalc.nontrainingstim <> 1 ' ...
    ' AND trialcalc.engmodeid IN ' DBtool_inlist(DESIREDTRIALSENGMODE) ...
    ' AND cellcalc.regionid IN ' DBtool_inlist(desregionids) ...
    ' AND byeyeaud IN ' DBtool_inlist(AUDITORY) ...
    ' ORDER BY cell.cellid '];

cellids = cell2mat(DBx(conn, query));


%----------GET CELLIDs that have both nonengaged and engaged trials in desired sortrange----------
k = 0;
goodcells =[];
for i = 1:length(cellids)
    
    tids_sr = DBget_trials_cellsortrange(conn,cellids(i),[minsortqual maxsortqual]);
    tids_stims = DBget_trials_trainingstims_cell(conn,cellids(i));
    gtids = intersect(tids_sr,tids_stims);
    
    query = ['SELECT DISTINCT trialcalc.engmodeid ' ...
        ' FROM trial ' ...
        ' JOIN epoch on trial.epochid = epoch.epochid ' ...
        ' JOIN trialcalc on trial.trialid = trialcalc.trialid ' ...
        ' JOIN protocol on epoch.protocolid = protocol.protocolid ' ...
        ' JOIN protocoltype on protocoltype.protocoltypeid = protocol.protocoltypeid ' ...
        ' WHERE trial.trialid IN ' DBtool_inlist(gtids) ...
        ' AND protocoltype.protocoltypename <> ''special-withhold'' ' ...
        ' AND trialcalc.nontrainingstim <> 1 '];
    
    engmodeofgoodsorttrials = cell2mat(DBx(conn, query));
    
    crit = [];
    for j=1:length(DESIREDTRIALSENGMODE)
        crit(j) = any(engmodeofgoodsorttrials == DESIREDTRIALSENGMODE(j));
    end
    if all(crit)
        k= k+1;
        goodcells(k,1) = cellids(i);
    end
end

cellids = goodcells;


end

