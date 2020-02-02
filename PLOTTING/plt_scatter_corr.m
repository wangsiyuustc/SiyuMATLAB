function str = plt_scatter_corr(x, y, isline)
    if ~exist('isline')
        isline = true;
    end
    global plt_params;
    if ~isempty(plt_params.param_fig.color)
        color = plt_params.param_fig.color{plt_params.axi};
    else
        color = [];
    end
    if length(color) > 1
        plt_params.param_fig.color{plt_params.axi} = color(2:end); % remove the used colors
        color = color(1);
    end
    x = reshape(x, length(x), 1);
    y = reshape(y, length(x), 1);
    [r, p] = corr(x,y);
    dotsize = plt_params.param_figsetting.dotsize;
    hold on;
    st = plot(x, y, '.', 'MarkerSize', dotsize);
    str = sprintf('R = %.2f, p = %.2f', r, p);
    plt_params.leglist{plt_params.axi}(end+1) = st;
    if isline
        lsline;
    end
end
