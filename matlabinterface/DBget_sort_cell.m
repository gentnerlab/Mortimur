function [sortid] = DBget_sort_cell(conn,cellid)

if length(cellid) ~= 1
    error('one cell at a time, please');
end

query = ['SELECT DISTINCT sort.sortid '...
    ' FROM sort '...
    ' JOIN cell ON cell.siteid = sort.siteid '...
    ' WHERE cell.cellid IN ' DBtool_inlist(cellid) ...
    ' AND cell.sortmarkercode = sort.sortmarkercode '];

sortid = cell2mat(DBget_x(conn,query));

end