function y = tool_extendnan(x, n, selectside, sortside)
% select the first n columns of a matrix, if there are fewer
% than n columns, fill missing data with NaNs
if ~exist('selectside') || isempty(selectside)
    selectside = 'left';
end
if ~exist('sortside')
    sortside = 'left';
end
if size(x,2) < n
    switch sortside
        case 'left'
            y = [x nan(size(x,1), n- size(x,2))];
        case 'right'
            y = [nan(size(x,1), n- size(x,2)) x];
    end
else
    switch selectside
        case 'left'
            y = x(:,1:n);
        case 'right'
            y = x(:,end-n+1:end);
    end
end
end