function out = tool_bin_middle(bin)
    out = diff(bin)/2 + bin(1:end-1);
end