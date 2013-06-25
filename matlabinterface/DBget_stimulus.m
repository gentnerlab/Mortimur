function  [ID, allData] = DBget_stimulus(conn, selectionfilter)
%[ID, allData] = DBget_stimulus(conn, selectionfilter)

query = ['SELECT stimulusid, stimulusfilename, motifboundaries, duration FROM stimulus WHERE ' selectionfilter ' ORDER BY stimulusfilename'];

curs = exec(conn, query);

if (isempty(curs.Message))
    data = fetch(curs);
    close(curs);
else
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    error(['Error retreiving data: ' errormsg]);
end

if (strcmp(data.Data{1}, 'No Data'))
    allData = {};
    ID = [];
else
    allData = data.Data;
    ID = cell2mat(data.Data(:,1));
end

end