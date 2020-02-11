function str = plt_scatter(x, y, option)
    if ~exist('option')
        option = 'corr';
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
    st = plot(x, y, '.', 'MarkerSize', dotsize,'Color', color{1});
    str = sprintf('R = %.2f, p = %g', r, p);
    plt_params.leglist{plt_params.axi}(end+1) = st;
    switch option
        case 'corr'
                lsline;
        case 'diag'
            xmin = min(min(x), min(y));
            xmax = max(min(x), max(y));
            dx = xmax - xmin;
            xmin = xmin - dx * 0.2;
            xmax = xmax + dx * 0.2;
            plot([xmin,xmax], [xmin,xmax], '--k', 'linewidth', plt_params.param_figsetting.linewidth);
            xlim([xmin xmax]);
            ylim([xmin xmax]);
    end
end
