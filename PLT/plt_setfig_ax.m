function plt_setfig_ax(varargin)
    % siyu, sywangr@email.arizona.edu, 01/26/20
    global plt_params;
    if ~isfield(plt_params, 'param_fig')
        plt_setfig('new');
    end
    n_ax = plt_params.n_ax;
    axi = plt_params.axi;
    i = 1;
    while i <= nargin
        arg = varargin{i};
        val = varargin{i+1};
        i = i + 2;
        if ~any(strcmp(arg, {'size', 'xlabel','ylabel','legend','title', ...
            'xlim','ylim','color','xlim','ylim', ...
            'xtick','xticklabel','ytick','yticklabel','legloc'}))
            warning(sprintf('%s is not a sub-field of param_fig, value skipped', arg));
            continue;
        end
        switch arg
            case 'color'
                colorfunc = @(str)cellfun(@(x)iff(isnumeric(x), x, plt_params.param_preset.colors.(x)),str,'UniformOutput',false);
                if ~iscell(val)
                    val = {val};
                end
                if ~iscell(val{1}) % single plot, multiple lines
                    val = colorfunc(val);
                else
                    error('wrong color format');
                end
        end
        if ~iscell(val) % same for each plot
            val = {val};
        end
        plt_params.param_fig.(arg){axi} = val;
    end
    plt_params.param_fig.locked = true;
end
