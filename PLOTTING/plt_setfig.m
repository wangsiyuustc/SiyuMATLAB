function plt_setfig(varargin)
    % siyu, sywangr@email.arizona.edu, 01/26/20
    global plt_params;
    plt_setparams;
    i = 1;
    while i <= nargin
        arg = varargin{i};
        if ~isfield(plt_params, 'param_fig') || ...
                (strcmp(arg, 'new') && ~plt_params.param_fig.locked)
            plt_params.param_fig.color = [];
            plt_params.param_fig.xlim = [];
            plt_params.param_fig.ylim = [];
            plt_params.param_fig.title = [];
            plt_params.param_fig.legend = [];
            plt_params.param_fig.legloc = [];
            plt_params.param_fig.xlabel = [];
            plt_params.param_fig.ylabel = [];
            plt_params.param_fig.xticklabel = [];
            plt_params.param_fig.yticklabel = [];
            plt_params.param_fig.xtick = [];
            plt_params.param_fig.ytick = [];
            plt_params.n_ax = NaN;
        end
        if strcmp(arg, 'new')
            i = i + 1;
            continue;
        end
        val = varargin{i+1};
        i = i + 2;
        if ~any(strcmp(arg, {'size', 'xlabel','ylabel','legend','title', ...
            'xlim','ylim','color','xlim','ylim', ...
            'xtick','xticklabel','ytick','yticklabel','legloc'}))
            warning(sprintf('%s is not a sub-field of param_fig, value skipped', arg));
            continue;
        end
        n_ax = plt_params.n_ax;
        switch arg
            case 'size'
                plt_params.n_ax = val;
                continue;
            case 'color'
                colorfunc = @(str)cellfun(@(x)tool_iif(isnumeric(x), x, plt_params.param_preset.colors.(x)),str,'UniformOutput',false);
                val = tool_encell(val);
                if ~iscell(val{1}) % single plot, multiple lines
                    val = colorfunc(val);
                else
                    tval = [];
                    for ni = 1:length(val)
                        tval{ni} = colorfunc(val{ni});
                    end
                    val = tval;
                end
        end
        val = tool_encell(val);
        if isnan(n_ax)
            plt_params.param_fig.(arg) = val;
            warning('n_ax not defined');
        elseif length(val) == n_ax % have params for each different plot
            plt_params.param_fig.(arg) = val;
        elseif length(val) == 1
            plt_params.param_fig.(arg) = repmat(val, 1, n_ax);
        else
            plt_params.param_fig.(arg) = repmat({val}, 1, n_ax);
        end
    end
    plt_params.param_fig.locked = true;
end
