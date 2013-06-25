function [duration stimidout] = DBget_duration_stimid(conn,stimid)
%[stimname stimidout] = DBget_stimname_stimid(conn,stimid)

query = ['SELECT duration, stimulusid '...
    ' FROM stimulus '...
    ' WHERE stimulusid IN ' DBtool_inlist(stimid)];

snids = DBget_x(conn, query);

duration=[];
stimidout=[];
for i = 1:length(stimid)
    inds = cell2mat(snids(:,2))==stimid(i);
    duration = [duration ; cell2mat(snids(inds,1))];
    stimidout = [stimidout ; cell2mat(snids(inds,2))];
end

end