function string = DBtool_num2strNULL(value,desformat)
%string = DBtool_num2strNULL(value,desformat)
%currently, the only possible values for desformat are: 'default' or 'double4places'


if isempty(value)
    string = 'null';
    return
end

if ~exist('desformat','var')
    desformat = 'default';
end

if isnumeric(value)
    if strcmp(desformat,'default')
        string = num2str(value);
    elseif strcmp(desformat,'double4places')
        string = num2str(value,'%6.4f');
    else
        error('huh?!');
    end
elseif ischar(value)
    if strcmp(value,'null')
        string=value;
    else
        string = ['''' value ''''];
    end
else
    error('huh?!');
end

end