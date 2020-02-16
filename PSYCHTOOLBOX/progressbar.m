classdef progressbar < exp_psychtoolbox
    properties
        threshold
        now
        temp
        isstop
        yloc
        scalefactor
        outlineLength
        outlineHeight

        color_progress
        color_temp
        color_finish
        
        rect_temp
        rect_now
        rect_0
    end
    methods
        function obj = progressbar()
            obj.window = [];
            obj.flush(0);
        end
        function setup_pgb(obj, window, x, y, yloc, color_progress, color_temp, color_finish)
            obj.window = window;
            obj.outlineLength = round(x * window.w);
            obj.outlineHeight = round(y * window.h);
            obj.yloc = round(yloc * window.h);
            obj.color_progress = color_progress;
            obj.color_temp = color_temp;
            obj.color_finish = color_finish;
        end
        function flush(obj, thres)
            obj.threshold = thres;
            if thres ~= 0
                obj.scalefactor = obj.outlineLength/obj.threshold;
            else
                obj.scalefactor = 0;
            end
            obj.now = 0;
            obj.temp = 0;
            obj.isstop = 0;
            obj.computerect;
        end
        function add(obj, r, i)
            if ~exist('i') || isempty(i)
                i = 1;
            end
            if length(obj.temp) < i
                obj.temp(i) = 0;
            end
            obj.temp(i) = obj.temp(i) + r;
            if obj.now + sum(obj.temp) >= obj.threshold
                obj.isstop = 1;
            end
            obj.computerect;
        end
        function update(obj)
            obj.now = obj.now + sum(obj.temp);
            obj.temp = 0;
            obj.computerect;
        end
        function computerect(obj)
            if ~isempty(obj.window)
                yloc = obj.yloc;
                reward = obj.now * obj.scalefactor;
                rewardnow = obj.temp * obj.scalefactor;
                window = obj.window.id;
                outlineHeight = obj.outlineHeight;
                outlineLength = obj.outlineLength;
                xCenter = obj.window.center.x;
                leftXPosition = xCenter - (outlineLength/2);
                rightXPosition = xCenter + (outlineLength/2);
                xCenterReward = leftXPosition + (reward/2);
                baseRectReward = [0 0 reward (outlineHeight-2)];
                obj.rect_now = CenterRectOnPointd(baseRectReward, xCenterReward+1, yloc);
                baseRect = [0 0 outlineLength outlineHeight];
                obj.rect_0 = CenterRectOnPointd(baseRect, xCenter, yloc);
                rewardnow = [0 cumsum(rewardnow)];
                for i = 1:length(rewardnow)-1
                    baseRectRewardnow = [rewardnow(i) 0 rewardnow(i+1) (outlineHeight-2)];
                    obj.rect_temp{i} = CenterRectOnPointd(baseRectRewardnow, xCenterReward+ reward/2 + rewardnow(i) + (rewardnow(i+1) - rewardnow(i))/2,...
                        yloc);
                end
            end
        end
        function draw(obj)
            window = obj.window.id;
            rectColor = [1 1 1];
            Screen('FrameRect', window, rectColor, obj.rect_0);
            if obj.isstop
                rectColorProgressnow = obj.color_finish;
                rectColorProgress = obj.color_finish;
            else
                rectColorProgressnow = tool_encell(obj.color_temp);
                rectColorProgress = obj.color_progress;
            end
            for i = 1:length(obj.temp)
                Screen('FillRect', window, rectColorProgressnow{i}, obj.rect_temp{i});
            end
            Screen('FillRect', window, rectColorProgress, obj.rect_now);
        end
    end
end
