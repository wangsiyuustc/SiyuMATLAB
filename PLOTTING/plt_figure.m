function [g, ax] = plt_figure(nx, ny, rect, margin, gap, option)
    global plt_params
    plt_setfig('new');
    if (exist('nx')~=1) || isempty(nx) || nx < 1
        nx = 1;
    end
    if (exist('ny')~=1) || isempty(ny) || ny < 1
        ny = 1;
    end
    if ~exist('rect') || ~exist('margin') || ~exist('gap') || isempty(rect) || isempty(margin) || isempty(gap)
        fmt = plt_params.param_setting.format;
        if exist('option') && option == 1
            istitle = 't';
        else
            istitle = '';
        end
        try
            rect = plt_params.param_preset.figconfig.(fmt).(['fig_size', istitle]){nx,ny};
            margin = plt_params.param_preset.figconfig.(fmt).(['fig_margin', istitle]){nx,ny};
            gap = plt_params.param_preset.figconfig.(fmt).(['fig_gap', istitle]){nx,ny};
            gap(1); % this is just to test whether gap is empty
        catch
            disp('no existing preset size');
            rect = plt_params.param_preset.figconfig.(fmt).(['fig_size', istitle]){1,1};
            margin = plt_params.param_preset.figconfig.(fmt).(['fig_margin', istitle]){1,1};
            gap = plt_params.param_preset.figconfig.(fmt).(['fig_gap', istitle]){1,1};
        end
    end
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
    plt_params.gf = g;
    plt_params.axes = ax;
    plt_params.axi = 0;
    plt_params.isholdon = false;
    plt_params.leglist = cell(nx*ny);
    plt_setfig('size', [nx*ny]);
end
