function [sub, id, ids] = excludesubject(sub, varargin)
    disp('excluding subjects');
    vi = 1;
    t0 = ones(size(sub,1), 1) == 1;
    id = t0;
    while vi <= length(varargin)
        arg = varargin{vi};
        val = varargin{vi+1};
        td = sub.(arg);
        vi = vi + 2;
        tid = t0;
        if ~isnan(val(1))
            tid = tid & (td >= val(1));
        end
        if ~isnan(val(2))
            tid = tid & (td <= val(2));
        end
        ids.(arg) = tid;
        disp(sprintf('%d participants excluded, %d remaining', sum(id & ~tid), sum(id & tid)));
        id = id & tid;
    end
    sub = sub(id,:);
end