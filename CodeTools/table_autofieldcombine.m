function tab = table_autofieldcombine(tab)
fs = tab.Properties.VariableNames;
idx_ = strfind(fs, '_');
is_ = find(contains(fs, '_'));
idxnonnum_ = arrayfun(@(x)isempty(str2num(fs{x}(idx_{x}(end)+1:end))), is_);
is_ = is_(~idxnonnum_);
fs_ = unique(arrayfun(@(x)fs{x}(1:idx_{x}(end)-1), is_,'UniformOutput',false));
for fi = 1:length(fs_)
    fn = fs_{fi};
    idx_col = find(contains(fs, fn));
    ord = arrayfun(@(x)str2num(fs{x}(idx_{x}(end)+1:end)), idx_col);
    [~, idx] = sort(ord);
    idx_col = idx_col(idx);
    tab = mergevars(tab, fs(idx_col), 'NewVariableName', fn);
end
end
