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

function [f, fft_imp, Cap, CompensatedVoltage, U_ges] = CreateTDM(Time, Current, Voltage, create_fft_boolean, fit_cap_in_timedomain)
% Author: Friedrich Hust
% strom = squeeze(Current(1:end-1));
% span  = squeeze(Voltage(2:end));
% zeit  = squeeze(Time(1:end-1));
zeit = Time;
strom = Current;
CompensatedVoltage = Voltage(1);
span = Voltage - CompensatedVoltage ;
Q = zeros(size(span));
dt = (zeit(2) - zeit(1));
for i = 2:length(Q)
    Q(i) = Q(i-1) + strom(i-1) * dt;
end
% figure(); plot(zeit, Q);
if ~fit_cap_in_timedomain
    Cap = (max(abs(Q)) / abs(span(end) - span(1)));
else
    FitIndex = find((Time(end)-Time)<3600);
    
    FitSpannung = Voltage(FitIndex);
    FitZeit = Time(FitIndex)-Time(FitIndex(1));
    
    p_init = [1000 FitSpannung(end) FitSpannung(1)-FitSpannung(end)];
    modelformel = 'p(2)+p(3).*exp(-w./p(1))';
    options = optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-12,'TolFun',1e-12);
    [p,fval,exitflag,output]=function_fit_easyfit2(FitZeit,[FitSpannung, zeros(size(FitSpannung))],p_init,@function_model_all_types2, [0 0 -inf ], [inf,inf,inf] ,options, modelformel);
    w = FitZeit;
    NeuSpannung = eval(modelformel);
    w = 1e19;
    EndSpannung = eval(modelformel);
%         figure;
%         plot(Time,Voltage)
%         grid on,hold on
%         plot(Time(FitIndex(1))+FitZeit,NeuSpannung,'r')
%         plot(Time,repmat(EndSpannung, size(Time)),'--k')
%         plot(Time,repmat(Voltage(1), size(Time)),'--k')
    
   
    Ladung = [0 cumsum(Current(1:end-1) .* diff(Time))];
    
    Cap=Ladung(end)/(EndSpannung-Voltage(1));
end

% Cap = 10000;
U_C = (Q) / Cap;
U_ges = span - U_C;
if create_fft_boolean
    fft_imp = fft(U_ges) ./ fft(strom);
    % fft_imp = fft(span ) ./ fft(strom);
    Fs = 1/(dt);
    NFFT = length(fft_imp);
    slength= floor(length(fft_imp) / 2)+1;
    f = [0 : slength]*Fs/NFFT ;
else
    f = 0;
    fft_imp= 0;
end

