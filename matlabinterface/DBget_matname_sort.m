function [matname sortid] = DBget_matname_sort(conn,sortid)
%[matname sortid] = DBget_matname_sort(conn,sortid)

query = ['SELECT concatfilename, sortid'...
            ' FROM sort'...
            ' WHERE sortid in ' DBtool_inlist(sortid)];

matnamesort = DBget_x(conn,query);

matname = cell(length(sortid),1);
for i = 1:length(sortid)
   matname{i} = matnamesort{cell2mat(matnamesort(:,2))==sortid(i),1};
end

end