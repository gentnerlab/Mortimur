function [firsttrialtime lasttrialtime] = DBget_firstlasttrialtimes_NonSS(conn,cellid)
% [firsttrialtime lasttrialtime] = DBget_firstlasttrialtimes(conn,cellid)
% subtracts a millisecond from first trial time
% adds a millisecond to last trial time
%
%WARNING - BREAKS FOR NON SS CELLS - See DBget_firstlasttrialtimes_NonSS

query = ['SELECT trial.trialid, trial.trialtime '...
    ' FROM trial JOIN spiketrain ON spiketrain.trialid = trial.trialid '...
    ' JOIN cell ON cell.cellid = spiketrain.cellid ' ...
    ' WHERE cell.cellid in ' DBtool_inlist(cellid) ...
    ' ORDER BY trialtime '];
celltrialidstimes = DBx(conn,query);
firsttrialtime = DBtool_tstampfromdatenum(addtodate(datenum(celltrialidstimes{1,2}),-1,'millisecond'));
lasttrialtime = DBtool_tstampfromdatenum(addtodate(datenum(celltrialidstimes{end,2}),1,'millisecond'));
end