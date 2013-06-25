function [trainingstims class1stims class2stims cellid] = DBget_trainingstims_cell(conn,cellid)
%[trainingstims class1stims class2stims cellid] = DBget_trainingstims_cell(conn,cellid)

if numel(cellid) > 1
   error('only one cell at a time please!'); 
end

ts = DBx(conn,['SELECT DISTINCT class1stims, class2stims FROM subject WHERE subjectid = ' DBtool_num2strNULL(DBget_subject_cell(conn,cellid))]);

class1stims = DBtool_JarraytoMarray(ts{1});
class2stims = DBtool_JarraytoMarray(ts{2});
trainingstims = [class1stims(:);class2stims(:)];

end