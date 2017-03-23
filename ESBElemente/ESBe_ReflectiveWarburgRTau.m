


Modellliste.Implementierung.ReflectiveWarburgRTau.Funktionsname = 'ReflectiveWarburgRTau';
Modellliste.Implementierung.ReflectiveWarburgRTau.inputs = {'R','Tau'};
Modellliste.Implementierung.ReflectiveWarburgRTau.Z = @(R,Tau,w)(R.*pi^2/2*coth(pi*(1i.*w.*Tau).^0.5)./(pi*(1i.*w.*Tau).^0.5));
Modellliste.Implementierung.ReflectiveWarburgRTau.Z_HF = @(R,Tau,w)(0);
Modellliste.Implementierung.ReflectiveWarburgRTau.Z_MF = @(R,Tau,w)(0);
Modellliste.Implementierung.ReflectiveWarburgRTau.Z_LF = @(R,Tau,w)(R.*pi^2/2*coth(pi*(1i.*w.*Tau).^0.5)./(pi*(1i.*w.*Tau).^0.5));
Modellliste.Implementierung.ReflectiveWarburgRTau.Zfun = 'R.*pi^2/2*coth(pi*(1i.*w.*Tau).^0.5)./(pi*(1i.*w.*Tau).^0.5)';
Modellliste.Implementierung.ReflectiveWarburgRTau.Zfun_HF = '0';
Modellliste.Implementierung.ReflectiveWarburgRTau.Zfun_MF = '0';
Modellliste.Implementierung.ReflectiveWarburgRTau.Zfun_LF = 'R.*pi^2/2*coth(pi*(1i.*w.*Tau).^0.5)./(pi*(1i.*w.*Tau).^0.5)';
