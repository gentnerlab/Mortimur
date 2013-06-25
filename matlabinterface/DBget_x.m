function  [x, query, anerror, errormsg] = DBget_x(conn, query)
%[x, query, anerror, errormsg] = DBget_x(conn, query)
%this is identical to DBx(), but that one's faster to type ;)
%ex: query = ['SELECT epochid, starttimestamp, endtimestamp, protocolid, epochname FROM epoch WHERE ' selectionfilter];

curs = exec(conn, query);

if (isempty(curs.Message))
    data = fetch(curs);
    errormsg = '';
    anerror=0;
    close(curs);
else
    anerror=1;
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    error(['Error retreiving subject data: ' errormsg]);
end

if (strcmp(data.Data{1}, 'No Data'))
    x = {};
else
    x = data.Data;
end

end