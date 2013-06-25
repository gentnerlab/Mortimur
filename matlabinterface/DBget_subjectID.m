function [ID, allData] = DBget_subjectID(conn, subjectname)
%[ID, allData] = DBget_subjectID(conn, subjectname)

curs = exec(conn, ['select subjectid, subjectname from subject where subjectname = ''' subjectname '''']);


if (isempty(curs.Message))
    data = fetch(curs);
    close(curs);
else
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    error(['Error retreiving subject data: ' errormsg]);
end

if (strcmp(data.Data{1}, 'No Data'))
    allData = {};
    ID = [];
else
    allData = data.Data;
    ID = cell2mat(data.Data(:,1));
end

end