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
    end
    methods
        function obj = progressbar()
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
        end
        function add(obj, r)
            obj.temp = obj.temp + r;
            if obj.now + obj.temp >= obj.threshold
                obj.isstop = 1;
                obj.temp = obj.threshold - obj.now;
            end
        end
        function update(obj)
            obj.now = obj.now + obj.temp;
            obj.temp = 0;
        end
        function draw(obj)
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

            baseRectRewardnow = [0 0 rewardnow (outlineHeight-2)];
            centeredRectProgressnow = CenterRectOnPointd(baseRectRewardnow, xCenterReward+ reward/2 + rewardnow/2,...
                yloc);

            baseRectReward = [0 0 reward (outlineHeight-2)];
            centeredRectProgress = CenterRectOnPointd(baseRectReward, xCenterReward+1, yloc);
            if obj.isstop
                rectColorProgressnow = obj.color_finish;
                rectColorProgress = obj.color_finish;
            else
                rectColorProgressnow = obj.color_progress;
                rectColorProgress = obj.color_temp;
            end
            baseRect = [0 0 outlineLength outlineHeight];
            centeredRect = CenterRectOnPointd(baseRect, xCenter, yloc);
            rectColor = [1 1 1];
            Screen('FrameRect', window, rectColor, centeredRect);
            Screen('FillRect', window, rectColorProgress, centeredRectProgress);
            Screen('FillRect', window, rectColorProgressnow, centeredRectProgressnow);
        end
    end
end
