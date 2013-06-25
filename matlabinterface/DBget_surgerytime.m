function [surgerytime surgerytimestring] = DBget_surgerytime(conn,subjectid)

if length(subjectid) > 1
    error('codemeup')
end

surgtime = DBx(conn,...
    [ ...
    ' SELECT surgerytime ' ...
    ' FROM surgerytimes ' ...
    ' WHERE subjectid = ' DBtool_num2strNULL(subjectid) ...
    ]);

if isempty(surgtime)
    surgerytimestring = '';
    surgerytime = nan;
else
    surgerytimestring = surgtime{1};
    surgerytime = datenum(surgerytimestring);
end

end


