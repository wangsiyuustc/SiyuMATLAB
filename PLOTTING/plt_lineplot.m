function plt_lineplot(av, mbar, x, dotonly)
    %   by sywangr@email.arizona.edu
    %   02/03/2020
    %   av - number of lines by number of dots in each line
    if ~exist('dotonly')
        dotonly = false;
    end
    if dotonly
        option_dot.plt = 'o';
        option_dot.eb = 'o';
    else
        option_dot.plt = '-';
        option_dot.eb = 'o-';
    end
    global plt_params;
    if (exist('x')~=1) || isempty(x)
        x = 1:size(av, 2);
    end
    if ~isempty(plt_params.param_fig.color)
        color = tool_encell(plt_params.param_fig.color{plt_params.axi});
    else
        color = {};
    end
    nls = size(av,1);
    if length(color) >= nls
        plt_params.param_fig.color{plt_params.axi} = color(nls+1:end); % remove the used colors
        color = color(1:nls);
    elseif ~isempty(color)
        warning('number of colors assigned is smaller than the nunmber of lines');
        color = {};
    end
    if ~plt_params.isholdon
        hold on;
    end
    for li = 1:nls
        if ~exist('mbar') || isempty(mbar)
            eb = plot(x, av(li,:), option_dot.plt, ...
                'LineWidth', plt_params.param_figsetting.linewidth);
            eb.MarkerSize = plt_params.param_figsetting.errorbarcapsize;
        else
            eb = errorbar(x, av(li,:), mbar(li,:), option_dot.eb, ...
                'LineWidth', plt_params.param_figsetting.linewidth);
            eb.CapSize = plt_params.param_figsetting.errorbarcapsize;
        end
        if ~isempty(color)
            eb.Color = color{li};
            eb.MarkerFaceColor = color{li};
        end
        plt_params.leglist{plt_params.axi}(end + 1) = eb;
    end
    if ~plt_params.isholdon
        hold off;
    end
end
