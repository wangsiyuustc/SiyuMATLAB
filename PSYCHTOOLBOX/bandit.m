classdef bandit < exp_psychtoolbox
    properties
        numbers

        w
        h
        w_lever
        h_lever
        pos_lever
        penwidth
        dotradius
        horizon
        lever_side
        font_bandit
        color_frame
        color_filled

        tp_top
        tp_left
        rect

    end
    methods
        function obj = bandit(window)
            obj.window = window;
            obj.flush;
        end
        function flush(obj)
            obj.numbers = {};
        end
        function addreward(obj, new)
            obj.numbers{end+1} = new;
        end
        function setreward(obj, new)
            obj.numbers = tool_encell(new);
        end
        function setup(obj,w,h,w_lever,h_lever,pos_lever,penwidth,dotradius,horizon,lever_side, font_bandit, color_frame, color_filled)
            obj.w = round(w); % width of the box in each bandit
            obj.h = round(h); % height of the box in each bandit
            obj.w_lever = round(w_lever); % width of the lever
            obj.h_lever = round(h_lever); % height of the lever
            obj.pos_lever = round(pos_lever); % Position of the lever, at where in the bandit
            obj.penwidth = round(penwidth); % width of the bar
            obj.dotradius = round(dotradius); % size of the handle
            obj.horizon = horizon; % horizon
            obj.lever_side = lever_side; % side of the handle
            obj.font_bandit = font_bandit; % font format for the bandit
            obj.color_frame = color_frame;
            obj.color_filled = tool_encell(color_filled); % Arizona color for highlight
            obj.settppos(0,0);
        end
        function settppos(obj, cleft, top)
            cleft = obj.window.w * cleft;
            top = obj.window.h * top;
            w = obj.w;
            h = obj.h;
            left = cleft - w/2;
            obj.tp_left = left;
            obj.tp_top = top;
            for i = 1:obj.horizon
                obj.rect(i,:) = round([left+0; top+h*(i-1); left+w; top+h*i]);
            end
        end
        function draw(obj, played, nfilled)
            if ~exist('played') || isempty(played)
                played = 0;
            end
            if ~exist('nfilled') || isempty(nfilled)
                nfilled = 0;
            end
            numbers = obj.numbers;
            rect = obj.rect;
            top = mean(rect(:,2));
            left = mean(rect(:,1));
            if nfilled > 0
                Screen('FillRect', obj.window.id, obj.color_filled{nfilled}, rect(1,:));
            end
            Screen('FrameRect', obj.window.id, obj.color_frame, rect, obj.penwidth);
            for i = 1:length(numbers)
                trec = rect(i,:);
                obj.talk(numbers{i}, 'window', trec, obj.font_bandit);
            end
            switch obj.lever_side
                case 'left'
                    fromH = left;
                    toH = fromH - obj.w_lever;
                case 'right'
                    fromH = left + obj.w;
                    toH = fromH + obj.w_lever;
            end
            fromV = top + obj.pos_lever * obj.h;
            if played
                toV = fromV + obj.h_lever;
            else
                toV = fromV - obj.h_lever;
            end
            Screen('Drawline', obj.window.id, obj.color_frame, fromH, fromV, toH, toV, obj.penwidth);
            if obj.dotradius > 0
                Screen('DrawDots', obj.window.id, [toH toV], obj.dotradius, obj.color_frame, [0 0]);
            end
        end

    end
end
