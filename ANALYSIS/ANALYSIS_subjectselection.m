function [rowid, id] = ANALYSIS_subjectselection(data, identityfields)
    disp('selecting subjects');
    fs = data.Properties.VariableNames;
    if ~exist('identityfields') || isempty(identityfields)
        identityfields = {'subjectID', 'Date', 'Time'};
    end
    if ~iscell(identityfields)
        identityfields = {identityfields};
    end
    ids = [];
    for fi = 1:length(identityfields)
        tidx = strmatch(identityfields{fi}, fs, 'exact');
        if ~isempty(tidx)
            tid = data.(identityfields{fi});
            if ~isstring(tid)
                tid = arrayfun(@(x)string(x), tid, 'UniformOutput', false);
            end
            if isempty(ids)
                ids = tid;
            else
                ids = arrayfun(@(x)strcat(ids{x}, 'SIYU', tid{x}), [1:length(tid)]', 'UniformOutput', false);
            end
        else
            warning(sprintf('wrong field names, ignored: %s', identityfields{fi}));
        end
    end
    ids = cellfun(@(x)char(x), ids, 'UniformOutput', false);
    id = unique(ids);
    rowid = cellfun(@(x) find(strcmp(x, ids)), id, 'UniformOutput', false);
end