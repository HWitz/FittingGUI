


Modellliste.Implementierung.ReflectiveWarburgTauCLim.Funktionsname = 'ReflectiveWarburgTauCLim';
Modellliste.Implementierung.ReflectiveWarburgTauCLim.inputs = {'Tau','CLim'};
Modellliste.Implementierung.ReflectiveWarburgTauCLim.Zfun = 'Tau.*pi^2./CLim.*coth(pi*(1i.*w.*Tau).^0.5)./(pi*(1i.*w.*Tau).^0.5)';
Modellliste.Implementierung.ReflectiveWarburgTauCLim.Zfun_HF = '0';
Modellliste.Implementierung.ReflectiveWarburgTauCLim.Zfun_MF = '0';
Modellliste.Implementierung.ReflectiveWarburgTauCLim.Zfun_LF = 'Tau.*pi^2./CLim.*coth(pi*(1i.*w.*Tau).^0.5)./(pi*(1i.*w.*Tau).^0.5)';
