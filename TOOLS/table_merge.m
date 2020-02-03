function [ab, outidxgp, outid] = table_merge(a, b, col_id)
    [idx1, id1] = ANALYSIS_subjectselection(a, col_id);
    [idx2, id2] = ANALYSIS_subjectselection(b, col_id);
    id = unique([id1; id2]);
    idxgp = cell(length(id), 2);
    idxgp(cellfun(@(x)find(strcmp(x, id)), id1),1) = idx1;
    idxgp(cellfun(@(x)find(strcmp(x, id)), id2),2) = idx2;
    outidxgp = idxgp;
    outid = id;
    missing1 = cellfun(@(x)isempty(x), idxgp(:,1));
    disp(sprintf('%d rowids missing for table A:', sum(missing1)));
    idmissing1 = id(missing1,:);
    for mi = 1:length(idmissing1)
        disp(sprintf('   ...%s',strrep(idmissing1{mi}, 'SIYU', ', ')));
    end
    idxgp = idxgp(~missing1, :);
    id = id(~missing1,:);
    
    b.(col_id{1})(end+1) = tool_settypedefault(class(b.(col_id{1})));
    
    fnmsa = fieldnames(a);
    fnmsb = fieldnames(b);
    fnmsb = fnmsb(~contains(fnmsb, fnmsa));
    b0 = table;
    for bi = 1:length(fnmsb)
        b0.(fnmsb{bi}) = b.(fnmsb{bi});
    end
    
    
    nID = length(id);
    idx_same = arrayfun(@(x)length(idxgp{x,1}) == length(idxgp{x,2}), 1:nID);
    idx_1 = arrayfun(@(x)length(idxgp{x,2}) == 1, 1:nID) & ~idx_same;
    idx_err = ~idx_same & ~idx_1;
    disp(sprintf('%d rowids mismatched for table B:', sum(idx_err)));
    for ii = find(idx_1)
        idxgp{ii,2} = repmat(idxgp{ii,2}, length(idxgp{ii,1}), 1);
    end
    for ii = find(idx_err)
        idxgp{ii,2} = repmat(size(b0,1), length(idxgp{ii,1}), 1);
    end
    row_matched = [vertcat(idxgp{:,1}) vertcat(idxgp{:,2})];
    
    ab = [a(row_matched(:,1),:), b0(row_matched(:,2),:)];
end

