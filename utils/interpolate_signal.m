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

function [ interpolated_frequency,interpolated_signal ] = interpolate_signal( FactorC,signal,frequency)
% Author: Friedrich Hust
% Entstanden Diplomarbeit 2013 
% W:\Intern\DASA_BAMA\2013\hwi-fhu_DRT-Modell\papierform
    freqlog10 = log10(frequency);
    interpolated_length = (numel(signal)-1) * FactorC +1;
    interpolated_signal = zeros(1,interpolated_length);
    interpolated_frequency = zeros(1,interpolated_length);
    for i = 1:numel(signal)
        interpolated_signal(1+(i-1)*FactorC) = signal(i) *FactorC;
        if i == numel(signal)
            interpolated_frequency(end) = 10.^freqlog10(end);
        else
            freqs = linspace(freqlog10(i),freqlog10(i+1),FactorC+1);
            interpolated_frequency(1+(i-1)*FactorC:i*FactorC)= 10.^freqs(1:end-1);
        end
        
    end
    fft_signal = fft(interpolated_signal);
    fft_signal(ceil(numel(signal)/2):end-ceil(numel(signal)/2)) = 0;
    interpolated_signal= real(ifft(fft_signal));
    
end

