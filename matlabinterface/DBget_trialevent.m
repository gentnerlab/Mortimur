function  [ID, allData] = DBget_trialevent(conn, selectionfilter)
%[ID, allData] = DBget_trialevent(conn, selectionfilter)

error('Please use the function DBget_trialeventid or DBget_x and be wary of using the correct input for eventtime \n The proper was to input a time is DBtool_num2strNULL(time,''double4places'')\n');
% query = ['SELECT trialeventid, trialid, eventtime, trialeventtypeid, eventcode1, eventcode2, eventcode3, eventcode4 FROM trialevent WHERE ' selectionfilter ' ORDER BY trialeventid'];
% 
% curs = exec(conn, query);
% 
% if (isempty(curs.Message))
%     data = fetch(curs);
%     errormsg = '';
%     close(curs);
% else
%     errormsg = curs.Message;
%     fprintf([errormsg '\n']);
%     error(['Error retreiving subject data: ' errormsg]);
% end
% 
% if (strcmp(data.Data{1}, 'No Data'))
%     allData = {};
%     ID = [];
% else
%     allData = data.Data;
%     ID = cell2mat(data.Data(:,1));
% end

end