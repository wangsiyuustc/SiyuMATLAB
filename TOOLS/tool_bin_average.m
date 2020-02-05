function [av, num] = tool_bin_average(y, x, bins)
    if size(bins,1) <= 2 && size(bins,2) > 2
        bins = bins';
    end
    if size(bins, 2) == 1
        bins = [bins(1:end-1), bins(2:end)];
    end
    for bi = 1:size(bins,1)
        idx = x >= bins(bi,1) & x < bins(bi,2);
        av(bi) = nanmean(y(idx));
        num(bi) = sum(~isnan(y(idx)));
    end
end