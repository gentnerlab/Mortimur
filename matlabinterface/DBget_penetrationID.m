function [penetrationID, penetrationAllData] = DBget_penetrationID(conn, subjectid, rostral, lateral)


selectionFilter = ['WHERE subjectid = ' DBtool_num2strNULL(subjectid) ' AND rostral = ' DBtool_num2strNULL(rostral) ' AND lateral = ' DBtool_num2strNULL(lateral)];

curs = exec(conn, ['select penetrationid, rostral, lateral, hemisphereid, electrodeid, alphaangle, betaangle, rotationangle, subjectid, histologycorrectionrostral, histologycorrectionlateral, histologycorrectionventral, cmtop, cmbottom from penetration ' selectionFilter]);


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