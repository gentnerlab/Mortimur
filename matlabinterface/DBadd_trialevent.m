function [query, anerror, errormsg, output] = DBadd_trialevent(conn, trialid, eventtime, trialeventtypeid, eventcode1, eventcode2, eventcode3, eventcode4)

trialid =           DBtool_num2strNULL(trialid);
eventtime =         DBtool_num2strNULL(eventtime,'double4places');
trialeventtypeid =  DBtool_num2strNULL(trialeventtypeid);
eventcode1 =        DBtool_num2strNULL(eventcode1);
eventcode2 =        DBtool_num2strNULL(eventcode2);
eventcode3 =        DBtool_num2strNULL(eventcode3);
eventcode4 =        DBtool_num2strNULL(eventcode4);

query = ['select add_trialevent(' trialid ',' eventtime ',' trialeventtypeid ',' eventcode1 ',' eventcode2 ',' eventcode3 ',' eventcode4 ')'];

curs = exec(conn, query);

if (isempty(curs.Message))
    data = fetch(curs);
    anerror = 0;
    errormsg = '';
    close(curs);
    output = data.Data{1};
else
    anerror = 1;
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    output = [];
end

end