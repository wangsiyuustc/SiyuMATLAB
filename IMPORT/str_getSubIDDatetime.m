function out = str_getSubIDDatetime(filenames, str_subID, num_subID, str_datetime, num_datetime)
     for fi = 1:length(filenames)
        filename = filenames{fi};
        out(fi).subjectID = str2num(str_select(filename, str_subID{1}, str_subID{2}, ...
            num_subID(1), num_subID(2)));
        strdatetime = str_select(filename, str_datetime{1}, str_datetime{2}, ...
            num_datetime(1), num_datetime(2));
        out(fi).date = yyyymmdd(datetime(strdatetime));
        out(fi).time = timeofday(datetime(strdatetime));
        out(fi).filename = string(filename);
     end
end