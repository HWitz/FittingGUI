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

RWTHBlauToene=1./255*cat(3,...
[ 000 084 159 ],...  % 100%
[ 064 127 183 ],...  %  75% 
[ 142 186 229 ],...  %  50% 
[ 199 221 242 ],...  %  25% 
[ 232 241 250 ]);    %  10% 

SekundaerFarben = 1./255*cat(3,...
[...                 % A 100%   
000 000 000 ;...     % 1 - Schwarz
227 000 102 ;...     % 2 - Magenta
255 237 000 ;...     % 3 - Gelb
],...
[...                 % B 75%
100 101 103 ;...     % 1 - Schwarz
233 096 136 ;...     % 2 - Magenta
255 240 85  ;...     % 3 - Gelb
],...
[...                 % C 50%
156 158 159 ;...     % 1 - Schwarz
241 158 177 ;...     % 2 - Magenta
255 245 155 ;...     % 3 - Gelb 
],...
[...                 % D 25%
207 209 210 ;...     % 1 - Schwarz    
249 210 218 ;...     % 2 - Magenta
255 250 209 ;...     % 3 - Gelb
],...
[...                 % E 10% 
236 237 237 ;...     % 1 - Schwarz
253 238 240 ;...     % 2 - Magenta
255 253 238 ;...     % 3 - Gelb
]);

ErgaenzendeFarben = 1./255*cat(3,...
[...                 % A 100%
000 097 101 ;...     % 1 - Petrol
000 152 161 ;...     % 2 - Türkis
87 171 39   ;...     % 3 - Grün
189 205 0   ;...     % 4 - Maigrün
246 168 0   ;...     % 5 - Orange
204 7 30    ;...     % 6 - Rot
161 16 53   ;...     % 7 - Bordeaux
97 33 88    ;...     % 8 - Violett
122 111 172 ;...     % 9 - Lila
],...
[...                 % B 75%
45 127 131  ;...     % 1 - Petrol
0 177 183   ;...     % 2 - Türkis
141 192 96  ;...     % 3 - Grün
208 217 92  ;...     % 4 - Maigrün
250 190 80  ;...     % 5 - Orange
216 92 65   ;...     % 6 - Rot
182 82 86   ;...     % 7 - Bordeaux
131 78 117  ;...     % 8 - Violett
155 145 193 ;...     % 9 - Lila
],...   
[...                 % C 50%
125 164 167 ;...     % 1 - Petrol
137 204 207 ;...     % 2 - Türkis
184 214 152 ;...     % 3 - Grün
224 230 154 ;...     % 4 - Maigrün
253 212 143 ;...     % 5 - Orange
230 150 121 ;...     % 6 - Rot
205 139 135 ;...     % 7 - Bordeaux
168 133 158 ;...     % 8 - Violett
188 181 215 ;...     % 9 - Lila
],...   
[...                 % D 25%
191 208 209 ;...     % 1 - Petrol
202 231 231 ;...     % 2 - Türkis
221 235 206 ;...     % 3 - Grün
240 243 208 ;...     % 4 - Maigrün
254 234 201 ;...     % 5 - Orange
243 205 187 ;...     % 6 - Rot
229 197 192 ;...     % 7 - Bordeaux
210 192 205 ;...     % 8 - Violett
222 218 235 ;...     % 9 - Lila
],...   
[...                 % E 10%
230 236 236 ;...     % 1 - Petrol
235 246 246 ;...     % 2 - Türkis
242 247 236 ;...     % 3 - Grün
249 250 237 ;...     % 4 - Maigrün
255 247 234 ;...     % 5 - Orange
250 235 227 ;...     % 6 - Rot
245 232 229 ;...     % 7 - Bordeaux
237 229 234 ;...     % 8 - Violett
242 240 247 ;...     % 9 - Lila
]);

PlotFarben=[...
SekundaerFarben(1,:,1)      ;...  % Schwarz
RWTHBlauToene(1,:,1)        ;...  % RWTHBlau
ErgaenzendeFarben(2,:,1)    ;...  % Türkis
ErgaenzendeFarben(3,:,1)    ;...  % Grün
ErgaenzendeFarben(5,:,1)    ;...  % Orange
ErgaenzendeFarben(6,:,1)    ;...  % Rot
SekundaerFarben(2,:,1)      ;...  % Magenta
ErgaenzendeFarben(7,:,1)    ;...  % Bordeaux
ErgaenzendeFarben(9,:,1)    ;...  % Lila
];
WenigPlotFarben=[...
RWTHBlauToene(1,:,1)        ;...  % RWTHBlau
ErgaenzendeFarben(6,:,1)    ;...  % Rot
SekundaerFarben(1,:,1)      ;...  % Schwarz
ErgaenzendeFarben(2,:,1)    ;...  % Türkis
ErgaenzendeFarben(6,:,2)    ;...  % Orange
];
RWTHBlau = RWTHBlauToene(1,:,1);
RWTHHellblau = RWTHBlauToene(1,:,2);
RWTHRot = ErgaenzendeFarben(6,:,1);
RWTHOrange = ErgaenzendeFarben(6,:,2);

RWTHGrau = SekundaerFarben(1,:,4);
RWTHMittelgrau = SekundaerFarben(1,:,3);
RWTHDunkelgrau = SekundaerFarben(1,:,2);
RWTHSchwarz = SekundaerFarben(1,:,1);
RWTHTuerkis = ErgaenzendeFarben(2,:,1);
