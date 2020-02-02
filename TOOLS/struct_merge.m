function a = struct_merge(a, b)
    % Siyu (sywangr@email.arizona.edu)
    % 08/08/2019
    % did not deal with nested structures... but works for the
    % first layer of struct
    if isempty(a)
        a = b;
        return;
    end
    f = fieldnames(b);
    for i = 1:length(f)
        if isfield(a, f{i})
            warning(sprintf('overwrite field %s in a with field %s in b', f{i}, f{i}));
        end
        [a.(f{i})] = deal(b.(f{i}));
    end
end