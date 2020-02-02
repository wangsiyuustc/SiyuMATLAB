function [sub] = ANALYSIS_sub(games, idxsub, options, oplist, funclist)
    % by Siyu Wang (sywangr@email.arizona.edu)
    % 08/08/2019
    n_sub = length(idxsub);
    sub = game2sub(games, idxsub);
    for oi = 1:length(options)
        option = options{oi};
        id = find(strcmp(oplist, option));
        if length(id) == 1
            tfunc = funclist{id};
        else
            warning(sprintf('unrecognized command: %s', option));
            continue;
        end
        tfunc = str2func(tfunc);
        disp(['analysis: ' option '...']);
        clear tsub;
        for si = 1:n_sub
            tsub(si) = tfunc(games(idxsub{si},:));
        end
        sub = struct_merge(sub, tsub);
    end
    sub = struct2table(sub);
end
