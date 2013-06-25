function [trialid pepidout] = DBget_trials_pepid(conn,pepid)
%[trialid ] = DBget_trials_pepid(conn,pepid)

trialid = [];
pepidout = [];
k = 0;
for pid = 1:length(pepid)
    cidtimes = DBx(conn,['SELECT cellid, pepstarttimestamp, pependtimestamp FROM pepcalc WHERE pepcalcid = ' DBtool_num2strNULL(pepid(pid))]);
    
    query = ['SELECT trial.trialid, cell.cellid, trial.trialtime '...
        ' FROM trial JOIN spiketrain ON spiketrain.trialid = trial.trialid '...
        ' JOIN cell ON cell.cellid = spiketrain.cellid ' ...
        ' WHERE cell.cellid = ' DBtool_num2strNULL(cidtimes{1}) ...
        ' AND ( TIMESTAMP ' DBtool_num2strNULL(cidtimes{2}) ' , TIMESTAMP ' DBtool_num2strNULL(cidtimes{3}) ' ) OVERLAPS ( trialtime  , INTERVAL ''1 millisecond'')' ...
        ' ORDER BY trial.trialtime'];
    
    trids = DBx(conn,query);
    tids = cell2mat(trids(:,1));
    trialid = [trialid; tids(:)];
    pepidout = [pepidout; repmat(pepid(pid), numel(tids),1)];
end

end
