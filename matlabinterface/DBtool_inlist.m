function inlist = DBtool_inlist(valuesvector)
%inlist = DBtool_inlist(valuesvector)
% values vecor should be a vector of numbers that you'd like returned as a parenthetical, comma separated string
%ex: inlist = DBtool_inlist([1,2,3])
%     inlist = '( 1  , 2  , 3 )'

if isempty(valuesvector)
    inlist = ' ( null ) ';
    return
end

inlist=[];
if isnumeric(valuesvector)
    
    if  numel(valuesvector) == 1
        inlist = sprintf(' ( %d ) ',valuesvector(1));
    else
        for i = 1:numel(valuesvector)
            if i == 1
                inlist = sprintf(' ( %d ',valuesvector(i));
            elseif i == numel(valuesvector)
                inlist = sprintf('%s , %d ) ',inlist,valuesvector(i));
            else
                inlist = sprintf('%s , %d ',inlist,valuesvector(i));
            end
        end
    end
elseif iscellstr(valuesvector)
    for i = 1:numel(valuesvector)
        inlist = sprintf('%s ''%s'' ,',inlist,valuesvector{i});
    end
    inlist = [' ( ' inlist(1:end-1) ' ) '];
else
    error('boo-boo');
end

end