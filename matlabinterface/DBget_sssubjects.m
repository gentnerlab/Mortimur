function sssubjects = DBget_sssubjects(conn)

ttinfo = DBx(conn,'SELECT * FROM trainingtype');

ssid = ttinfo{strcmp(ttinfo(:,2),'2ac_set'),1};

sssubjects = cell2mat(DBx(conn,['SELECT subjectid ' ...
    ' FROM subject ' ...
    ' WHERE trainingtypeid = ' DBtool_num2strNULL(ssid) ...
    ' ORDER BY subjectid']));

end