function tab = table_autofieldcombine(tab)
    % 01-27-20
    fs = tab.Properties.VariableNames;
    idx_ = strfind(fs, '_');
    is_ = find(contains(fs, '_'));
    idxnonnum_ = arrayfun(@(x)isempty(str2num(fs{x}(idx_{x}(end)+1:end))), is_);
    is_ = is_(~idxnonnum_);
    fs_ = unique(arrayfun(@(x)fs{x}(1:idx_{x}(end)), is_,'UniformOutput',false));
    for fi = 1:length(fs_)
        fn = fs_{fi};
        idx_col = find(arrayfun(@(x)length(fn) <= length(fs{x}) && ...
            strcmp(fs{x}(1:length(fn)),fn) && idx_{x}(end) == length(fn), 1:length(fs)));
        ord = arrayfun(@(x)str2num(fs{x}(idx_{x}(end)+1:end)), idx_col);
        [~, idx] = sort(ord);
        idx_col = idx_col(idx);
        tab = mergevars(tab, fs(idx_col), 'NewVariableName', fn(1:end-1));
    end
end
