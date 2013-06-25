function [firsttrialtime lasttrialtime cellid] = DBget_firstlasttrialtimes(conn,cellid)
% [firsttrialtime lasttrialtime] = DBget_firstlasttrialtimes(conn,cellid)
% subtracts a millisecond from first trial time
% adds a millisecond to last trial time
%
%WARNING - BREAKS FOR NON SS CELLS - See DBget_firstlasttrialtimes_NonSS
for cn = 1:length(cellid)
    query = ['SELECT sstrialid, sstrialtime '...
        ' FROM sstrial JOIN spiketrain ON spiketrain.trialid = sstrial.trialid '...
        ' JOIN cell ON cell.cellid = spiketrain.cellid ' ...
        ' WHERE cell.cellid = ' DBtool_num2strNULL(cellid(cn)) ...
        ' ORDER BY sstrialtime '];
    cellsstrialidstimes = DBx(conn,query);
    firsttrialtime{cn} = DBtool_tstampfromdatenum(addtodate(datenum(cellsstrialidstimes{1,2}),-1,'millisecond'));
    lasttrialtime{cn} = DBtool_tstampfromdatenum(addtodate(datenum(cellsstrialidstimes{end,2}),1,'millisecond'));
end
end