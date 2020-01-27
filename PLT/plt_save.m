function plt_save(filename)
    global plt_params
    if (plt_params.param_setting.fig_issave)
        if isempty(plt_params.param_setting.fig_dir) && ~ischar(plt_params.param_setting.fig_dir)
            error('set up figdir first');
        end
        filefolder = plt_params.param_setting.fig_dir;
        filefullpath = fullfile(filefolder, ...
            strcat(filename, plt_params.param_setting.fig_suffix, '.png'));
        if ~exist(filefolder)
            mkdir(filefolder);
        end
        saveas(plt_params.gf, filefullpath, 'png');
    end
end
