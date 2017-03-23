Modellliste.Implementierung.Randles_HN1RC_DiffKugel.Funktionsname = 'Randles_HN1RC_DiffKugel';
Modellliste.Implementierung.Randles_HN1RC_DiffKugel.inputs = {'R_ct','Tau_dl','Phi_HN','R_D','Tau_D'};
Modellliste.Implementierung.Randles_HN1RC_DiffKugel.Zfun = ['Z_parallel((R_ct==0).*10^9+1./((Tau_dl./R_ct).*(1i.*w)), R_ct + ' ...
    '10* R_D .* tanh((1i.*w.*Tau_D*20).^0.5)./((1i.*w.*Tau_D*20).^0.5-tanh((1i.*w.*Tau_D*20).^0.5))' ')' ...
    '-R_ct./(1+1i.*w.*Tau_dl)'...
    '+' 'R_ct./(1+1i.*w.*Tau_dl).^Phi_HN'];
Modellliste.Implementierung.Randles_HN1RC_DiffKugel.Zfun_HF = '0';
Modellliste.Implementierung.Randles_HN1RC_DiffKugel.Zfun_MF = 'R_ct./(1+1i.*w.*Tau_dl).^Phi_HN';
Modellliste.Implementierung.Randles_HN1RC_DiffKugel.Zfun_LF = [Modellliste.Implementierung.Randles_HN1RC_DiffKugel.Zfun '-(' Modellliste.Implementierung.Randles_HN1RC_DiffKugel.Zfun_MF ')'];

