function [g, ax] = plt_figure(nx, ny, rect, margin, gap)
    global plt_params
    plt_setparams;
    hg = ones(1, nx+1) * gap(1);
    wg = ones(1, ny+1) * gap(2);
    hg(1) = margin(1);
    wg(1) = margin(2);
    hg(end) = margin(3);
    wg(end) = margin(4);
    hb = (ones(nx,1)-sum(hg)) / nx;
    wb = (ones(ny,1)-sum(wg)) / ny;
    if plt_params.param_setting.isshow
        g = figure('visible','on');
    else
        g = figure('visible','off');
    end
    set(g, 'units','normalized','outerposition',rect);
    count = 1;
    for i_high = nx:-1:1
        for i_wide = 1:ny
            bx(1) = sum(wg(1:i_wide)) + sum(wb(1:i_wide-1));
            bx(2) = sum(hg(1:i_high)) + sum(hb(1:i_high-1));
            bx(3) = wb(i_wide);
            bx(4) = hb(i_high);
            rc{count} = bx;
            count = count + 1;
        end
    end
    for i = 1:length(rc)
        axes('position', rc{i})
        ax(i) = gca;
        set(gca, 'tickdir', 'out');
    end
    plt_params.fig = g;
    plt_params.ax = ax;
end
