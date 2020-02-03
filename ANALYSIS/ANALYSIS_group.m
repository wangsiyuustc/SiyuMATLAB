function gp = ANALYSIS_group(sub, suffixcompare, additional_compare, switch_paircompare)
    if ~exist('switch_paircompare')
        switch_paircompare = true;
    end
    if ~exist('suffixcompare')
        suffixcompare = [];
    end
    if ~exist('additional_compare')
        additional_compare = [];
    end
    gp = [];
    sub = table_autofieldcombine(sub);
    fnms = fieldnames(table2struct(sub));
    for fi = 1:length(fnms) % ex. regular av/se
        fn = fnms{fi};
        td = sub.(fn);
        if isnumeric(td)
            gp.(['av_' fn]) = nanmean(td);
            gp.(['ste_' fn]) = nanstd(td)./sqrt(sum(~isnan(td)));
            % pvalue of pairs
            if switch_paircompare && size(td,2) == 2
                [~,gp.(['pvalue_' fn])] = ttest(diff(td')');
            end
        elseif (iscell(td) && all(cellfun(@(x)isnumeric(x), td)))
            td0 = td;
            nx = size(td0{1},1);
            ny = size(td0{1},2);
            for nxi = 1:nx
                for nyi = 1:ny
                    td = cellfun(@(x)x(nxi,nyi), td0);
                    gp.(['av_' fn])(nxi, nyi) = nanmean(td);
                    gp.(['ste_' fn])(nxi, nyi) = nanstd(td)./sqrt(sum(~isnan(td)));
                end
            end
        elseif length(unique(td)) == 1 % all elements are the same
            gp.(fn) = unique(td);
        else
            warning(sprintf('ignored %s, format not supported', fn));
        end
    end
    for ai = 1:length(suffixcompare) % ex. _h1 vs _h6
        tfn0 = suffixcompare{ai};
        tfn = fnms(contains(fnms, [tfn0, '_']));
        tds =  cellfun(@(x)sub.(x), tfn, 'UniformOutput', false);
        isnums =  cellfun(@(x)isnumeric(x), tds);
        if ~all(isnums)
            continue;
        end
        if length(tds) == 2
            tpval = [];
            for ci = 1:size(tds{1},2)
                [~, tpval(ci)] = ttest(tds{2}(:,ci) - tds{1}(:,ci));
            end
        else
            warning('ANOVA has not been implemented here, to be done');
        end
        gp.(['pvalue_suffix_' tfn0]) = tpval;
    end
    for ai = 1:length(additional_compare) % ex. _h1 vs _h6
        tfn = tool_encell(additional_compare{ai});
        tds =  cellfun(@(x)sub.(x), tfn, 'UniformOutput', false);
        if ~all(isnums)
            continue;
        end
        if length(tds) == 2
            tpval = [];
            for ci = 1:size(tds{1},2)
                [~, tpval(ci)] = ttest(tds{2}(:,ci) - tds{1}(:,ci));
            end
        else
            warning('ANOVA has not been implemented here, to be done');
        end
        gp.(['pvalue_', strjoin(tfn0,'_vs_')]) = tpval;
    end
    gp = struct2table(gp);
end
