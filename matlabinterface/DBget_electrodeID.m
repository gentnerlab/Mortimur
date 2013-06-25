function [electrodeID, electrodeAllData] = DBget_electrodeID(conn, electrodeserialnumber)

if isnumeric(electrodeserialnumber)
   electrodeserialnumber = num2str(electrodeserialnumber); 
end

query = ['select electrodeid, electrodetypeid, impedence, serialnumber from electrode where serialnumber = ' '''' electrodeserialnumber ''''];

curs = exec(conn, query);


if (isempty(curs.Message))
    data = fetch(curs);
    errormsg = '';
    close(curs);
else
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    error(['Error retreiving electrode data: ' errormsg]);
end

if (strcmp(data.Data{1}, 'No Data'))
    electrodeAllData = {};
    electrodeID = [];
else
    electrodeAllData = data.Data;
    electrodeID = cell2mat(data.Data(:,1));
end

end