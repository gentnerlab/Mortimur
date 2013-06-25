%Returns an empty structure if no penetrations match the criteria.
function [ID, allData] = DBget_sortID(conn, siteid, concatfilename, sortmarkercode)

siteid = DBtool_num2strNULL(siteid);
concatfilename = DBtool_num2strNULL(concatfilename);
sortmarkercode = ['''' DBtool_num2strNULL(sortmarkercode) '''']; %this needs explicit quotes because matlab has code as int, but DB wants a char

query = ['SELECT sortid, siteid, concatfilename, concatfilechan, sortmarkercode, sortquality, isolationtypeid, template_start, '...
    ' template_show, template_pre, template_n, chan1_electrodepadid, chan1_threshold, chan2_electrodepadid, chan2_threshold '...
    ' FROM sort WHERE siteid = ' siteid ...
    ' AND concatfilename = ' concatfilename ...
    ' AND sortmarkercode = '  sortmarkercode ]; 

curs = exec(conn, query);


if (isempty(curs.Message))
    data = fetch(curs);
    close(curs);
else
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    error(['Error retreiving site data: ' errormsg]);
end

if (strcmp(data.Data{1}, 'No Data'))
    allData = {};
    ID = [];
else
    allData = data.Data;
    ID = cell2mat(data.Data(:,1));
end

end
