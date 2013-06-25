function Marray = DBtool_JarraytoMarray(Jarray)
%Marray = DBtool_JarraytoMarray(Jarray)
%this converts a java array object returned by the database to a matlab numeric vector



Jstring = char(toString(Jarray));
if strcmp(Jstring,'{}')
    Marray = [];
else
    Marray = textscan(Jstring(2:end-1),'%f','delimiter',',', 'collectoutput',1);
    Marray = Marray{1}; %best (0.05 seconds for test)
end

% Marray1 = double(getArray(Jarray)); %BAD BAD SLOW! (0.67 seconds for test)
%
% Marray2 = cell2mat(cell(getArray(Jarray))); %Still SLOW! (0.20 seconds for test)
%
% CC = char(toString(Jarray));
% Marray3 = strread(CC(2:end-1),'%f','delimiter',',' ); %better (0.08 seconds for test)

end