function [trainingstims class1stims class2stims subjectid] = DBget_trainingstims_subject(conn,subjectid)
%[trainingstims class1stims class2stims cellid] = DBget_trainingstims_cell(conn,cellid)

if numel(subjectid) > 1
   error('only one subject at a time please!'); 
end

ts = DBx(conn,['SELECT DISTINCT class1stims, class2stims FROM subject WHERE subjectid = ' DBtool_num2strNULL(subjectid)]);

class1stims = DBtool_JarraytoMarray(ts{1});
class2stims = DBtool_JarraytoMarray(ts{2});
trainingstims = [class1stims(:);class2stims(:)];

end