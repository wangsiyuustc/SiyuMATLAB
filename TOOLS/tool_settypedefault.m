function out = tool_settypedefault(a)
    switch a
        case 'double'
            out = NaN;
        case 'cell'
            out = {};
        case 'string'
            out = string('');
        case 'char'
            out = '';
    end
end