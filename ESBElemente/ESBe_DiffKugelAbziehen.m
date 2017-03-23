


Modellliste.Implementierung.DiffKugelAbziehen.Funktionsname = 'DiffKugelAbziehen';
Modellliste.Implementierung.DiffKugelAbziehen.inputs = {'R','Tau'};
Modellliste.Implementierung.DiffKugelAbziehen.Zfun = '-10* R .* tanh((1i.*w.*Tau*20).^0.5)./((1i.*w.*Tau*20).^0.5-tanh((1i.*w.*Tau*20).^0.5))';
Modellliste.Implementierung.DiffKugelAbziehen.Zfun_HF = '0';
Modellliste.Implementierung.DiffKugelAbziehen.Zfun_MF = '0';
Modellliste.Implementierung.DiffKugelAbziehen.Zfun_LF = '-10* R .* tanh((1i.*w.*Tau*20).^0.5)./((1i.*w.*Tau*20).^0.5-tanh((1i.*w.*Tau*20).^0.5))';
