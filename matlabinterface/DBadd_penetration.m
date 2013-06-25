function [query, error, errormsg, output] = DBadd_penetration(conn, subjectid, rostral, lateral, hemisphereid, electrodeid, alphaangle, betaangle, rotationangle, histcorrAP, histcorrML, histcorrDV, cmtop, cmbottom)

    subjectid =     DBtool_num2strNULL(subjectid);
    rostral =       DBtool_num2strNULL(rostral);
    lateral =       DBtool_num2strNULL(lateral);
    hemisphereid =	DBtool_num2strNULL(hemisphereid);
    electrodeid =	DBtool_num2strNULL(electrodeid);
    alphaangle =	DBtool_num2strNULL(alphaangle,'double4places');
    betaangle =     DBtool_num2strNULL(betaangle,'double4places');
    rotationangle =	DBtool_num2strNULL(rotationangle,'double4places');
    histcorrAP =	DBtool_num2strNULL(histcorrAP);
    histcorrML =	DBtool_num2strNULL(histcorrML);
    histcorrDV =	DBtool_num2strNULL(histcorrDV);
    cmtop =         DBtool_num2strNULL(cmtop);
    cmbottom =      DBtool_num2strNULL(cmbottom);
    

query = ['select add_penetration(' subjectid ',' rostral ',' lateral ',' hemisphereid ',' electrodeid ',' alphaangle ',' betaangle ',' rotationangle ',' histcorrAP ',' histcorrML ',' histcorrDV ',' cmtop ',' cmbottom ')'];

curs = exec(conn, query);      

if (isempty(curs.Message))
    data = fetch(curs);
    error = 0;
    errormsg = '';
    close(curs);
    output = data.Data{1};
else
    error = 1;
    errormsg = curs.Message;
    fprintf([errormsg '\n']);
    output = [];
end

end