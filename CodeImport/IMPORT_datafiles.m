function games = IMPORT_datafiles(funcimport, datadir, filetemplate)
    % by sywangr@email.arizona.edu
    % version 1.0
    files = dir(fullfile(datadir, filetemplate));
    nfile = length(files);
    for fi = 1:nfile
        filename = files(fi).name;
        disp(sprintf('importing file: %s', filename));
        tdata = load(fullfile(files(fi).folder, filename));
        tgame = funcimport(tdata);
        if ~isempty(tgame)
            for ti = 1:length(tgame)
                tgame(ti).filename = string(filename);
            end
%             % func is only called if data is non-empty
%             if exist('funcmisc') && ~isempty(funcmisc)
%                 tgame2 = funcmisc(tdata);
%                 tgame = siyu_func.structmerge(tgame, tgame2);
%             end
        else
            disp('failed to import - empty output');
        end     
        data{fi} = tgame;
    end
    games = [data{:}];
    disp(sprintf('Complete: %d files imported', nfile));
end
