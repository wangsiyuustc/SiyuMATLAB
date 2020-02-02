function plt_update(option)
    global plt_params;
    if exist('option') && strcmp(option, 'now')
        axs = plt_params.axi;
    else
        axs = 1:length(plt_params.axes);
    end
    for axi = axs
        axes(plt_params.axes(axi));
        if ~isempty(plt_params.param_fig.xtick)
            if isempty(plt_params.param_fig.xticklabel)
                set(gca,'XTick', plt_params.param_fig.xtick{axi});
            else
                set(gca,'XTick', plt_params.param_fig.xtick{axi}, ...
                    'XTickLabel', plt_params.param_fig.xticklabel{axi});
            end
        end
        if ~isempty(plt_params.param_fig.ytick)
            if isempty(plt_params.param_fig.yticklabel)
                set(gca,'YTick', plt_params.param_fig.ytick{axi});
            else
                set(gca,'YTick', plt_params.param_fig.ytick{axi}, ...
                    'YTickLabel', plt_params.param_fig.yticklabel{axi});
            end
        end
        if ~isempty(plt_params.param_fig.xlim)
            xlim(plt_params.param_fig.xlim{axi});
        end
        if ~isempty(plt_params.param_fig.ylim)
            ylim(plt_params.param_fig.ylim{axi});
        end
        if ~isempty(plt_params.param_fig.title)
            str = plt_params.param_fig.title{axi};
            title(str,'FontWeight','normal','FontSize', plt_params.param_figsetting.fontsize_face);
        end
        if ~isempty(plt_params.param_fig.xlabel)
            xlabel(plt_params.param_fig.xlabel{axi}, 'FontSize', plt_params.param_figsetting.fontsize_face);
        end
        if ~isempty(plt_params.param_fig.ylabel)
            ylabel(plt_params.param_fig.ylabel{axi}, 'FontSize', plt_params.param_figsetting.fontsize_face);
        end
        if ~isempty(plt_params.param_fig.legend)
            if isempty(plt_params.param_fig.legloc) || ...
                    isempty(plt_params.param_fig.legloc{axi})
                tlegloc = 'NorthEast';
            else
                tlegloc = plt_params.param_fig.legloc{axi};
            end
            fontsize = plt_params.param_figsetting.fontsize_leg;
            leg = plt_params.param_fig.legend{axi};
            if ~iscell(leg)
                leg = {leg};
            end
            if length(leg) == length(plt_params.leglist{axi})
                lgd = legend(plt_params.leglist{axi}, leg,...
                    'Location', tlegloc);
                lgd.FontSize = fontsize;
                if plt_params.param_figsetting.islegbox
                    legend('boxon')
                else
                    legend('boxoff');
                end
            else
                warning('legend ignored: number of legend entries didn''t match the number of plots');
            end
        end
    end
    axes(plt_params.axes(plt_params.axi));
    plt_params.param_fig.locked = false;
end
