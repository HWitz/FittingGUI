

Modellliste.Implementierung.DiffKugelschaleReflekt.Funktionsname = 'DiffKugelschaleReflekt';
Modellliste.Implementierung.DiffKugelschaleReflekt.inputs = {'R','Tau','alpha'};
Modellliste.Implementierung.DiffKugelschaleReflekt.Zfun = ...
'10*R*(-1)*alpha*((1i*w*Tau*20)^Phi)-tanh((alpha-1)*(1i*w*Tau*20)^Phi))/((alpha-1)*(1i*w*Tau*20)^Phi+(alpha*1i*w*Tau*20-1)*tanh((alpha-1)*(1i*w*Tau*20)^Phi))';
Modellliste.Implementierung.DiffKugelschaleReflekt.Zfun_HF = '0';
Modellliste.Implementierung.DiffKugelschaleReflekt.Zfun_MF = '0';
Modellliste.Implementierung.DiffKugelschaleReflekt.Zfun_LF = ...
'10*R*(-1)*alpha*((1i*w*Tau*20)^Phi)-tanh((alpha-1)*(1i*w*Tau*20)^Phi))/((alpha-1)*(1i*w*Tau*20)^Phi+(alpha*1i*w*Tau*20-1)*tanh((alpha-1)*(1i*w*Tau*20)^Phi))';

