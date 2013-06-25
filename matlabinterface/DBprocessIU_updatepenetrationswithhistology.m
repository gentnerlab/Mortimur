function [updatedpenids] = DBprocessIU_updatepenetrationswithhistology(penetrationinfo)
%get penetrationinfo =  z:\experiments\analysis\workingdata\WD_getpenetrationinfo()

for currrow = 1:size(penetrationinfo,1)
 
    query = ['SELECT DISTINCT penetrationid FROM penetrationmeta '...
        ' WHERE subjectname = ' DBtool_num2strNULL(penetrationinfo{currrow,1})...
        ' AND hemispherename = ' DBtool_num2strNULL(penetrationinfo{currrow,2})...
        ' AND rostral = ' DBtool_num2strNULL(penetrationinfo{currrow,3})...
        ' AND lateral = ' DBtool_num2strNULL(penetrationinfo{currrow,4})...
        ' AND serialnumber = ' DBtool_num2strNULL(penetrationinfo{currrow,5})...
        ];

        penetrationid = DBx(conn,query);
    if isempty(penetrationid)
        fprintf(1,'could not find penetration for currrow: %d\n',currrow);
        zz=1;
    elseif length(penetrationid) > 1 %found more than one penetration - this is bad.
        error('found more than one penetration - this is bad.');
    else %found just one penetration
        columnstoupdate = {'histologycorrectionrostral' 'histologycorrectionlateral' 'histologycorrectionventral' 'cmtop' 'cmbottom'};
        valuestoupdate = penetrationinfo(currrow,9:13);
        update(conn,'penetration',columnstoupdate,valuestoupdate,['WHERE penetrationid = ' DBtool_num2strNULL(cell2mat(penetrationid))]);
    end
  
end