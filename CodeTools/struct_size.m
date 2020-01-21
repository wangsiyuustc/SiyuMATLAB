function [out, fnms] = struct_size(d, n)
% n = 1 or 2
fnms = fieldnames(d);
out = cellfun(@(x)size(d.(x), n), fnms);
end