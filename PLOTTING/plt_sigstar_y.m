function plt_sigstar_y(ylocs, xlocs, stats, side)
    xlim('auto');
    ylim('auto');
    switch side
        case 'left'
            side = -1;
        case 'right'
            side = 1;
    end
    nosort = false;
    if ~nosort
        [~,ind]=sort(ylocs(:,2)-ylocs(:,1),'ascend');
        ylocs = ylocs(ind,:);
        stats = stats(ind);
    end
    ntot = length(stats);
    holdstate = ishold;
    hold on
    H = ones(ntot,2); %The handles will be stored here
    dist = 0.05;
    xrg = range(xlim);
    yd = xrg*dist; %separate sig bars vertically by 5%
    for ii = 1:ntot
        thisX = getmax_xlim(ylocs(ii,:), side);
        thisX = thisX + side*yd;
        if ii == 1
            thisX = thisX + side*xrg*0.1;
        end
        % draw bar and star
        [H(ii,:), dist] = makeSignificanceBar_y(thisX, ylocs(ii,:), side, stats(ii), ntot > 3);
        % dash line
        for yj = 1:size(xlocs,2)
            if ~isnan(dist) || ntot < 4
                XXX = sort([thisX,xlocs(yj)]);
                XXX = XXX(1):0.05:XXX(2);
                plot([XXX],repmat(ylocs(ii,yj),size(XXX,1),size(XXX,2)),'.k','LineWidth',0.5);
            end
        end
    end
    yd = range(xlim)*0.02; %Ticks are 2% of the y axis range
    for ii = 1:ntot
        tx=get(H(ii,1),'XData');
        ty=get(H(ii,1),'YData');
        x = tx([1 3 2 4]);
        y = ty([1 3 2 4]);
        x(1)=x(1)-side*yd;
        x(4)=x(4)-side*yd;
        set(H(ii,1),'YData',y)
        set(H(ii,1),'XData',x)
    end
    %Be neat and return hold state to whatever it was before we started
    if ~holdstate
        hold off
    elseif holdstate
        hold on
    end
end
function [H,dist]=makeSignificanceBar_y(x,y,side,p, flag)
    %makeSignificanceBar produces the bar and defines how many asterisks we get for a
    %given p-value
    if ~exist('flag')
        flag = false;
    end
    stars = getstatstars(p);
    x = repmat(x,1,4);
    y = repmat(y,1,2);
    
    if p > 0.1 && flag
        H(1) = plot(x,y(:),'-k','LineWidth',0.5,'Tag','sigstar_bar', 'visible','off');
    else
        H(1) = plot(x,y(:),'-k','LineWidth',0.5,'Tag','sigstar_bar');
    end
    %Increase offset between line and text if we will print "n.s."
    %instead of a star.
    if ~isnan(p) && p <= 0.1
        offset=0.001;
        dist = 0.04;
    else
        offset=0.01;
        dist = NaN;
    end

    starX = mean(x)+ side * range(xlim)*offset;
    if p > 0.2 && flag
        H(2) = text(starX,mean(y(:)),stars,...
            'HorizontalAlignment','center',...
            'VerticalAlignment','baseline',...
            'BackGroundColor','none',...
            'Tag','sigstar_stars','FontSize',20,'visible', 'off');
        set(H(2),'Rotation',180 + 90*side);
    else
        H(2) = text(starX,mean(y(:)),stars,...
            'HorizontalAlignment','center',...
            'VerticalAlignment','baseline',...
            'BackGroundColor','none',...
            'Tag','sigstar_stars','FontSize',20);
        set(H(2),'Rotation',180 + 90*side);
    end

    X=xlim;
    if starX*side > side*(side*max(side*X)+side*range(X)*0.05)
        xnew = sort([starX+side*range(X)*0.05 side*max(side*X)+side*range(X)*0.05 X]);
        xlim([xnew(1) xnew(3)]); % may have a bug here...
    end
end %close makeSignificanceBar

function out = getstatstars(p0, nons)
    global plt_params
    if ~exist('nons')
        nons = [];
    end
    if isempty(nons) || isnan(nons)
        nons = 'n.s.';
    end
    for i = 1:size(p0,1)
        for j = 1:size(p0,2)
            p = p0(i,j);
            if p<=1E-3
                stars='***';
            elseif p<=1E-2
                stars='**';
            elseif p<=0.05
                stars='*';
            elseif p <= 0.1
                stars='+';
            elseif p > 0.1
%                 if isempty(nons)
%                     stars = sprintf('%.2f', p);
%                 else
                    stars = nons;
%                 end
            elseif isnan(p)
                stars = 'n.a.';
            else
                stars=' ';
            end
            if strcmp(plt_params.param_figsetting.stat_starorvalue, 'value')
                out{i,j} = sprintf('%.3f', p);
            else
                out{i,j} = stars;
            end
        end
    end
end
function X = getmax_xlim(y, side)
    oldXLim = get(gca,'xlim');
    oldYLim = get(gca,'ylim');
    axis(gca,'tight');
    y = sort(y);
    if y(1) == y(2)
        y(2) = y(2) + 0.00001;
    end
    set(gca,'ylim', y) %Matlab automatically re-tightens y-axis
    xLim = get(gca,'xlim'); %Now have max y value of all elements within range.
    switch side
        case 1
            X = max(xLim);
        case -1
            X = min(xLim);
    end
    axis(gca,'normal')
    set(gca,'xlim',oldXLim,'ylim',oldYLim)
end %close getmax_xlim