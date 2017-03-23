% % MIT License
% % 
% % Copyright (c) 2016 ISEA, Heiko Witzenhausen
% % 
% % Permission is hereby granted, free of charge, to any person obtaining a copy
% % of this software and associated documentation files (the "Software"), to deal
% % in the Software without restriction, including without limitation the rights
% % to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% % copies of the Software, and to permit persons to whom the Software is
% % furnished to do so, subject to the following conditions:
% % 
% % The above copyright notice and this permission notice shall be included in all
% % copies or substantial portions of the Software. The Text "Developed by ISEA @ RWTH Aachen" 
% % may not be removed from the graphical user interface.
% % 
% % THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% % IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% % FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% % AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% % LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% % OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% % SOFTWARE.
% % 

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = RunLocalESBeFunction(Funktionsname,varargin)
    LokaleFunktionen = localfunctions;
    gefunden=false;
    for i = 1:numel(LokaleFunktionen)
        if strcmp(Funktionsname,func2str(LokaleFunktionen{i}))
           gefunden=true;
           [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] =LokaleFunktionen{i}(varargin{:});
           break
        end
    end
    if ~gefunden,
        R_RC=[];
        C_RC=[];
        C_ser=[];
        R_ser=[];
        R_Ladder=[];
        C_Ladder=[];
    end
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = DiffKugelschaleReflekt(R,Tau,alpha)
    C_RC = [];
    R_RC = [];
    C_ser = [];
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = DiffKugelAbziehen(R,Tau)
    Faktor_R =   [0.991746408883833 0.335189554500520 0.172209582896012 0.0990088488847815 0.0894316108842422 0.0628533575690239 0.0433650998346649 0.0409465516111291 0.0359600164087731 0.0257087018345930 0.0206062060663296 0.0163927855682163 0.0133393793597222 0.00963063557519788 0.0105619640377753 0.00625486628390168 0.00466427366388678 0.00489302085372321 0.00377038387403826 0.00272828796945697 0.00220461281834244 0.00172611255496559 0.00122500955193401 0.00100641130984464 0.000988915520199850 0.000990703772136943 0.00101843891449268 0.00109746077161406 0.00134411783912767];
    Faktor_Tau = [0.991451359646436 0.335870153447181 0.167579701571178 0.0979200017777679 0.0616838415192040 0.0396617079878360 0.0257407628044021 0.0166771337841095 0.0106849233907334 0.00681822631765891 0.00435433073209765 0.00278113078679821 0.00177898142175253 0.00113938740056861 0.000731596152250355 0.000467596673254973 0.000300414861021452 0.000192385090821147 0.000122045399317404 7.75570733968097e-05 4.97188886786378e-05 3.21196950002819e-05 2.08531377797455e-05 1.35775500596413e-05 8.84548015906210e-06 5.76662104649152e-06 3.76592279815960e-06 2.46389055469806e-06 1.61518180144545e-06];
    R_RC = -R*Faktor_R;
    Tau_RC = Tau*Faktor_Tau;
    C_RC = Tau_RC./R_RC;
    C_ser = -Tau/R*2/3;
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = DiffKugel(R,Tau)
    Faktor_R =   [0.991746408883833 0.335189554500520 0.172209582896012 0.0990088488847815 0.0894316108842422 0.0628533575690239 0.0433650998346649 0.0409465516111291 0.0359600164087731 0.0257087018345930 0.0206062060663296 0.0163927855682163 0.0133393793597222 0.00963063557519788 0.0105619640377753 0.00625486628390168 0.00466427366388678 0.00489302085372321 0.00377038387403826 0.00272828796945697 0.00220461281834244 0.00172611255496559 0.00122500955193401 0.00100641130984464 0.000988915520199850 0.000990703772136943 0.00101843891449268 0.00109746077161406 0.00134411783912767];
    Faktor_Tau = [0.991451359646436 0.335870153447181 0.167579701571178 0.0979200017777679 0.0616838415192040 0.0396617079878360 0.0257407628044021 0.0166771337841095 0.0106849233907334 0.00681822631765891 0.00435433073209765 0.00278113078679821 0.00177898142175253 0.00113938740056861 0.000731596152250355 0.000467596673254973 0.000300414861021452 0.000192385090821147 0.000122045399317404 7.75570733968097e-05 4.97188886786378e-05 3.21196950002819e-05 2.08531377797455e-05 1.35775500596413e-05 8.84548015906210e-06 5.76662104649152e-06 3.76592279815960e-06 2.46389055469806e-06 1.61518180144545e-06];
    R_RC = R*Faktor_R;
    Tau_RC = Tau*Faktor_Tau;
    C_RC = Tau_RC./R_RC;
    C_ser = Tau/R*2/3;
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = Randles_Zarc3RC_CothTauCLim(R_z,Tau_z,Phi_z,Tau_w,CLim_w)
    phi_vec =[ 0.4         0.5         0.6         0.7         0.8         0.9        0.92        0.94        0.96        0.98           1 ];
    Tau_Faktor_vec = [ 39.9742      21.8364      13.6186      9.23106      6.58365      4.83194       4.5502      4.28597      4.03746      3.80306      3.58133 ];
    R_Faktor_aussen_vec = [ 0.28084     0.26535      0.2446     0.21576     0.17431     0.11057    0.093487    0.074352     0.05276    0.028198           0 ];
    R_Faktor_innen_vec = [ 0.39633     0.44284     0.49461     0.55903     0.64641     0.77687      0.8115      0.8502     0.89378     0.94327           1 ];
    Tau_Faktor = interp1(phi_vec,Tau_Faktor_vec,Phi_z);
    R_Faktor_aussen = interp1(phi_vec,R_Faktor_aussen_vec,Phi_z);
    R_Faktor_innen = interp1(phi_vec,R_Faktor_innen_vec,Phi_z);
    Tau_RC = Tau_z * [1./Tau_Faktor 1 Tau_Faktor];
    R_RC = R_z .* [R_Faktor_aussen R_Faktor_innen R_Faktor_aussen];
    C_RC = Tau_RC ./ R_RC;
    n = 1:20;
    C_RC = [C_RC ones(size(n)).*CLim_w./2];
    R_RC = [R_RC 2.*Tau_w./(CLim_w.*n.^2)];
    C_ser = CLim_w;
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end


function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = FiniteLengthWarburgRTau(R,Tau)
    n = 1:20;
    C_RC = ones(size(n)).*Tau./R;
    R_RC = R./(2.*n-1).^2;
    C_ser = [];
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end


function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = HN1RC(R,Tau,Phi)
    Tau_RC = Tau ;
    R_RC = R ;
    C_RC = Tau_RC ./ R_RC;
    C_ser = [];   
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end


function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = InvCser(C)
    C_RC = [];
    R_RC = [];
    C_ser = -C;
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end


function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = OCV_source(C_OCV)
    C_RC = [];
    R_RC = [];
    C_ser = C_OCV;
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = Randles_HN1RC_DiffKugel(R_ct,Tau_dl,Phi_HN,R_D,Tau_D)
    [R_RC_HN, C_RC_HN, C_ser, R_ser, R_Ladder , C_Ladder] = HN1RC(R_ct,Tau_dl,Phi_HN);
    [R_RC_D, C_RC_D, C_ser, R_ser, R_Ladder , C_Ladder] = DiffKugel(R_D,Tau_D);
    C_RC = [C_RC_HN C_RC_D];
    R_RC = [R_RC_HN R_RC_D];
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = Randles_Zarc3RC_CothTauCLim_RCWMF(R_z,Tau_z,Phi_z,Tau_w,CLim_w)
    phi_vec =[ 0.4         0.5         0.6         0.7         0.8         0.9        0.92        0.94        0.96        0.98           1 ];
    Tau_Faktor_vec = [ 39.9742      21.8364      13.6186      9.23106      6.58365      4.83194       4.5502      4.28597      4.03746      3.80306      3.58133 ];
    R_Faktor_aussen_vec = [ 0.28084     0.26535      0.2446     0.21576     0.17431     0.11057    0.093487    0.074352     0.05276    0.028198           0 ];
    R_Faktor_innen_vec = [ 0.39633     0.44284     0.49461     0.55903     0.64641     0.77687      0.8115      0.8502     0.89378     0.94327           1 ];
    Tau_Faktor = interp1(phi_vec,Tau_Faktor_vec,Phi_z);
    R_Faktor_aussen = interp1(phi_vec,R_Faktor_aussen_vec,Phi_z);
    R_Faktor_innen = interp1(phi_vec,R_Faktor_innen_vec,Phi_z);
    Tau_RC = Tau_z * [1./Tau_Faktor 1 Tau_Faktor];
    R_RC = R_z .* [R_Faktor_aussen R_Faktor_innen R_Faktor_aussen];
    C_RC = Tau_RC ./ R_RC;
    n = 1:20;
    C_RC = [C_RC ones(size(n)).*CLim_w./2];
    R_RC = [R_RC 2.*Tau_w./(CLim_w.*n.^2)];
    C_ser = CLim_w;
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = RC(R,C)
    R_RC = R ;
    C_RC = C ;
    C_ser = [];   
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = ReflectiveWarburgMinusCLim(R,Tau)
    n = 1:20;
    C_RC = ones(size(n)).*Tau/R;
    R_RC = R./n.^2;
    C_ser = [];
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end
function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = RC_Tau(R,Tau)
    R_RC = R ;
    C_RC = Tau ./ R;
    C_ser = [];   
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = Rser(R)
    C_RC = [];
    R_RC = [];
    C_ser = [];
    R_ser = R;
    R_Ladder = [];   
    C_Ladder = [];
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = ReflectiveWarburgSigmaCLim(Sigma,CLim)
    n = 1:20;
    C_RC = ones(size(n)).*CLim./2;
    R_RC = 4.*(CLim.*Sigma.^2)./(n.*pi).^2;
    C_ser = CLim;
    R_ser = [];
    R_Ladder = ones(size(n)) .* Sigma.^2 .* 2 .* CLim ./ n(end-1);   
    C_Ladder = ones(size(n)) .* CLim ./ n(end);
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = ReflectiveWarburgRTau(R,Tau)
    n = 1:20;
    C_RC = ones(size(n)).*Tau/R;
    R_RC = R./n.^2;
    C_ser = 2*Tau./R;
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end




function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = ReflectiveWarburgTauCLim(Tau,CLim)
    n = 1:20;
    C_RC = ones(size(n)).*CLim./2;
    R_RC = 2.*Tau./(CLim.*n.^2);
    C_ser = CLim;
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end
function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = ReflectiveWarburgTauCLim_RCWMF(Tau,CLim)
    n = 1:20;
    C_RC = ones(size(n)).*CLim./2;
    R_RC = 2.*Tau./(CLim.*n.^2);
    C_ser = CLim;
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end




function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = ReflectiveWarburgTauCLimVarR(Tau,CLim,k1,k2,k3)
    n = 1:20;
    k = [k1, k2 , k3 , k3*ones(1,numel(n)-3)];
    C_RC = ones(size(n)).*CLim./2;
    R_RC = 2.*Tau.*k./(CLim.*n.^2);
    C_ser = CLim;
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end


function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = RL(R,L)
    R_RC = [] ;
    C_RC = [] ;
    C_ser = [];   
    R_ser = [R];
    R_Ladder = [];   
    C_Ladder = [];
end


function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = RL_CPE(R,L,Phi)
    R_RC = [] ;
    C_RC = [] ;
    C_ser = [];   
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end


function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = RMP_2HN1RC(R_ct1,Tau_dl1,R_ct2,Tau_dl2,Phi_HN2,R_MP)
    [R_RC_HN, C_RC_HN, C_ser, R_ser, R_Ladder , C_Ladder] = HN1RC(R_ct2,Tau_dl2,Phi_HN2);
    C_RC = [C_RC_HN ];
    R_RC = [R_RC_HN ];
    w=0;
    if isempty(R_ser),R_ser=0;end
    R_ser = R_ser+real((R_MP.*(R_ct1./(1+1i.*w.*Tau_dl1)+R_ct2./(1+1i.*w.*Tau_dl2).^Phi_HN2)).^0.5 ...
    .*coth((R_MP./(R_ct1./(1+1i.*w.*Tau_dl1)+R_ct2./(1+1i.*w.*Tau_dl2).^Phi_HN2)).^0.5)...
    -R_ct2);
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = RMP_HN1RC(R_ct,Tau_dl,Phi_HN,R_MP)
    [R_RC_HN, C_RC_HN, C_ser, R_ser, R_Ladder , C_Ladder] = HN1RC(R_ct,Tau_dl,Phi_HN);
    C_RC = [C_RC_HN ];
    R_RC = [R_RC_HN ];
    w=0;
    if isempty(R_ser),R_ser=0;end
    R_ser = R_ser+real((R_MP.*(R_ct./(1+1i.*w.*Tau_dl).^Phi_HN)).^0.5 ...
    .*coth((R_MP./(R_ct./(1+1i.*w.*Tau_dl).^Phi_HN)).^0.5)...
    -R_ct);
end







function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = RMP_HN1RC_DiffKugel(R_ct,Tau_dl,Phi_HN,R_D,Tau_D,R_MP)
    [R_RC_HN, C_RC_HN, C_ser, R_ser, R_Ladder , C_Ladder] = HN1RC(R_ct,Tau_dl,Phi_HN);
    [R_RC_D, C_RC_D, C_ser, R_ser, R_Ladder , C_Ladder] = DiffKugel(R_D,Tau_D);
    C_RC = [C_RC_HN C_RC_D];
    R_RC = [R_RC_HN R_RC_D];
    w=0;
    if isempty(R_ser),R_ser=0;end
    R_ser = R_ser+real((R_MP.*(R_ct./(1+1i.*w.*Tau_dl).^Phi_HN)).^0.5 ...
    .*coth((R_MP./(R_ct./(1+1i.*w.*Tau_dl).^Phi_HN)).^0.5)...
    -R_ct);
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = TwoElectrodes(R_ct_A,Tau_dl_A,Phi_HN_A,R_ct_B,Tau_dl_B,Phi_HN_B,R_D_B,Tau_D_B,R_MP)
    [R_RC_A, C_RC_A, C_ser_A, R_ser_A, R_Ladder_A , C_Ladder_A] = RMP_HN1RC(R_ct_A,Tau_dl_A,Phi_HN_A,R_MP);
    [R_RC_B, C_RC_B, C_ser_B, R_ser_B, R_Ladder_B , C_Ladder_B] = RMP_HN1RC_DiffKugel(R_ct_B,Tau_dl_B,Phi_HN_B,R_D_B,Tau_D_B,R_MP);
    C_RC = [C_RC_A C_RC_B ];
    R_RC = [R_RC_A R_RC_B ];
    R_ser = R_ser_A+R_ser_B;
    
    if isempty(C_ser_A) && isempty(C_ser_B), 
        C_ser=[];
    elseif isempty(C_ser_A),
        C_ser=C_ser_B;
    elseif isempty(C_ser_B),
        C_ser=C_ser_A;
    end
    R_Ladder = [R_Ladder_A R_Ladder_B];
    C_Ladder = [C_Ladder_A C_Ladder_B];
    
        
    
end

function [R_RC, C_RC, C_ser, R_ser, R_Ladder , C_Ladder] = Zarc3RCTau(R,Tau,Phi)
    phi_vec =[ 0.4         0.5         0.6         0.7         0.8         0.9        0.92        0.94        0.96        0.98           1 ];
    Tau_Faktor_vec = [ 39.9742      21.8364      13.6186      9.23106      6.58365      4.83194       4.5502      4.28597      4.03746      3.80306      3.58133 ];
    R_Faktor_aussen_vec = [ 0.28084     0.26535      0.2446     0.21576     0.17431     0.11057    0.093487    0.074352     0.05276    0.028198           0 ];
    R_Faktor_innen_vec = [ 0.39633     0.44284     0.49461     0.55903     0.64641     0.77687      0.8115      0.8502     0.89378     0.94327           1 ];
    Tau_Faktor = interp1(phi_vec,Tau_Faktor_vec,Phi);
    R_Faktor_aussen = interp1(phi_vec,R_Faktor_aussen_vec,Phi);
    R_Faktor_innen = interp1(phi_vec,R_Faktor_innen_vec,Phi);
    Tau_RC = Tau * [1./Tau_Faktor 1 Tau_Faktor];
    R_RC = R .* [R_Faktor_aussen R_Faktor_innen R_Faktor_aussen];
    C_RC = Tau_RC ./ R_RC;
    C_ser = [];   
    R_ser = [];
    R_Ladder = [];   
    C_Ladder = [];
end

