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

function [x, DRT] = makeDRT(Z, frequenz, usefilter, samplestofilter)
% Author: Friedrich Hust
% Entstanden Diplomarbeit 2013
% Update 05.11.2014
% W:\Intern\DASA_BAMA\2013\hwi-fhu_DRT-Modell\papierform
Rpol = 1;
evaluationDimension = 1;
evaulationVector = [ 1 0 ];
if nargin <3 || samplestofilter==1% check if we should filter the results
    usefilter = false;
end
if isreal(Z)
    Z = Z * 1j;
end
%% Transformation of data so we can work with it
if size(frequenz,1) < size(frequenz,2)
    evaluationDimension = 2;
    evaulationVector = [ 0 1];
end
% Get Rpol (width of ohmic resistance see papers of Schichlein
if real(Z(1)) ~= 0
    Rpol = abs(real(Z(1)) - real(Z(end)));
end

%% Transform frequency to linear scale
index = floor(size(frequenz,evaluationDimension)/2); % Take half the width of the frequency range (this gives more stable results)
freqm = frequenz(index); 
x = log(frequenz ./freqm ); % scale the frequency with the middle frequency

%% Transform data to frequency domain for S(f) / H(f) = DRT(f)
zn = fft(imag(-Z));  % Transform 
N = size(frequenz,evaluationDimension);
T = (1 / (N - 1)) * log (frequenz(end) / frequenz(1));
sn = fft(sech(x));
% gn = 1 / (N*T) *2 / Rpol * zn ./ sn;
gn = 1 / (N*T) *2 * zn ./ sn;

%% Verdammt! Integral über g(x) ist nicht Rpol
% Es muss noch mit der Anzahl der frequenzpunkte multipliziert werden
gn = gn .* N ;
% jetzt passts ;-) -> hwi,fhu 

%% Filter results 
if usefilter
    wn = fftshift(hann(floor(N*samplestofilter)+1 , N));
    gk = ifft(reshape((gn .* wn'),size(gn)));
else
    gk = ifft( gn );
end

%% Shift back the data by index 
DRT = circshift(gk, (index-1) .* evaulationVector) ;