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

function config
    global Pattern
Pattern.MasterProgram = {'sc_p_eis_MS','FAIR_EIS_param_hd' , 'FAIR_EIS_paramhdA123','FAIR_EIS_p_hd_sanyo','FAIR_EIS_p_hd_kokam','hwi_sc_p_eis_m','hwi_nmc_eis_m_T','hwi_nmc_eis_m','GOELK_EIS_K','hwi_nmc_dceispuls','hwi_nmc_dceiscool','hwi_dceiscool','hwi_nmc_eisCont','hwi_lfp_dceiscool','hwi_lfp_dceispuls','eisdchcha'};
Pattern.Temperatur={'m\d\d\dgrad','m\d\dgrad','\d\d\dgrad_','\d\dgrad','\d\d\d_grad','m\d\d_grad','\d\d_grad',...
    '\d\d\dGrad','m\d\dGrad','\d\dGrad','\d\d\d_Grad','m\d\d_Grad','\d\d_Grad',...
    'm\d\dT_','\d\dT_','m\dT_','\dT_','_lowT_\d\d\d_','_lowT_m\d\d_'};
Pattern.SOC={'\d\d\dSOC_','\d\dSOC_','m\d\dSOC_','\d\dSOC','\d\d\d__SOC','\d\d\d_SOC','\d\d_SOC','m\d\d__SOC','\d\d__SOC','m\d__SOC','\d__SOC',...
             '\d\d\dSO_','\d\dSO_','m\d\dSO_','\d\dSO','\d\d\d__SO','\d\d\d_SO','\d\d_SO','m\d\d__SO','\d\d__SO','m\d__SO','\d__SO'};
Pattern.Zustand={'CU\d\d\d','CU\d\d','CU\d','CU_\d\d\d','CU_\d\d','CU_\d','init','Init','Zyk_\d\d\d','Zyk_\d\d','Zyk_\d','Zyklen_\d\d\d\d','Zyklen_\d\d\d','Zyklen_\d\d','Zyklen_\d','Continuous','=\d\d_psa'};
Pattern.Batterie={'iMiEV_50Ah_\d\d\d','MiEV_50Ah_\d\d\d','Samsung_i3_\d\d\d','eSmart_Litec_\d\d\d\d_\d'};


global Modellliste

addpath('ersatzschaltbilder')
addpath('ESBElemente')
addpath('utils')
folders = dir('utils');
for folder = folders'
    if folder.isdir && ~strcmp(folder.name,'.') && ~strcmp(folder.name,'..')
        addpath(['utils/' folder.name])
    end
end
addpath('utils/peakfinder')

Modellliste.Modell = {...
    'DRT_Komp'      ,'MF*R0   +   HF*1i.*w*L0   +  LF*1./(1i.*w.*C0)'...
                    ,'R0,L0,C0'...
                    {0 1e-6 1e4},{0 0 0},{inf inf inf},{0 0 0} ...
                    ,{};...
    };                                         


                    
                    
 Modellliste.standard_modell = 1;



global DRT_Config 
DRT_Config.Schwingfaktor = 1;
DRT_Config.InterpolationsFaktor = 10;
DRT_Config.FilterFaktor_ext = 0.3;
DRT_Config.ZeroPadding = 20;
DRT_Config.PeakSensitivitaet = 0.3;
DRT_Config.Prozesse = 3;
DRT_Config.ZarcHN=1;






files = dir('ESBElemente/ESBe*.m');
for i = 1:numel(files)
    eval([files(i).name(1:end-2) ]);
end




files = dir('ersatzschaltbilder/ESB*.m');
for i = 1:numel(files)
    Modellliste.Modell = [Modellliste.Modell ; eval([files(i).name(1:end-2) '(Modellliste.Implementierung)'])];
end

end
