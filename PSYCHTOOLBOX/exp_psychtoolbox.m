classdef exp_psychtoolbox < handle
    % by siyu, sywangr@email.arizona.edu 01/30/20
    properties
        window
        font
        colors
        availablekeys
    end
    methods
        function obj = exp_psychtoolbox()
            PsychDefaultSetup(2);
            KbName('UnifyKeyNames');
            obj.setup_exp_psychtoolbox;
        end
        function testmode(obj, HID, opacity)
            if ~exist('HID')
                HID = 0;
            end
            if ~exist('opacity')
                opacity = 0.5;
            end
            PsychDebugWindowConfiguration(HID, opacity);
        end
        function setup_exp_psychtoolbox(obj)
            obj.availablekeys = [];
            obj.setup_font(40, [1 1 1], 'Arial', 70);
            obj.setup_color;
        end
        function setup_font(obj, fontsize, fontcolor, fonttype, fontwrapat)
            font.fontwrapat = fontwrapat;
            font.fonttype = fonttype;
            font.fontcolor = fontcolor;
            font.fontsize = fontsize;
            obj.font = font;
        end
        function setup_color(obj)
            obj.colors = generate_colors;
        end
        function setup_window(obj, win, windowmode, color_background, synctest)
            if ~exist('win')
                win = [];
            end
            if ~exist('windowmode')
                windowmode = [];
            end
            if ~exist('color_background')
                color_background = obj.colors.black;
            end
            if ~isempty(win)
                obj.window = win;
            else
                screens = Screen('Screens');
                screenNumber = max(screens);
                Screen('Preference', 'SkipSyncTests', 1);
                [win.id win.windowRect] = PsychImaging('OpenWindow', screenNumber, color_background, windowmode);
                [win.w win.h] = Screen('WindowSize', win.id);
                [center.x center.y] = RectCenter(win.windowRect);
                win.center = center;
                obj.window = win;
                obj.window.scalefactor = obj.window.h/1080; % set default to 1080
                if obj.window.scalefactor > 1
                    obj.window.scalefactor = 1;
                end
                obj.font.fontsize = round(obj.font.fontsize * obj.window.scalefactor);
                Screen('TextSize', obj.window.id, obj.font.fontsize);
                Screen('TextFont', win.id, obj.font.fonttype);
                Screen('TextColor', win.id, obj.font.fontcolor);
            end
        end
        function time = flip(obj)
            time = Screen('Flip',obj.window.id);
        end
        function time = talkAndflip(obj, str, varargin)
            obj.talk(str, varargin);
            time = obj.flip;
        end
        function talk(obj, str, option, windowrect, fontsize, fontcolor)
            if ~exist('option') || isempty(option)
                option = 'default';
            end
            w = obj.window.w;
            h = obj.window.h;
            if ~exist('windowrect') || isempty(windowrect)
                windowrect = [0 0 obj.window.w obj.window.h];
            end
            if ~exist('fontcolor') || isempty(fontcolor)
                fontcolor = obj.colors.white;
            end
            if exist('fontsize') && ~isempty(fontsize)
                oldTextSize = Screen('TextSize', obj.window.id);
                Screen('TextSize', obj.window.id, fontsize);
            end
            switch option
                case 'default'
                    DrawFormattedText(obj.window.id, str, ...
                        'center', 'center', fontcolor, obj.font.fontwrapat);
                case 'instructions'
                    DrawFormattedText(obj.window.id, str, ...
                        0.05*w, 0.07*h, fontcolor, obj.font.fontwrapat);
                case 'pageturner'
                    DrawFormattedText(obj.window.id, ...
                        str, ...
                        'center', 0.93*h, fontcolor, obj.font.fontwrapat);
                case 'pagenumber'
                    DrawFormattedText(obj.window.id, ...
                        ['Page ' num2str(str(1)) ' of ' num2str(str(2))], ...
                        [w*0.05],[h*0.93], fontcolor, obj.font.fontwrapat);
                case 'window'
                    h = windowrect(4) - windowrect(2);
                    windowrect([2 4]) = windowrect([2 4]) - h*0.15; % example about how to fix small shifts
                    DrawFormattedText(obj.window.id, ...
                        str,'center', 'center', fontcolor, ...
                        obj.font.fontwrapat, 0, 0, 1, 0, windowrect);
            end
            if exist('oldTextSize')
                Screen('TextSize', obj.window.id, oldTextSize);
            end
        end
        function setup_keylist(obj, KL)
            disp('restricting keys');
            obj.availablekeys = KL;
            RestrictKeysForKbCheck(KL);
        end
        function [KeyNum, when, deltawhen, KeyCode] = waitForInput(obj, validkeys, timeout, waittime, isrelease)
            if ~exist('waittime') || isempty(waittime)
                waittime = 0.2;
            end
            if ~exist('timeout') || isempty(timeout)
                timeout = inf;
            end
            if ~exist('isrelease') || isempty(isrelease)
                isrelease = 1;
            end
            if ~exist('validkeys')
                validkeys = [];
            end
            KeyNum = NaN;
            when = NaN;
            deltawhen = NaN;
            KeyCode = NaN;
            Pressed = 0;
            time_0 = GetSecs();
            while (GetSecs - time_0 < timeout)
                if Pressed <= 1
                    [~, twhen, tKeyNum, tdeltawhen] = KbCheck;
                end
                tKeyNum = [find(tKeyNum)];
                if length(tKeyNum) == 0
                    if Pressed == 1
                        break;
                    end
                elseif length(tKeyNum) == 4 || sum(ismember(tKeyNum, KbName({'s','c','a','p'}))) == 4 % this will only work if the keyboard is not locked
                    sca;
                    pause;
                elseif length(tKeyNum) == 1 && ismember(tKeyNum,validkeys)
                    when = twhen;
                    KeyNum = tKeyNum;
                    deltawhen = tdeltawhen;
                    Pressed = 1;
                    if ~isrelease
                        break;
                    end
                end
            end
            if ~isempty(validkeys) && ~isnan(KeyNum)
                KeyCode = find(KeyNum == validkeys);
            end
            WaitSecs(waittime);
        end
    end
end
