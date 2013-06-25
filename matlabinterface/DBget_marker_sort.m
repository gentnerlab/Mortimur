function [markercode sortid] = DBget_marker_sort(conn,sortid)
%[stimname stimid trialid] = DBget_trialstim(conn,trialid)

query = ['SELECT sortmarkercode, sortid'...
            ' FROM sort'...
            ' WHERE sortid in ' DBtool_inlist(sortid)];

markersort = DBget_x(conn,query);

markercode = zeros(length(sortid),1);
for i = 1:length(sortid)
   markercode(i) = str2double(markersort{cell2mat(markersort(:,2))==sortid(i),1});
end

end