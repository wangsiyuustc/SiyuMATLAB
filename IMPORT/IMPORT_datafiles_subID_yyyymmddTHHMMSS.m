function data = IMPORT_datafiles_subID_yyyymmddTHHMMSS(datadir, filetemplate, importfunc, ...
    str_subID, num_subID, str_datetime, num_datetime, subIDrange, outputdir, outputname)
% this function works for files with format:
% PRESTR_subjectID_yyyymmddTHHMMSS.mat
% the importfunc must include a column named gameNumber
    if ~exist('func_data')
        func_data = [];
    end
    games = IMPORT_datafiles(importfunc, datadir, filetemplate);
    disp('Processing...');
    subs = str_getSubIDDatetime({games.filename}, str_subID, num_subID, str_datetime, num_datetime);
    idx_subID = ([subs.subjectID] >= subIDrange(1)) & ([subs.subjectID] <= subIDrange(2));
    games = games(idx_subID);
    subs = subs(idx_subID);
    subtable = unique(struct2table(subs));
    data = [];
    for gi = 1:length(games)
        tgame = games(gi);
        [fx] = struct_getfieldsize(tgame, 1);
        fnms = fieldnames(tgame);
        fnms = fnms(fx == 1);
        for fi = 1:length(fnms)
            tgame.(fnms{fi}) = repmat(tgame.(fnms{fi}), length(tgame.gameNumber),1);
        end
        ttab = struct2table(tgame);
        ttab = join(ttab, subtable);
        data = vertcat(data, ttab);
    end
    idx_filename = find(strcmp(fieldnames(data), 'filename'));
    data = data(:,[idx_filename:size(data,2), 1:idx_filename-1]);
    if exist('outputname') && exist('outputdir') && ~isempty(outputname)
        writetable(data, fullfile(outputdir ,['RAW_', outputname, '.csv']));
    end
    disp(sprintf('Completed - imported from raw files'));
end
