function [ ModellZeile ] = ESB_1HFRC2Zarc1LFRC1ReflWarburg(Implementierung)

%% Funktion zur Erstellung von Ersatzschaltbildern. 
% Bitte zuerst die schnellen Elemente, dann die Langsamen eintragen

Name = '1HFRC2Zarc1LFRC1ReflWarburg';

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



% Deckschicht ? Hochfrequentes RC-Glied
Modell = Implementierung.RC_Tau;
Modell.Name = 'RC1';
Appendix = '1';
HFMFLF = 'HF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 1;
%               R       Tau  
Startwerte = {  1e-3    8e-5  };
Minimum =    {  1e-8    1e-10   };
Maximum =    {  100     9e-4 };
Fix =        {  0       0   };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);


% Zarc A 
Modell = Implementierung.Zarc3RCTau;
Modell.Name = 'Zarc_A';
Appendix = '_A';
HFMFLF = 'MF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 1;
%               R_z     Tau_z   Phi_z 
Startwerte = {  1e-3    1e-4    1       };
Minimum = {     1e-7    1e-5    0.8     };
Maximum = {     100     1e-2    1       };
Fix = {         0       0       0       };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);

% Zarc B 
Modell = Implementierung.Zarc3RCTau;
Modell.Name = 'Zarc_B';
Appendix = '_B';
HFMFLF = 'MF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 1;
%               R_z     Tau_z   Phi_z 
Startwerte = {  1e-3    1e-4    1       };
Minimum = {     1e-7    1e-5    0.8     };
Maximum = {     100     1e-2    1       };
Fix = {         0       0       0       };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);

% Reflective Warburg 
Modell = Implementierung.ReflectiveWarburgTauCLim;
Modell.Name = 'Reflective_Warburg';
Appendix = '_W';
HFMFLF = 'LF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 1;
%               Tau_w   CLim_w
Startwerte = {  100     1e8};
Minimum = {     10      1};
Maximum = {     1000    1e10};
Fix = {         0       0};
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);

% Poröse Elektrode
Modell = Implementierung.RC_Tau;
Modell.Name = 'RC_PorousElectrode';
Appendix = 'por';
HFMFLF = 'LF' ; % entweder 'Auto' oder 'HF' oder 'MF' oder 'LF'
Modell.Plot = 1;
%               R       Tau  
Startwerte = {  1e-3    40  };
Minimum =    {  1e-7    1   };
Maximum =    {  100     150 };
Fix =        {  0       0   };
ModellZeile = AddESBElement(ModellZeile,Modell,Appendix,HFMFLF,Startwerte,Minimum,Maximum,Fix);


end

