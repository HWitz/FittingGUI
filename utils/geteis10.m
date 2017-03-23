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

function eis = geteis10(dateiname,blocknamen)
%GETEIS Daten aus EISmeter-Logdatei lesen
% 
% GETEIS(DATEINAME)liest alle Blöcke aus der EISmeter-Logdatei
% DATEINAME.
% Beispiel: 
%   geteis('eiscreme.log') 
%
% GETEIS(DATEINAME,BLOCKNAMEN)liest die im Cell-String 
% BLOCKNAMEN angegebenen Blöcke aus der EISmeter-Logdatei
% DATEINAME. Die angegebenen Blocknamen müssen exakt mit denen 
% in der EISmeter-Logdatei übereinstimmen.
% Ein Blockname entspricht dem Namen einer Prozedur, die 
% durch Schleifen im EISmeter-Programm mehrfach vorkommen kann.
%
% Beispiel: 
%   geteis('eiscreme.log',{'Spektrum1','Pause1'}) 
%
% for example, geteis6(filename,{'Spectrum_dch05'}) 
%
%
% EIS = GETEIS(DATEINAME,BLOCKNAMEN) gibt eine Struktur mit den
% Feldern zurück die den Namen der Blöcke entsprechen
% (sofern diese tatsächlich vorhanden sind). 
% Diese Blöcke enthalten ein bis meherer Felder als Cell-Array, 
% der Zugriff erfolgt über die Nummer des Blocks in geschweiften 
% Klammern.
% Jedes dieser Felder enthält wiederum die Felder DATUM, 
% SPALTEN_NAMEN und DATEN.
% DATUM enthält Datum und Uhrzeit, zu dem das Spektrum oder die 
% Pause begonnen wurde.
% SPALTEN_NAMEN enthält die Namen der Spalten, die im Feld
% DATEN als Matrix abgelegt sind.
%
% Beispiel:
%   eis = geteis('eiscreme.log',{'Spektrum1','Pause1'}) 
% liefert die Struktur: 
%   eis = 
%     Spektrum1: {1x5 cell}
%        Pause1: {[1x1 struct]}
% 
%   eis.Spektrum1{2}
% liefert die Ergebnisse der zweiten Messung mit der Prozedur
% Spektrum1:
%   ans = 
%             datum: 'Started at: 14:11:10 26/01/2004.'
%     spalten_namen: {1x18 cell}
%             daten: [37x18 double]
%
%   eis.Spektrum1{2}.spalten_namen{1:3}
% liefert die Namen der ersten drei Spalten (frequency, Re.1, Im.1)
% 
%   plot(eis.Spektrum1{2}.daten(:,2),-eis.Spektrum1{2}.daten(:,3))
% stellt das Spektrum grafisch dar.
%
% Siehe auch GETDIGA


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Funktionsargumente auswerten%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ohne Argumente geht nix!
if nargin < 1      %Return number of function arguments 
    error('Geben Sie den Dateinamen an.');
    eis = [];       
    return
%Wenn keine Blöcke angegeben sind, wird alles gelesen 
elseif nargin == 1
    alle_bloecke = true;
    %Dummies, damit Ausgabestruktur erzeugt werden kann, 
    %werden am Ende wieder gelöscht
    blocknamen={'dummy','dummy'};  
%Wenn Blöcke angegeben, nur diese einlesen    
elseif (nargin == 2 && iscellstr(blocknamen))
    alle_bloecke = false;
    %Bugfix, damit Suchen mit regexp funktioniert 
    if length(blocknamen) == 1  
        blocknamen{2}=blocknamen{1};
    end
else
    error('Fehlerhafte Funktionsargumente!');
    eis = [];       
    return
end
if (~exist(dateiname))
    error(strcat('Datei <',dateiname,'> nicht gefunden!'));
    eis = [];
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Hilfsvariablen initialisieren%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spk_nummer = [];
lies_spektrum = false;

pau_nummer = [];
lies_pause = false;

disch_nummer = [];
lies_discharge = false;

cha_nummer = [];
lies_chacha = [];

uch_nummer = [];
lies_uch = false;

lies_batdef = false;
lies_header = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ausgabestruktur erzeugen%
%%%%%%%%%%%%%%%%%%%%%%%%%%
if(~isempty(blocknamen))        %isempty, Determine if array is empty, returns logical true (1) if A is an empty array
    for n=1:length(blocknamen)  %here use () but not {}, index but not content,from last example blocknamen={'Spectrum_dch05'}, length(blocknamen)==1
        eis.(blocknamen{n})=[]; %{}, content
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Namen der Struktureigenschaften %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spektrumnamen=[];
pausennamen=[];
dischargenamen=[];
chanamen=[];
uchnamen=[];

%%%%%%%%%%%%%%%%%%%%
%Einlesen der Datei%
%%%%%%%%%%%%%%%%%%%%
fid=fopen(dateiname);       %Datei mit Messdaten öffnen, fid = fopen(filename) opens the file filename for read access.
while 1
    tline = fgetl(fid);                 %eine Zeile einlesen, tline = fgetl(fid) returns the next line of the file associated with the file identifier fid. 
    if ~ischar(tline), break, end;      %Bei Dateiende herausspringen, tf = ischar(A) returns logical 1 (true) if A is a character array 
    if ~isempty(tline)                       %wenn Zeile nicht leer, weitermachen
        if isempty(strfind(tline,'waiting for timeout...')) ==0
            while isempty(strfind(tline,'------------------------------'))
                tline = fgetl(fid);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Zeilenweises Einlesen der Daten, wenn SPK oder PAU or gefunden wurde%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if (lies_batdef)                      %wird gerade die Batteriedef. eingelesen? ???batdef?
            if (any(strmatch('---',tline)) )  %Find possible matches for string
                lies_batdef = false;         %Ende der Bat.def. gefunden
            else                             %sonst: Zeilen als Zahlen lesen
                clear batdef_tmp;
	%             tline = fgetl(fid);                 %eine Zeile einlesen
                batdef_tmp = strread(tline,'%s','delimiter','\t')';
%                 batdef_tmp = strread(fgetl(fid),'%s','delimiter','\t')';
                if length(batdef_tmp) == 9
                    batdef_tmp(3:10) = batdef_tmp(2:9);
                end;
                eis.batdef.daten=...
                    [eis.batdef.daten; batdef_tmp];        
	%             eis.batdef.daten=...
	%                 [eis.batdef.daten; strread(tline,'%s')'];        
            end
        end
        if (lies_spektrum)                  %wird gerade ein Spektrum gelesen?
            %Ende des Spektrums gefunden?
            if (any(strmatch('---',tline)) || any(strmatch('Meas',tline)) )
                lies_spektrum = false;      
            else                            %sonst Zeilen als Zahlen lesen
                %und an Array anhängen (die Struktur wird weiter unten erzeugt)
                eis.(spk_name){spk_nummer.(spk_name)}.daten=...
                    [eis.(spk_name){spk_nummer.(spk_name)}.daten;strread(tline,'%f')'];        
            end
        end
        if (lies_pause)                      %wird gerade eine Pause eingelesen?
            if (any(strmatch('---',tline)) || any(strmatch('Meas',tline)) )
                lies_pause = false;          %Ende der Pausegefunden
            else                             %sonst: Zeilen als Zahlen lesen
                eis.(pau_name){pau_nummer.(pau_name)}.daten=...
                    [eis.(pau_name){pau_nummer.(pau_name)}.daten;strread(tline,'%f')'];        
            end
        end
        
        if(lies_discharge)  % one discharge process is read
            if (any(strmatch('---',tline)) || any(strmatch('Meas',tline)) )
                lies_discharge = false;
            else
                eis.(disch_name){disch_nummer.(disch_name)}.daten=...
                    [eis.(disch_name){disch_nummer.(disch_name)}.daten;strread(tline,'%f')'];
            end
        end
        
        if (lies_chacha)                      %wird gerade eine charge eingelesen?
            if (any(strmatch('---',tline)) || any(strmatch('Meas',tline)) )
                lies_chacha = false;          %Ende der Pausegefunden
            else                             %sonst: Zeilen als Zahlen lesen
                eis.(cha_name){cha_nummer.(cha_name)}.daten=...
                    [eis.(cha_name){cha_nummer.(cha_name)}.daten;strread(tline,'%f')'];        
            end
        end
        
        
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Aktionen, wenn der Header gefunden wurde%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if(strmatch('[LogInfo]',tline))     %wenn Anfang der Bat.beschr. gefunden
                disp('Header gefunden');
                tline = fgetl(fid);             %nächste Zeile (Versionsnummer) einlesen
                eis.header.version = num2str(tline(end));
                tline = fgetl(fid);             %nächste Zeile (Datum + Uhrzeit) einlesen
                eis.header.datetext = tline;
                eis.header.startsec = datenum(tline(25:32),13)*24*3600;
                eis.header.startdate = datenum(tline(34:43), 'dd/mm/yyyy');
                tline = fgetl(fid);             %nächste Zeile (Script) einlesen
                eis.header.script = tline(28:end-3);
                lies_header = true;
            end;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Aktionen, wenn der Anfang der Batteriebeschreibung gefunden wurde%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if(strmatch('The following Batteries',tline))     %wenn Anfang der Bat.beschr. gefunden
            disp('Batteriebeschreibung gefunden')
            %Spaltennamen einlesen
	%         eis.batdef.spalten_namen = strread(tline,'%s','delimiter',';')'; 
            eis.batdef.spalten_namen = strread(fgetl(fid),'%s','delimiter','\t')';
            %erste Zeile der Daten einlesen und in Array ablegen
            batdef_tmp = strread(fgetl(fid),'%s','delimiter','\t')';
            if length(batdef_tmp) == 9
                batdef_tmp(3:10) = batdef_tmp(2:9);
            end;
            eis.batdef.daten = batdef_tmp;
	%         eis.batdef.daten = strread(fgetl(fid),'%s')';
            lies_batdef = true;
        end;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Aktionen, wenn der Anfang eines Spektrums gefunden wurde%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if(strmatch('SPK',tline))           %wenn Anfang des Spektrums gefunden
                spk_name = fgetl(fid);          %nächste Zeile lesen (Name)
                spk_name = strrep(spk_name,'	1','');
                spk_name = strrep(spk_name,'.','_');
                %Ist der Name in der Liste oder sollen alle Bloecke gelesen werden?
                if(alle_bloecke || any(cell2mat(regexp(spk_name,blocknamen))))
                    if(~isfield(eis,(spk_name)))     %wenn neuer Block gefunden 
                        spektrumnamen{length(spektrumnamen)+1} = spk_name;
                        spk_nummer.(spk_name) = 1;              %Spektren neu numerieren
                    else
                        spk_nummer.(spk_name) = spk_nummer.(spk_name) + 1; %sonst Zähler hochsetzen
                    end
                    %Datumzeile einlesen (Feld wird dynamisch aus Blocknamen
                    %erzeugt)
                    eis.(spk_name){spk_nummer.(spk_name)}.datum = fgetl(fid);
                    %aus dem Datum die Sekunden seit Programmstart
                    %berechnen (86400 Sekunden pro Tag)
                    t0 = 86400*datenum(eis.(spk_name){spk_nummer.(spk_name)}.datum(13:20));
                    d0 = datenum(eis.(spk_name){spk_nummer.(spk_name)}.datum(22:31), 'dd/mm/yyyy');
                    dt  =((t0 - eis.header.startsec)+86400*(d0-eis.header.startdate));
                    eis.(spk_name){spk_nummer.(spk_name)}.startsec = dt;
                    spaltenGefunden=1;
                    while spaltenGefunden
                        %Test, ob nächste Zeile Spaltennamen enthält
                        testSpalten=strread(fgetl(fid),'%s')';
                        if strcmp(testSpalten{1}, 'time') | strcmp(testSpalten{1}, 'frequency')
                            %Spaltennamen abspeichern
                            eis.(spk_name){spk_nummer.(spk_name)}.spalten_namen = testSpalten;
                            spaltenGefunden=0;
                        end
                    end
                    %erste Zeile der Daten einlesen und in Array ablegen
                    eis.(spk_name){spk_nummer.(spk_name)}.daten = strread(fgetl(fid),'%f')';
                    lies_spektrum = true;               %und jetzt Spektrum weiter auslesen
                end;
            end;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Aktionen, wenn der Anfang einer Pause gefunden wurde%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %funktioniert genau wie beim Spektrum nur ist zwischen Datum und
            %Spaltennamen eine zusätzliche Leerzeile
            if(strmatch('PAU',tline))               %Anfang der Pause finden
                pau_name = fgetl(fid);              %nächste Zeile lesen (Name)
                %Wenn Blockname in Liste oder alle Bloecke gelesen werden sollen...
                if(alle_bloecke || any(cell2mat(regexp(pau_name,blocknamen))))
                    if(~isfield(eis,(pau_name)))     %wenn neuer Block
                        pausennamen{length(pausennamen)+1} = pau_name;
                        pau_nummer.(pau_name) = 1;              %Spektren neu numerieren
                    else
                        pau_nummer.(pau_name) = pau_nummer.(pau_name) + 1;
                    end
                    %Datumzeile einlesen
                    eis.(pau_name){pau_nummer.(pau_name)}.datum = fgetl(fid);  
                    %aus dem Datum die Sekunden seit Programmstart
                    %berechnen (86400 Sekunden pro Tag)
                    t0 = 86400*datenum(eis.(pau_name){pau_nummer.(pau_name)}.datum(13:20));
                    d0 = datenum(eis.(pau_name){pau_nummer.(pau_name)}.datum(22:31), 'dd/mm/yyyy');
                    dt  =((t0 - eis.header.startsec)+86400*(d0-eis.header.startdate));
                    eis.(pau_name){pau_nummer.(pau_name)}.startsec = dt;
                    %Leerzeile einlesen und verwerfen (Unterschied zu Spektrum)
                    fgetl(fid); 
                    %Spaltennamen einlesen
                    eis.(pau_name){pau_nummer.(pau_name)}.spalten_namen = strread(fgetl(fid),'%s')';
                    %erste Zeile der Daten einlesen
                    eis.(pau_name){pau_nummer.(pau_name)}.daten = strread(fgetl(fid),'%f')';
                    lies_pause = true;               %und jetzt Spektrum weiter auslesen
                end;
            end;
            

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Aktionen, wenn der Anfang einer charge gefunden wurde%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %funktioniert genau wie beim Spektrum nur ist zwischen Datum und
            %Spaltennamen eine zusätzliche Leerzeile
            if(strmatch('CHA',tline))               %Anfang der charge finden
                cha_name = fgetl(fid);              %nächste Zeile lesen (Name)
                %Wenn Blockname in Liste oder alle Bloecke gelesen werden sollen...
                if(alle_bloecke || any(cell2mat(regexp(cha_name,blocknamen))))
                    if(~isfield(eis,(cha_name)))     %wenn neuer Block
                        chanamen{length(chanamen)+1} = cha_name;
                        cha_nummer.(cha_name) = 1;              %Spektren neu numerieren
                    else
                        cha_nummer.(cha_name) = cha_nummer.(cha_name) + 1;
                    end
                    %Datumzeile einlesen
                    eis.(cha_name){cha_nummer.(cha_name)}.datum = fgetl(fid);  
                    %aus dem Datum die Sekunden seit Programmstart
                    %berechnen (86400 Sekunden pro Tag)
                    t0 = 86400*datenum(eis.(cha_name){cha_nummer.(cha_name)}.datum(13:20));
                    d0 = datenum(eis.(cha_name){cha_nummer.(cha_name)}.datum(22:31), 'dd/mm/yyyy');
                    dt  =((t0 - eis.header.startsec)+86400*(d0-eis.header.startdate));
                    eis.(cha_name){cha_nummer.(cha_name)}.startsec = dt;
                    %Leerzeile einlesen und verwerfen (Unterschied zu Spektrum)
                    fgetl(fid); 
                    %Spaltennamen einlesen
                    eis.(cha_name){cha_nummer.(cha_name)}.spalten_namen = strread(fgetl(fid),'%s')';
                    %erste Zeile der Daten einlesen
                    eis.(cha_name){cha_nummer.(cha_name)}.daten = strread(fgetl(fid),'%f')';
                    lies_chacha = true;               %und jetzt Spektrum weiter auslesen
                end;
            end;
        
               
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Aktionen, wenn der Anfang einer U-Ladung gefunden wurde%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %funktioniert genau wie beim Spektrum nur ist zwischen Datum und
            %Spaltennamen eine zusätzliche Leerzeile
            if(strmatch('UCH',tline))               %Anfang der Pause finden
                uch_name = fgetl(fid);              %nächste Zeile lesen (Name)
                %Wenn Blockname in Liste oder alle Bloecke gelesen werden sollen...
                if(alle_bloecke || any(cell2mat(regexp(uch_name,blocknamen))))
                    if(~isfield(eis,(uch_name)))     %wenn neuer Block
                        uchnamen{length(uchnamen)+1} = uch_name;
                        uch_nummer.(uch_name) = 1;              %Spektren neu numerieren
                    else
                        uch_nummer.(uch_name) = uch_nummer.(uch_name) + 1;
                    end
                    %Datumzeile einlesen (Feld wird dynamisch aus Blocknamen
                    %erzeugt)
                    eis.(uch_name){uch_nummer.(uch_name)}.datum = fgetl(fid);
                    %aus dem Datum die Sekunden seit Programmstart
                    %berechnen (86400 Sekunden pro Tag)
                    t0 = 86400*datenum(eis.(uch_name){uch_nummer.(uch_name)}.datum(13:20));
                    dt  = (t0 - eis.header.startsec);
                    while dt < 0 
                        dt = dt + 86400;
                    end;
                    eis.(uch_name){uch_nummer.(uch_name)}.startsec = dt;
                    %Leerzeile einlesen und verwerfen (Unterschied zu Spektrum)
                    fgetl(fid); 
                    %Spaltennamen einlesen
                    eis.(uch_name){uch_nummer.(uch_name)}.spalten_namen = strread(fgetl(fid),'%s')';
                    %erste Zeile der Daten einlesen
                    eis.(uch_name){uch_nummer.(uch_name)}.daten = strread(fgetl(fid),'%f')';
                    lies_uch = true;               %und jetzt  weiter auslesen
                end;
            end;     
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Aktionen, wenn der Anfang eines disCharges gefunden wurde%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if(strmatch('DCH',tline))               %Anfang der Charge finden
            disch_name = fgetl(fid);              %nächste Zeile lesen (Name)
            disch_name = strrep(disch_name,'.','_');
            %Wenn Blockname in Liste oder alle Bloecke gelesen werden sollen...
            if(alle_bloecke || any(cell2mat(regexp(disch_name,blocknamen))))
                if(~isfield(eis,(disch_name)))     %wenn neuer Block
                    disch_nummer.(disch_name) = 1;              %Spektren neu numerieren
                    dischargenamen{length(dischargenamen)+1} = disch_name;
                else
                    disch_nummer.(disch_name) = disch_nummer.(disch_name) + 1;
                end
                %Datumzeile einlesen
                eis.(disch_name){disch_nummer.(disch_name)}.datum = fgetl(fid);
                    %aus dem Datum die Sekunden seit Programmstart
                    %berechnen (86400 Sekunden pro Tag)
                    t0 = 86400*datenum(eis.(disch_name){disch_nummer.(disch_name)}.datum(13:20));
                    d0 = datenum(eis.(disch_name){disch_nummer.(disch_name)}.datum(22:31), 'dd/mm/yyyy');
                    dt  =((t0 - eis.header.startsec)+86400*(d0-eis.header.startdate));
                    eis.(disch_name){disch_nummer.(disch_name)}.startsec = dt;
                %Leerzeile einlesen und verwerfen (Unterschied zu Spektrum)
                fgetl(fid); 
                %Spaltennamen einlesen
                eis.(disch_name){disch_nummer.(disch_name)}.spalten_namen = strread(fgetl(fid),'%s')';
                %erste Zeile der Daten einlesen
                eis.(disch_name){disch_nummer.(disch_name)}.daten = strread(fgetl(fid),'%f')';
                lies_discharge = true;               %und jetzt Spektrum weiter auslesen
            end;
        end;
        
    end;
end;

eis.SpektrumNamen=spektrumnamen;
eis.PausenNamen=pausennamen;
eis.ChargeNamen=chanamen;
eis.DischargeNamen=dischargenamen;
eis.UCH_Namen=uchnamen;

%%%%%%%%%%%%%%%%%%%%
%Aufräumen und Ende%
%%%%%%%%%%%%%%%%%%%%
if (isfield(eis,'dummy') == 1)              %falls vorhanden...
    eis = rmfield(eis,'dummy');             %Dummies löschen
end
fclose(fid);                                %Datei schliessen
