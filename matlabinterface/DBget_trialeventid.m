function  [ID, allData] = DBget_trialeventid(conn, trialid, eventtime, trialeventtypeid)
%[ID, allData] = DBget_trialevent(conn, selectionfilter)

trialid = DBtool_num2strNULL(trialid);
if ischar(eventtime)
    if strcmp('null',eventtime);
        eventtime = ['IS NULL'];
    else
        error('huh?!');
    end
else
    eventtime = [' = ' DBtool_num2strNULL(eventtime,'double4places')];
end

trialeventtypeid = DBtool_num2strNULL(trialeventtypeid);

selectionfilter = ['trialid = ' trialid ' AND eventtime ' eventtime ' AND trialeventtypeid = ' trialeventtypeid ];

if nargout > 1
    query = ['SELECT trialeventid, trialid, eventtime, trialeventtypeid, eventcode1, eventcode2, eventcode3, eventcode4 FROM trialevent WHERE ' selectionfilter ' ORDER BY trialeventid'];
else
    query = ['SELECT trialeventid FROM trialevent WHERE ' selectionfilter ' ORDER BY trialeventid'];
end

curs = exec(conn, query);

if (isempty(curs.Message))
    data = fetch(curs);
    errormsg = '';
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