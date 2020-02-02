function [out] = struct_getfieldsize(d, n)
% n = 1 or 2
fnms = fieldnames(d);
out = cellfun(@(x)size(d.(x), n), fnms);
end
