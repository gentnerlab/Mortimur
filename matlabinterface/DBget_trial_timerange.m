function [trialid ] = DBget_trial_timerange(conn,startrange,endrange)
%[trialids cellidout] = DBget_trial_cell(conn,cellid)

if ischar(startrange)
if size(startrange,1) > 1
    error('not coded up for multiple trials yet')
end
else
    error('requires a char input')
end

query = ['SELECT trial.trialid '...
    ' FROM trial WHERE ' ...
    ' ( TIMESTAMP ' DBtool_num2strNULL(startrange) ' , TIMESTAMP ' DBtool_num2strNULL(endrange) ' ) OVERLAPS ( trialtime  , INTERVAL ''1 millisecond'')'];

trialid = cell2mat(DBx(conn, query));


end
