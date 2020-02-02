function sub = game2sub(data, idxsub)
    for si = 1:length(idxsub)
        lines = idxsub{si};
        fs = data.Properties.VariableNames;
        for fi = 1:length(fs)
            td = data.(fs{fi})(lines,:);
            if length(tool_nanunique(td)) == 1
                flag_uniq(si,fi) = 1;
            else
                flag_uniq(si,fi) = 0;
            end
        end
    end
    flag_uniq = all(flag_uniq);
    for si = 1:length(idxsub)
        lines = idxsub{si};
        for fi = find(flag_uniq)
            td = data.(fs{fi})(lines,:);
            sub(si).(fs{fi}) = tool_nanunique(td);
        end
    end
end