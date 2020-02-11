function out = tool_nanunique(a)
    a = unique(a);
    if iscell(a)
        out = a;
        return;
    end
    if isnumeric(a) && any(isnan(a))
        a(isnan(a)) = [];
        a(end+1) = NaN;
    end
    out = a;
end