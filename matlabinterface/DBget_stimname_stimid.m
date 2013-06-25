function [stimname stimidout] = DBget_stimname_stimid(conn,stimid)
%[stimname stimidout] = DBget_stimname_stimid(conn,stimid)

query = ['SELECT stimulusfilename, stimulusid '...
    ' FROM stimulus '...
    ' WHERE stimulusid IN ' DBtool_inlist(stimid)];

snids = DBget_x(conn, query);

stimname=[];
stimidout=[];
for i = 1:length(stimid)
    inds = cell2mat(snids(:,2))==stimid(i);
    stimname = [stimname ; snids(inds,1)];
    stimidout = [stimidout ; cell2mat(snids(inds,2))];
end

end