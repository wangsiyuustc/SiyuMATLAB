function out = tool_getarraynan(a, x)
    if  any(isnan(x))
        out = NaN;
    else
        if any(size(a) == 1) && length(x) == 1 % 1 dimensional array
            out = a(x);
        elseif length(x) == 2
            out  = a(x(1), x(2));
        else
            warning('check tool_getarraynan');
            out = NaN;
        end
    end
end