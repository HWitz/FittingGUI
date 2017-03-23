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

function [ ModellZeile ] = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix)
DoppelteParameter = zeros(1,numel(Modell.inputs));
BisherigeParameter = strsplit(ModellZeile{3},',');
Modell.ParameterIndexes = (1:numel(Modell.inputs))+numel(ModellZeile{4});
for i = 1:numel(Modell.inputs)
    if ismember('NewParName',fieldnames(Modell))
        Modell.Zfun = strrep(Modell.Zfun,Modell.inputs{i},Modell.NewParName{i});
        Modell.Zfun_HF = strrep(Modell.Zfun_HF,Modell.inputs{i},Modell.NewParName{i});
        Modell.Zfun_MF = strrep(Modell.Zfun_MF,Modell.inputs{i},Modell.NewParName{i});
        Modell.Zfun_LF = strrep(Modell.Zfun_LF,Modell.inputs{i},Modell.NewParName{i});
        Modell.inputs{i} = Modell.NewParName{i};
        if ismember(Modell.inputs{i},BisherigeParameter)
            DoppelteParameter(i)=1;
            Modell.ParameterIndexes(i)=find(strcmp(BisherigeParameter,Modell.inputs{i}),1,'first');
            Modell.ParameterIndexes(i+1:end)=Modell.ParameterIndexes(i+1:end)+1;
        else
            ModellZeile{3} = [ModellZeile{3} ',' Modell.inputs{i}];
        end
    else
        Modell.Zfun = strrep(Modell.Zfun,Modell.inputs{i},[Modell.inputs{i},Appendix]);
        Modell.Zfun_HF = strrep(Modell.Zfun_HF,Modell.inputs{i},[Modell.inputs{i},Appendix]);
        Modell.Zfun_MF = strrep(Modell.Zfun_MF,Modell.inputs{i},[Modell.inputs{i},Appendix]);
        Modell.Zfun_LF = strrep(Modell.Zfun_LF,Modell.inputs{i},[Modell.inputs{i},Appendix]);
        Modell.inputs{i} = [Modell.inputs{i},Appendix];
        ModellZeile{3} = [ModellZeile{3} ',' Modell.inputs{i}];
    end
end
switch HFMFLF
    case 'HF'
        Modell.Z_HF = @Modell.Z;
        Modell.Z_MF = @(varargin)(0);
        Modell.Z_LF = @(varargin)(0);
        Modell.Zfun_HF = Modell.Zfun;
        Modell.Zfun_MF = '0';
        Modell.Zfun_LF = '0';
        ModellZeile{2} = [ModellZeile{2} '+HF.*(' Modell.Zfun ')'];
    case 'MF'
        Modell.Z_HF = @(varargin)(0);
        Modell.Z_MF = @Modell.Z;
        Modell.Z_LF = @(varargin)(0);
        Modell.Zfun_HF = '0';
        Modell.Zfun_MF = Modell.Zfun;
        Modell.Zfun_LF = '0';
        ModellZeile{2} = [ModellZeile{2} '+MF.*(' Modell.Zfun ')'];
    case 'LF'
        Modell.Z_HF = @(varargin)(0);
        Modell.Z_MF = @(varargin)(0);
        Modell.Z_LF = @Modell.Z;
        Modell.Zfun_HF = '0';
        Modell.Zfun_MF = '0';
        Modell.Zfun_LF = Modell.Zfun;
        ModellZeile{2} = [ModellZeile{2} '+LF.*(' Modell.Zfun ')'];
    otherwise
        ModellZeile{2} = [ModellZeile{2} '+HF.*(' Modell.Zfun_HF ')' ...
                                         '+MF.*(' Modell.Zfun_MF ')' ...
                                         '+LF.*(' Modell.Zfun_LF ')'];
end
if ModellZeile{2}(1) == '+' , ModellZeile{2} = ModellZeile{2}(2:end);end
if ModellZeile{3}(1) == ',' , ModellZeile{3} = ModellZeile{3}(2:end);end

ModellZeile{4} = [ModellZeile{4} Startwerte(DoppelteParameter==0)];
ModellZeile{5} = [ModellZeile{5} Minimum(DoppelteParameter==0)];
ModellZeile{6} = [ModellZeile{6} Maximum(DoppelteParameter==0)];
ModellZeile{7} = [ModellZeile{7} Fix(DoppelteParameter==0)];
ModellZeile{8} = [ModellZeile{8} Modell];


end
