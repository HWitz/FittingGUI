

Modellliste.Implementierung.ReflectiveWarburgTauCLim_RCWMF.Funktionsname = 'ReflectiveWarburgTauCLim_RCWMF';
Modellliste.Implementierung.ReflectiveWarburgTauCLim_RCWMF.inputs = {'Tau','CLim'};
Modellliste.Implementierung.ReflectiveWarburgTauCLim_RCWMF.Zfun = 'Tau.*pi^2./CLim.*coth(pi*(1i.*w.*Tau).^0.5)./(pi*(1i.*w.*Tau).^0.5)';
Modellliste.Implementierung.ReflectiveWarburgTauCLim_RCWMF.Zfun_HF = '0';
Modellliste.Implementierung.ReflectiveWarburgTauCLim_RCWMF.Zfun_MF = '2.*Tau./(CLim)./(1+1i.*w.*Tau)';
Modellliste.Implementierung.ReflectiveWarburgTauCLim_RCWMF.Zfun_LF = 'Tau.*pi^2./CLim.*coth(pi*(1i.*w.*Tau).^0.5)./(pi*(1i.*w.*Tau).^0.5)-2.*Tau./(CLim)./(1+1i.*w.*Tau)';

