function [DString, DStringOrig] = isdate (DateString)
% Checking date
% Syntax
% [DString] = isdate (DateString)
% Description
% [DString] = isdate (DateString) -- checks whether DateString has a
% proper date format: 'yyyy-mm-dd HHMMSS'.
% isdate returns a string if DateString is good and [] otherwise.
DString = [];
DStringOrig = [];
if (length(DateString) == 19)
    CheckResult = (DateString >= '0000-00-00 00:00:00') & (DateString <= '9999-19-39 29:59:59');
    CheckResult = all(CheckResult);
    
    Year = str2num(DateString(1:4)); %#ok<*ST2NM>
    Month = str2num(DateString(6:7));
    Day = str2num(DateString(9:10));
    Hour = str2num(DateString(12:13));
    Minutes = str2num(DateString(15:16));
    Seconds = str2num(DateString(18:19));
    if isempty(Year) ||  isempty(Month)||  isempty(Day)||  isempty(Hour)||  isempty(Minutes)||  isempty(Seconds)
        CheckResult = 0;
        return;
    end
    CheckResult = CheckResult & (Year >= 1753);
    CheckResult = CheckResult & (Month >= 1) & (Month <= 12);
    if (any(Month == [1 3 5 7 8 10 12]))
        CheckResult = CheckResult & (Day >= 1) & (Day <= 31); % Be carefull!
    elseif (any(Month == [4 6 9 11]))
        CheckResult = CheckResult & (Day >= 1) & (Day <= 30); % Be carefull!
    else
        CheckResult = CheckResult & (Day >= 1) & (Day <= 29); % Be carefull!
    end
    CheckResult = CheckResult & (Hour <= 23);
    CheckResult = CheckResult & (Minutes <= 59);
    CheckResult = CheckResult & (Seconds <= 59);
    if CheckResult
        DString = datestr(datenum(DateString(1:10),'yyyy-mm-dd'));
        DStringOrig = DateString(1:10);
    end
    
elseif (length(DateString) == 17)
    CheckResult = (DateString >= '0000-00-00 000000') & (DateString <= '9999-19-39 295959');
    CheckResult = all(CheckResult);
    
    Year = str2num(DateString(1:4)); %#ok<*ST2NM>
    Month = str2num(DateString(6:7));
    Day = str2num(DateString(9:10));
    Hour = str2num(DateString(12:13));
    Minutes = str2num(DateString(14:15));
    Seconds = str2num(DateString(16:17));
    if isempty(Year) ||  isempty(Month)||  isempty(Day)||  isempty(Hour)||  isempty(Minutes)||  isempty(Seconds)
        CheckResult = 0;
        return;
    end
    CheckResult = CheckResult & (Year >= 1753);
    CheckResult = CheckResult & (Month >= 1) & (Month <= 12);
    if (any(Month == [1 3 5 7 8 10 12]))
        CheckResult = CheckResult & (Day >= 1) & (Day <= 31); % Be carefull!
    elseif (any(Month == [4 6 9 11]))
        CheckResult = CheckResult & (Day >= 1) & (Day <= 30); % Be carefull!
    else
        CheckResult = CheckResult & (Day >= 1) & (Day <= 29); % Be carefull!
    end
    CheckResult = CheckResult & (Hour <= 23);
    CheckResult = CheckResult & (Minutes <= 59);
    CheckResult = CheckResult & (Seconds <= 59);
    if CheckResult
        DString = datestr(datenum(DateString(1:10),'yyyy-mm-dd'));
        DStringOrig = DateString(1:10);
    end
    
elseif (length(DateString) == 10)
    CheckResult = (DateString >= '0000-00-00') & (DateString <= '9999-19-39');
    CheckResult = all(CheckResult);
    
    Year = str2num(DateString(1:4)); %#ok<*ST2NM>
    Month = str2num(DateString(6:7));
    Day = str2num(DateString(9:10));
    if isempty(Year) ||  isempty(Month)||  isempty(Day)  
        CheckResult = 0;
        return;
    end
    
    
    CheckResult = CheckResult & (Year >= 1753);
    CheckResult = CheckResult & (Month >= 1) & (Month <= 12);
    if (any(Month == [1 3 5 7 8 10 12]))
        CheckResult = CheckResult & (Day >= 1) & (Day <= 31); % Be carefull!
    elseif (any(Month == [4 6 9 11]))
        CheckResult = CheckResult & (Day >= 1) & (Day <= 30); % Be carefull!
    else
        CheckResult = CheckResult & (Day >= 1) & (Day <= 29); % Be carefull!
    end
    if CheckResult
        DString = datestr(datenum(DateString(1:10),'yyyy-mm-dd'));
        DStringOrig = DateString(1:10);
    else
        CheckResult = (DateString >= '00-00-0000') & (DateString <= '39-19-9999');
        CheckResult = all(CheckResult);

        Year = str2num(DateString(7:10)); %#ok<*ST2NM>
        Month = str2num(DateString(4:5));
        Day = str2num(DateString(1:2));
        if isempty(Year) ||  isempty(Month)||  isempty(Day)  
            CheckResult = 0;
            return;
        end


        CheckResult = CheckResult & (Year >= 1753);
        CheckResult = CheckResult & (Month >= 1) & (Month <= 12);
        if (any(Month == [1 3 5 7 8 10 12]))
            CheckResult = CheckResult & (Day >= 1) & (Day <= 31); % Be carefull!
        elseif (any(Month == [4 6 9 11]))
            CheckResult = CheckResult & (Day >= 1) & (Day <= 30); % Be carefull!
        else
            CheckResult = CheckResult & (Day >= 1) & (Day <= 29); % Be carefull!
        end
        if CheckResult
            DString = datestr(datenum(DateString(1:10),'dd-mm-yyyy'));
            DStringOrig = DateString(1:10);
        end
    end
elseif (length(DateString) == 8)
    CheckResult = (DateString >= '00000000') & (DateString <= '99991939');
    CheckResult = all(CheckResult);
    
    Year = str2num(DateString(1:4)); %#ok<*ST2NM>
    Month = str2num(DateString(5:6));
    Day = str2num(DateString(7:8));
    if isempty(Year) ||  isempty(Month)||  isempty(Day)  
        CheckResult = 0;
        return;
    end
    
    
    CheckResult = CheckResult & (Year >= 1753);
    CheckResult = CheckResult & (Month >= 1) & (Month <= 12);
    if (any(Month == [1 3 5 7 8 10 12]))
        CheckResult = CheckResult & (Day >= 1) & (Day <= 31); % Be carefull!
    elseif (any(Month == [4 6 9 11]))
        CheckResult = CheckResult & (Day >= 1) & (Day <= 30); % Be carefull!
    else
        CheckResult = CheckResult & (Day >= 1) & (Day <= 29); % Be carefull!
    end
    if CheckResult
        DString = datestr(datenum(DateString,'yyyymmdd'));
        DStringOrig = DateString;
    else
        CheckResult = (DateString >= '00000000') & (DateString <= '39199999');
        CheckResult = all(CheckResult);

        Year = str2num(DateString(5:8)); %#ok<*ST2NM>
        Month = str2num(DateString(3:4));
        Day = str2num(DateString(1:2));
        if isempty(Year) ||  isempty(Month)||  isempty(Day)  
            CheckResult = 0;
            return;
        end


        CheckResult = CheckResult & (Year >= 1753);
        CheckResult = CheckResult & (Month >= 1) & (Month <= 12);
        if (any(Month == [1 3 5 7 8 10 12]))
            CheckResult = CheckResult & (Day >= 1) & (Day <= 31); % Be carefull!
        elseif (any(Month == [4 6 9 11]))
            CheckResult = CheckResult & (Day >= 1) & (Day <= 30); % Be carefull!
        else
            CheckResult = CheckResult & (Day >= 1) & (Day <= 29); % Be carefull!
        end
        if CheckResult
            DString = datestr(datenum(DateString,'ddmmyyyy'));
            DStringOrig = DateString;
        end
    end
    
else
    CheckResult = false;
end