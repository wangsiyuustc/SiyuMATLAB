function [out, idxnum] = str_selectnum(str)
    str = char(str);
    idx_num = zeros(1, length(str));
    if length(str) == 0
        out = NaN;
    elseif str_isnumber(str)
        str = string(str);
        out = str2num(str);
    else
        idxnum = arrayfun(@(x)length(str2num(x)), char(str)) & char(str) ~= 'i';
        idx_num = find(idxnum);
        if length(idx_num) == 1 || (length(idx_num) > 1 && all(diff(idx_num) == 1))
            out = str2num(str(idx_num));
        else
            out = NaN; % if the numbers are not together, ex "2 boys and 5 girls"
        end
    end
end