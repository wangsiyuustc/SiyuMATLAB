function [idxgpboth, idboth, idxgp, id] = ANALYSIS_subjectmatching(game1, game2, opt_sub)
    [idx1, id1] = ANALYSIS_subjectselection(game1, opt_sub);
    nsub1 = cellfun(@(x)length(x), idx1);
    [idx2, id2] = ANALYSIS_subjectselection(game2, opt_sub);
    nsub2 = cellfun(@(x)length(x), idx2);
    
    disp(sprintf('game1: %d items, %d duplicated rows omitted, leaving %d rows', ...
        size(idx1,1), sum(nsub1(nsub1>1)), sum(nsub1(nsub1==1)))); 
    g1 = game1(nsub1 == 1,:);
    id1 = id1(nsub1 == 1, :);
    idx1 = idx1(nsub1 == 1, :);
    
    disp(sprintf('game2: %d items, %d duplicated rows omitted, leaving %d rows', ...
        size(idx2,1), sum(nsub2(nsub2>1)), sum(nsub2(nsub2==1)))); 
    g2 = game2(nsub2 == 1,:);
    id2 = id2(nsub2 == 1, :);
    idx2 = idx2(nsub2 == 1, :);
    
    id = unique([id1; id2]);
    idxgp = NaN(length(id), 2);
    idxgp(cellfun(@(x)find(strcmp(x, id)), id1),1) = [idx1{:}];
    idxgp(cellfun(@(x)find(strcmp(x, id)), id2),2) = [idx2{:}];
    idxboth = all(~isnan(idxgp)')';
    disp(sprintf('#%d in game1, #%d in game2, #%d in common', ...
        sum(~isnan(idxgp(:,1))), sum(~isnan(idxgp(:,2))), ...
        sum(idxboth) ));
    idxgpboth = idxgp(idxboth,:);
    idboth = id(idxboth,:);
end
