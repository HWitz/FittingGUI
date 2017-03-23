function [ ModellZeile ] = ESB_RL2RC1SphericalDiffusion(Implementierung)

%% Funktion zur Erstellung von Ersatzschaltbildern. 
% Bitte zuerst die schnellen Elemente, dann die Langsamen eintragen

Name = 'RL2RC1SphericalDiffusion';

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


% RC1  
Modell = Implementierung.RC_Tau;
Modell.Name = 'RC1';
Appendix = '_1';
HFMFLF = 'MF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 1;
%               R       Tau  
Startwerte = {  1e-3    1e-4  };
Minimum =    {  1e-7    1e-5   };
Maximum =    {  100     1e-2 };
Fix =        {  0       0   };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);



% % Zarc A 
% Modell = Implementierung.Zarc3RCTau;
% Modell.Name = 'Zarc_A';
% Appendix = '_A';
% HFMFLF = 'MF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
% Modell.Plot = 1;
% %               R_z     Tau_z   Phi_z 
% Startwerte = {  1e-3    1e-4    1       };
% Minimum = {     1e-7    1e-5    0.8     };
% Maximum = {     100     1e-2    1       };
% Fix = {         0       0       0       };
% ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);

% % Zarc B 
% Modell = Implementierung.Zarc3RCTau;
% Modell.Name = 'Zarc_B';
% Appendix = '_B';
% HFMFLF = 'MF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
% Modell.Plot = 1;
% %               R_z     Tau_z   Phi_z 
% Startwerte = {  1e-3    1e-4    1       };
% Minimum = {     1e-7    1e-5    0.8     };
% Maximum = {     100     1e-2    1       };
% Fix = {         0       0       0       };
% ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);
% 





Modell = Implementierung.DiffKugel;
Modell.Name = 'SphericalParticleDiffusion';
HFMFLF = 'LF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 0;
Modell.NewParName= { 'R_D_B' ,'Tau_D_B'};  
%               (R_D,    Tau_D     )
Startwerte = {    1e-3      100     };
Minimum = {       1e-7      10      };
Maximum = {       1        100      };
Fix = {           0         0        };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);




% 
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


% 
% % Ausgleichsprozesse
% Modell = Implementierung.RC_Tau;
% Modell.Name = 'RC_';
% Appendix = '_slow';
% HFMFLF = 'LF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
% Modell.Plot = 1;
% %               R       Tau  
% Startwerte = {  0    2000  };
% Minimum =    {  1e-7    500   };
% Maximum =    {  100     5000 };
% Fix =        {  1      1   };
% ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);



end

