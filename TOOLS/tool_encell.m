function a = tool_encell(a)
    if ~exist('a')
        a = {};
    elseif ~iscell(a)
        a = {a};
    end
end
