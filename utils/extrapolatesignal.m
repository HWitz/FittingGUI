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

function [exp_freq, exp_Z]= extrapolatesignal(freq, Z, factor)
% Author: Friedrich Hust
% Entstanden Diplomarbeit 2013 
% W:\Intern\DASA_BAMA\2013\hwi-fhu_DRT-Modell\papierform
log_freq = log10(freq);
exp_log_freq = log_freq ;
boundDiff = 10^-6;
if sign(Z(end)) ~= 1
    while true
        Diff_real= real(Z(end))-real(Z(end-1));
        Diff_imag= imag(Z(end))-imag(Z(end-1));
        if Diff_imag <0 , Diff_imag = -Diff_imag; end
        log_Diff_end= exp_log_freq(end) -  exp_log_freq(end-1);
        exp_log_freq =[exp_log_freq; exp_log_freq(end) + log_Diff_end];
        Z = [Z; real(Z(end))+Diff_real + 1j *(imag(Z(end)) + Diff_imag)];
        if sign(imag(Z(end))) == 1 || abs(Diff_imag) <boundDiff
            Z(end) = real(Z(end)) + 1j * 0;
            break;
        end
    end
end

if sign(Z(1)) ~= 1
    while true
        Diff_real= real((Z(1)))-real((Z(2)));
        Diff_imag= imag((Z(1)))-imag((Z(2)));
        if Diff_imag <0 , Diff_imag = -Diff_imag; end
        if Diff_real >0 , Diff_real = -Diff_real; end
        
        log_Diff_start= exp_log_freq(1) - exp_log_freq(2);
        
        exp_log_freq =[exp_log_freq(1) + log_Diff_start; exp_log_freq ];
        Z = [ (real(Z(1)) +Diff_real+ 1j * ((imag(Z(1)) + Diff_imag))); Z];
        if sign(imag(Z(1))) == 1 || abs(Diff_imag)<boundDiff
            Z(1) = real(Z(1)) + 1j * 0;
            break;
        end
    end
end
Z = [ones(factor(1) ,1) .* Z(1); Z; ones(factor(2), 1 ) .* Z(end)];
start = linspace(exp_log_freq(1)+log_Diff_start*factor(1), exp_log_freq(1)+log_Diff_start, factor(1)); %log_freq= 
endor = linspace(exp_log_freq(end)+log_Diff_end,exp_log_freq(end)+log_Diff_end*factor(2) , factor(2)); 
exp_log_freq = [start';exp_log_freq;endor'];
exp_Z = Z;
exp_freq = power(10, exp_log_freq);
