








Modellliste.Implementierung.Randles_Zarc3RC_CothTauCLim.Funktionsname = 'Randles_Zarc3RC_CothTauCLim';
Modellliste.Implementierung.Randles_Zarc3RC_CothTauCLim.inputs = {'R_z','Tau_z','Phi_z','Tau_w','CLim_w'};
Modellliste.Implementierung.Randles_Zarc3RC_CothTauCLim.Zfun = 'Z_parallel((R_z==0).*10^9+1./((Tau_z.^Phi_z./R_z).*(1i.*w).^Phi_z), R_z + Tau_w.*pi^2./CLim_w*coth(pi*(1i.*w.*Tau_w).^0.5)./(pi*(1i.*w.*Tau_w).^0.5))';
Modellliste.Implementierung.Randles_Zarc3RC_CothTauCLim.Zfun_HF = '0';
Modellliste.Implementierung.Randles_Zarc3RC_CothTauCLim.Zfun_MF = 'R_z./(1+(1i.*w.*Tau_z).^Phi_z)';
Modellliste.Implementierung.Randles_Zarc3RC_CothTauCLim.Zfun_LF = 'Z_parallel((R_z==0).*10^9+1./((Tau_z.^Phi_z./R_z).*(1i.*w).^Phi_z), R_z + Tau_w.*pi^2./CLim_w*coth(pi*(1i.*w.*Tau_w).^0.5)./(pi*(1i.*w.*Tau_w).^0.5))-R_z./(1+(1i.*w.*Tau_z).^Phi_z)';


