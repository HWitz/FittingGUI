


Modellliste.Implementierung.ReflectiveWarburgSigmaCLim.Funktionsname = 'ReflectiveWarburgSigmaCLim';
Modellliste.Implementierung.ReflectiveWarburgSigmaCLim.inputs = {'Sigma','CLim'};
Modellliste.Implementierung.ReflectiveWarburgSigmaCLim.Zfun = 'Sigma ./ w.^0.5 .* (1-1i) .* coth((2.*1i.*w).^0.5.*CLim.*Sigma)';
Modellliste.Implementierung.ReflectiveWarburgSigmaCLim.Zfun_HF = '0';
Modellliste.Implementierung.ReflectiveWarburgSigmaCLim.Zfun_MF = '0';
Modellliste.Implementierung.ReflectiveWarburgSigmaCLim.Zfun_LF = 'Sigma ./ w.^0.5 .* (1-1i) .* coth((2.*1i.*w).^0.5.*CLim.*Sigma)';

