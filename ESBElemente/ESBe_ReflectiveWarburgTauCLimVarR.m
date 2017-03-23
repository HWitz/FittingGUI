

Modellliste.Implementierung.ReflectiveWarburgTauCLimVarR.Funktionsname = 'ReflectiveWarburgTauCLimVarR';
Modellliste.Implementierung.ReflectiveWarburgTauCLimVarR.inputs = {'Tau','CLim','k1','k2','k3'};
Modellliste.Implementierung.ReflectiveWarburgTauCLimVarR.Zfun = '2.*Tau.*k1./(CLim.*1.^2)./(1+1i.*w.*Tau)+2.*Tau.*k2./(CLim.*2.^2)./(1+1i.*w.*Tau./2^2)+2.*Tau.*k3./(CLim.*3.^2)./(1+1i.*w.*Tau./3^2)+2.*Tau.*k3./(CLim.*4.^2)./(1+1i.*w.*Tau./4^2)+2.*Tau.*k3./(CLim.*5.^2)./(1+1i.*w.*Tau./5^2)+2.*Tau.*k3./(CLim.*6.^2)./(1+1i.*w.*Tau./6^2)+2.*Tau.*k3./(CLim.*7.^2)./(1+1i.*w.*Tau./7^2)+2.*Tau.*k3./(CLim.*8.^2)./(1+1i.*w.*Tau./8^2)+1./(1i.*w.*CLim)';
Modellliste.Implementierung.ReflectiveWarburgTauCLimVarR.Zfun_HF = '0';
Modellliste.Implementierung.ReflectiveWarburgTauCLimVarR.Zfun_MF = '2.*Tau.*k1./(CLim.*1.^2)./(1+1i.*w.*Tau)';
Modellliste.Implementierung.ReflectiveWarburgTauCLimVarR.Zfun_LF = '2.*Tau.*k2./(CLim.*2.^2)./(1+1i.*w.*Tau./2^2)+2.*Tau.*k3./(CLim.*3.^2)./(1+1i.*w.*Tau./3^2)+2.*Tau.*k3./(CLim.*4.^2)./(1+1i.*w.*Tau./4^2)+2.*Tau.*k3./(CLim.*5.^2)./(1+1i.*w.*Tau./5^2)+2.*Tau.*k3./(CLim.*6.^2)./(1+1i.*w.*Tau./6^2)+2.*Tau.*k3./(CLim.*7.^2)./(1+1i.*w.*Tau./7^2)+2.*Tau.*k3./(CLim.*8.^2)./(1+1i.*w.*Tau./8^2)+1./(1i.*w.*CLim)';
