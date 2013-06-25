function [silenceid, silencename] = DBget_silenceid_cell(conn,cellid)

[stimnames stimid] = DBget_stim_cell(conn,cellid);

inds = strmatch('silence',stimnames);

if isempty(inds)
    silenceid = [];
    silencename = '';
    error(sprintf('did not find silence stimulus for cellid = %d',cellid));
elseif length(inds) == 1
    silenceid = stimid(inds);
    silencename = stimnames{inds};
else
    error(sprintf('found more than one silence stimulus for cellid = %d',cellid));
end

end