function out = str_isnumber(str)
    if ~ischar(str) && ~isstring(str)
        warning('not a string');
        out = NaN;
    end
    out = length(str2num(str)) > 0;
end