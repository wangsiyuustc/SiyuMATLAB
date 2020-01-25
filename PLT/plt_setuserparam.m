function plt_setuserparam(fd, vars)
    global plt_params;
    inarglist = fieldnames(plt_params.(fd));
    i = 1;
    while i <= length(vars)
        arg = vars{i};
        val = vars{i+1};
        idx = find(strcmp(inarglist, arg));
        if ~isempty(idx)
            plt_params.(fd).(arg) = val;
        elseif strcmp('help', arg)
            disp(inarglist);
        else
            warning(sprintf('command not recognized: %s', arg));
        end
        i = i + 2;
    end
end
