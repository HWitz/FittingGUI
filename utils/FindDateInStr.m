function [DString, DStringOrig] = FindDateInStr(filename)
filename = strrep(filename,'/','-');
DString = [];
DStringOrig = [];
datefound = 0;
    for i = 1:length(filename)-18
        [DString DStringOrig] = isdate(filename(i:i+18));
        if ~isempty(DString)
           datefound = 1;
           break
        end
    end
    if datefound == 0
        for i = 1:length(filename)-16
            [DString DStringOrig] = isdate(filename(i:i+16));
            if ~isempty(DString)
               datefound = 1;
               break
            end
        end
    end
    if datefound == 0
        for i = 1:length(filename)-9
           [DString DStringOrig] = isdate(filename(i:i+9)) ;
           if ~isempty(DString)
               datefound = 1;
               break
            end
        end
    end
    if datefound == 0
        for i = 1:length(filename)-7
           	[DString DStringOrig] = isdate(filename(i:i+7));
            if ~isempty(DString)
               datefound = 1;
               break
            end
        end
    end
