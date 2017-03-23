% % MIT License
% % 
% % Copyright (c) 2016 ISEA, Heiko Witzenhausen
% % 
% % Permission is hereby granted, free of charge, to any person obtaining a copy
% % of this software and associated documentation files (the "Software"), to deal
% % in the Software without restriction, including without limitation the rights
% % to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% % copies of the Software, and to permit persons to whom the Software is
% % furnished to do so, subject to the following conditions:
% % 
% % The above copyright notice and this permission notice shall be included in all
% % copies or substantial portions of the Software. The Text "Developed by ISEA @ RWTH Aachen" 
% % may not be removed from the graphical user interface.
% % 
% % THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% % IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% % FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% % AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% % LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% % OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% % SOFTWARE.
% % 

function [LP, neu_fitDaten, status] = Messpunkte_Weg(LP_str,Daten)

LP_ind_temp = textscan(LP_str, '%s', 'delimiter', ',');
%     csvread,feof
%   die Index von gelöschten Punkten werden notiert.
LP_ind = zeros();
for LP_i = 1:length(LP_ind_temp{1,1})
    if isempty(strfind(LP_ind_temp{1,1}{LP_i,1},':'))
        LP_ind =[LP_ind, str2double(LP_ind_temp{1,1}{LP_i,1})];
    else
        LP_ind_temp2 = textscan(LP_ind_temp{1,1}{LP_i,1}, '%d', 'delimiter', ':');
        if length(LP_ind_temp2{1,1}) ~= 2 
            status = 'Fehler1';
            return
        end
        for LP_ind_temp2_i = LP_ind_temp2{1,1}(1):LP_ind_temp2{1,1}(2)
            LP_ind = [LP_ind,LP_ind_temp2_i];
        end
    end
end
LP_ind(1)= [];  

%   die neu Messdaten erstellen
LP_add = 1;
neu_fitDaten = Daten;
for D_i = 1:length(Daten)
    for LP_j = 1:length(LP_ind)
        if D_i == LP_ind(LP_j)
            LP(LP_add,:) = Daten(D_i,:);
            LP_add = LP_add + 1;
        
            neu_fitDaten(D_i,:) = 0;
        end
    end
end

% 0 Elemente wegnehmen
neu_fitDaten(~any(neu_fitDaten,2),:)=[];

% durch die Anzahl von Daten prüfen
s = size(LP);
if s(1) + length(neu_fitDaten) ~= length(Daten)
    status = 'Fehler2';
else 
    status = 'OK';
end
