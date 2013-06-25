function [motifboundaries stimid] = DBget_motifboundaries_stim(conn,stimid)
%[motifboundaries stimid] = DBget_motifboundaries_stim(conn,stimid)
% motifboundaries returns [] if no motif boundaries found

if numel(stimid) > 1
    error('only one stim at a time please!');
end

tmp = DBx(conn,['SELECT DISTINCT motifboundaries FROM stimulus WHERE stimulusid = ' DBtool_num2strNULL(stimid)]);

if strcmp(tmp{1},'null')
    motifboundaries = [];
else
    motifboundaries = DBtool_JarraytoMarray(tmp{1});
end

end