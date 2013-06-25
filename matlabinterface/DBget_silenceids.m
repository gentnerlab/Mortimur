function silenceids = DBget_silenceids(conn)
%silenceids = DBget_silenceids(conn)
%returns stimulusids for stimuli with the word 'silence' in them from the database

silenceids = cell2mat(DBx(conn,'SELECT stimulusid FROM stimulus WHERE stimulusfilename LIKE ''%silence%'''));

end