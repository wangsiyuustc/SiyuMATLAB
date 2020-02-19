function out = str_isnumber(str)
    if ~ischar(str) && ~isstring(str)
        warning('not a string');
        out = NaN;
    end
    idxnum = arrayfun(@(x)length(str2num(x)), char(str)) & char(str) ~= 'i';
%     tstr = str2num(str(idxnum));
    out = sum(~idxnum) == 0; % && isnumeric(tstr); % what is this for?
end