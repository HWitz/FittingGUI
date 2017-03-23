
Modellliste.Implementierung.ReflectiveWarburgMinusCLim.Funktionsname = 'ReflectiveWarburgMinusCLim';
Modellliste.Implementierung.ReflectiveWarburgMinusCLim.inputs = {'R','Tau'};
Modellliste.Implementierung.ReflectiveWarburgMinusCLim.Zfun = 'R*pi^2/2*coth(pi*(1i.*w.*Tau).^0.5)./(pi*(1i.*w.*Tau).^0.5)-1./(1i*w*(2*Tau/R))';
Modellliste.Implementierung.ReflectiveWarburgMinusCLim.Zfun_HF = '0';
Modellliste.Implementierung.ReflectiveWarburgMinusCLim.Zfun_MF = '0';
Modellliste.Implementierung.ReflectiveWarburgMinusCLim.Zfun_LF = 'R*pi^2/2*coth(pi*(1i.*w.*Tau).^0.5)./(pi*(1i.*w.*Tau).^0.5)-1./(1i*w*(2*Tau/R))';

