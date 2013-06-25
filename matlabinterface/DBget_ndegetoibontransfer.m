function [firstpostswaptime swaptype] = DBget_ndegetoibontransfer(conn,subjectid)

sssub = DBx(conn,...
    [ ...
    ' SELECT sstrialtime, sstrial.sstriallocationid, sstriallocationname ' ...
    ' FROM sstrial ' ...
    ' JOIN sstriallocation ON sstrial.sstriallocationid = sstriallocation.sstriallocationid ' ...
    ' WHERE subjectid = ' DBtool_num2strNULL(subjectid) ...
    ' ORDER BY sstrialtime' ...
    ]);

dinds = find(diff(cell2mat(sssub(:,2)))~=0); %gives the from location

for dn = 1:length(dinds)
    firstpostswaptime(dn) = datenum(sssub(dinds(dn)+1,1));
    if cell2mat(sssub(dinds(dn),2)) == 0 && cell2mat(sssub(dinds(dn)+1,2)) == 1
        swaptype{dn} = 'ndege to ibon';
    elseif cell2mat(sssub(dinds(dn),2)) == 1 && cell2mat(sssub(dinds(dn)+1,2)) == 0
        swaptype{dn} = 'ibon to ndege';
    else
        error('yikes! - in C:\Users\Dan\Documents\My Dropbox\mfiles\newDB\DBget_ndegetoibontransfer.m');
    end
end

end


