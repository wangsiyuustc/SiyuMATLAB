function games = ANALYSIS_game_subjectlevel(games, idxsub, options, oplist, funclist)
    % by Siyu Wang (sywangr@email.arizona.edu)
    % 12/05/2019
    n_sub = length(idxsub);
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
        clear tgame;
        for si = 1:n_sub
            tout = tfunc(games(idxsub{si},:));
            if isstruct(tout)
                fnms = fieldnames(tout);
                for fi = 1:length(fnms)
                    fnm = fnms{fi};
                    tgame.(fnm)(idxsub{si},:) = tout.(fnm);
                end
            else
                tgame(idxsub{si},:) = tout;
            end
        end
        if isstruct(tgame)
            tgame = struct2table(tgame);
        end
        games = [games, tgame];
    end
    disp('complete preprocessing(subject dependent)');
end
