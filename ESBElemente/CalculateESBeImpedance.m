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

function [ Z,Z_HF,Z_MF,Z_LF ] = CalculateESBeImpedance( ESBe,w,varargin )
%CalculateESBeImpedance Berechnung der Impedanz eines ESB_Elements
%   Detailed explanation goes here
    narginchk(numel(ESBe.inputs)+2,numel(ESBe.inputs)+2)
    for i = 1:numel(ESBe.inputs)
        eval([ESBe.inputs{i} '=' num2str(varargin{i})  ';'])
    end
    Z=eval(ESBe.Zfun);
    Z_HF=[];
    Z_MF=[];
    Z_LF=[];
    if nargout>1
        Z_HF=eval(ESBe.Zfun_HF);
        Z_MF=eval(ESBe.Zfun_MF);
        Z_LF=eval(ESBe.Zfun_LF);
    end
end

