classdef fixedcross < exp_psychtoolbox
    properties
        size
        linewidth
        color_cross
        center
    end
    methods
        function obj = fixedcross(window)
            obj.setup_window(window);
        end
        function setup(obj, size, linewidth, color_cross, center)
            obj.color_cross = color_cross;
            obj.size = ceil(size * obj.window.scalefactor);
            obj.linewidth = ceil(linewidth * obj.window.scalefactor);
            obj.center = ceil(center.*[obj.window.w obj.window.h]);
        end
        function draw(obj)
            size = obj.size;
            xCoords = [-size size 0 0];
            yCoords = [0 0 -size size];
            Coords = [xCoords; yCoords];
            Screen('DrawLines', obj.window.id, Coords, obj.linewidth, obj.color_cross, obj.center);
        end
        function time = drawAndflip(obj)
            obj.draw;
            time = obj.flip;
        end
    end
end
