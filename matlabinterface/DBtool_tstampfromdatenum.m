function timestampstring = DBtool_tstampfromdatenum(datenumber)


[year, month, day, hours, minutes, S] = datevec(datenumber);

seconds = floor(S);

milliseconds = round((S - seconds)*1000);

timestampstring = sprintf('%s-%s-%s %s:%s:%s.%s',num2str(year,'%04d'),num2str(month,'%02d'),num2str(day,'%02d'),num2str(hours,'%02d'),num2str(minutes,'%02d'),num2str(seconds,'%02d'),num2str(milliseconds,'%03d'));


end