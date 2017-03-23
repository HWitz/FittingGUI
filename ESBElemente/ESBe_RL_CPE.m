


Modellliste.Implementierung.RL_CPE.Funktionsname = 'RL_CPE';
Modellliste.Implementierung.RL_CPE.inputs = {'R','L','Phi'};
Modellliste.Implementierung.RL_CPE.Zfun = 'R./(1+R./((1i.*w).^Phi.*L))';
Modellliste.Implementierung.RL_CPE.Zfun_HF = 'R./(1+R./((1i.*w).^Phi.*L))';
Modellliste.Implementierung.RL_CPE.Zfun_MF = '0';
Modellliste.Implementierung.RL_CPE.Zfun_LF = '0';