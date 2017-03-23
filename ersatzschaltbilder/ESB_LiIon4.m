function [ ModellZeile ] = ESB_LiIon4(Implementierung)

%% Funktion zur Erstellung von Ersatzschaltbildern. 
% Bitte zuerst die schnellen Elemente, dann die Langsamen eintragen

Name = 'LiIon4';

ModellZeile={Name,'','',{},{},{},{},{}};

%Rser 
Modell = Implementierung.Rser;
Modell.Name = 'Rser';
Appendix = 'ser';
HFMFLF = 'HF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 0;
Startwerte = {  1e-3    };
Minimum = {     1e-7    };
Maximum = {     100     };
Fix = {         0       };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);

%RL-Glied mit CPE statt L 
Modell = Implementierung.RL_CPE;
Modell.Name = 'RL_CPE';
Appendix = 'ind';
HFMFLF = 'HF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 1;
%               R       L       Phi
Startwerte = {  1e-3    1e-8    1   };
Minimum = {     0       0       0   };
Maximum = {     100     inf     1   };
Fix = {         0       0       0   };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);




% Elektrische Anbindung oder Deckschicht Anode
% Modell = Implementierung.RC_Tau;
% Modell.Name = 'RC_';
% Appendix = '_fast';
% HFMFLF = 'HF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
% Modell.Plot = 1;
% %               R       Tau  
% Startwerte = {  0    1e-4  };
% Minimum =    {  1e-7    1e-7   };
% Maximum =    {  100     9e-4 };
% Fix =        {  1      1   };
% ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);
% 



% Reaktion Anode 
Modell = Implementierung.RMP_HN1RC;
Modell.Name = 'Negative Elektrode';
Modell.NewParName= { 'R_ct_A' , 'Tau_dl_A' , 'Phi_HN_A' ,'RMP'};  
HFMFLF = 'Auto' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 1;
%               R       Tau     Phi   RMP
Startwerte = {  1e-3    1e-4    1      1e-3 };
Minimum = {     1e-7    1e-5    0.5    1e-7 };
Maximum = {     100     1e-2    1      100};
Fix = {         0       0       1      0 };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);

% Diffusion Anode 
% Modell = Implementierung.DiffKugelschaleReflekt;
% Modell.Name = 'Diffusion_neg';
% Appendix = 'D_neg';
% HFMFLF = 'LF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
% Modell.Plot = 1;
%               R       Tau     Phi   
% Startwerte = {  1e-3    1e-4    1       };
% Minimum = {     1e-7    1e-5    0.8     };
% Maximum = {     100     1e-2    1       };
% Fix = {         0       0       0       };
% ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);


% Positive Elektrode
Modell = Implementierung.RMP_HN1RC_DiffKugel;
Modell.Name = 'PositiveElektrode';
HFMFLF = 'Auto' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 1;
Modell.NewParName= { 'R_ct_B' , 'Tau_dl_B' , 'Phi_HN_B' , 'R_D_B' ,'Tau_D_B','RMP'};  
%               (R_ct, Tau_dl,Phi_HN,  R_D,    Tau_D     RMP)
Startwerte = {  1e-3    1e-2    1      1e-3      100     1e-3};
Minimum = {     1e-7    1e-5    0.5    1e-7      10      1e-7 };
Maximum = {     100     1e-1    1      100       1500    100};
Fix = {         0       0       1      0         0        0};
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);

Modell = Implementierung.DiffKugelAbziehen;
Modell.Name = 'PositiveElektrodeKugelAbziehen';
HFMFLF = 'Auto' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 0;
Modell.NewParName= { 'R_D_B' ,'Tau_D_B'};  
%               (R_D,    Tau_D     )
Startwerte = {    1e-3      100     };
Minimum = {       1e-7      10      };
Maximum = {       1        100      };
Fix = {           0         0        };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);

Modell = Implementierung.DiffKugel;
Modell.Name = 'PositiveElektrodeKugelDiffusion';
HFMFLF = 'Auto' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 0;
Modell.NewParName= { 'R_D_B' ,'Tau_D_B'};  
%               (R_D,    Tau_D     )
Startwerte = {    1e-3      100     };
Minimum = {       1e-7      10      };
Maximum = {       1        100      };
Fix = {           0         0        };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);





% Poröse Elektrode -> Elektrolytdiffusion
Modell = Implementierung.RC_Tau;
Modell.Name = 'RC_PorousElectrode_ElectrolyteDiffusion';
Appendix = '_DP';
HFMFLF = 'LF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 1;
%               R       Tau  
Startwerte = {  1e-3    40  };
Minimum =    {  1e-7    1   };
Maximum =    {  100     150 };
Fix =        {  0       0   };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);



% Ausgleichsprozesse
Modell = Implementierung.RC_Tau;
Modell.Name = 'RC_';
Appendix = '_slow';
HFMFLF = 'LF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 1;
%               R       Tau  
Startwerte = {  0    2000  };
Minimum =    {  1e-7    500   };
Maximum =    {  100     5000 };
Fix =        {  1      1   };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);



end

