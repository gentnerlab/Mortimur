function [penetrationID, penetrationAllData] = DBget_penetration(conn, selectionFilter)

curs = exec(conn, ['select penetrationid, rostral, lateral, lesiondepth, lesionlocated, hemisphereid, electrodeid, alphaangle, betaangle, rotationangle, subjectid from penetration ' selectionFilter]);


if (isempty(curs.Message))
    data = fetch(curs);
    errormsg = '';
    close(curs);
else
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    error(['Error retreiving penetration data: ' errormsg]);
end

if (strcmp(data.Data{1}, 'No Data'))
    penetrationAllData = {};
    penetrationID = [];
else
    penetrationAllData = data.Data;
    penetrationID = data.Data{1,1};
end

end