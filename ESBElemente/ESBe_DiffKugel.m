


Modellliste.Implementierung.DiffKugel.Funktionsname = 'DiffKugel';
Modellliste.Implementierung.DiffKugel.inputs = {'R','Tau'};
Modellliste.Implementierung.DiffKugel.Zfun = '10* R .* tanh((1i.*w.*Tau*20).^0.5)./((1i.*w.*Tau*20).^0.5-tanh((1i.*w.*Tau*20).^0.5))';
Modellliste.Implementierung.DiffKugel.Zfun_HF = '0';
Modellliste.Implementierung.DiffKugel.Zfun_MF = '0';
Modellliste.Implementierung.DiffKugel.Zfun_LF = '10* R .* tanh((1i.*w.*Tau*20).^0.5)./((1i.*w.*Tau*20).^0.5-tanh((1i.*w.*Tau*20).^0.5))';
