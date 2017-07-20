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

function varargout = FittingGUI(varargin)
% FittingGUI MATLAB code for FittingGUI.fig
%      FittingGUI, by itself, creates a new FittingGUI or raises the existing
%      singleton*.
%
%      H = FittingGUI returns the handle to a new FittingGUI or the handle to
%      the existing singleton*.
%
%      FittingGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FittingGUI.M with the given input arguments.
%
%      FittingGUI('Property','Value',...) creates a new FittingGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FittingGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FittingGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to hHFCelp FittingGUI

% Last Modified by GUIDE v2.5 20-Jul-2017 11:34:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FittingGUI_OpeningFcn, ...
    'gui_OutputFcn',  @FittingGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FittingGUI is made visible.
function FittingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FittingGUI (see VARARGIN)

% Choose default command line output for FittingGUI

config
handles.output = hObject;

 if 0 && ~isempty(strfind(version,'R2013')) || ~isempty(strfind(version,'R2012')) || ~isempty(strfind(version,'R2011')) || ~isempty(strfind(version,'R2010'))
    

    handles.tgroup = uitabgroup('Parent', handles.figure1,'TabLocation', 'top');
    handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'DRT');
    handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'HF-MF-LF');


    set(handles.DRTPanel,'Parent',handles.tab1)
    set(handles.axes3,'Parent',handles.tab1)
    set(handles.fig3_export_button,'Parent',handles.tab1)
    % 
    set(handles.axes5,'Parent',handles.tab2)
    set(handles.fig5_export_button,'Parent',handles.tab2)
    % 
    set(handles.axes6,'Parent',handles.tab2)
    set(handles.fig6_export_button,'Parent',handles.tab2)


    set(handles.ProzessFittingChooseInitialValuesCheckbox,'Parent',handles.tab1)
    set(handles.TauTable,'Parent',handles.tab1)
    set(handles.DRT_Tau_use_button,'Parent',handles.tab1)
    set(handles.TauCaption,'Parent',handles.tab1)
    set(handles.DRT_Prozesse_use_button,'Parent',handles.tab1)
    set(handles.ProzesseTable,'Parent',handles.tab1)

    % Update handles structure
    
 else
        set(handles.axes5,'visible','off')
%     set(handles.fig5_export_button,'visible','off')
    % 
    set(handles.axes6,'visible','off')
%     set(handles.fig6_export_button,'visible','off')

 end
        guidata(hObject, handles);

ModellAktualisierenButton_Callback(handles.ModellAktualisierenButton, [], handles)

%aktualisieren_Button_Callback(handles.aktualisieren_Button,[],handles)


% UIWAIT makes FittingGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FittingGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles;

aktualisieren_Button_Callback(handles.aktualisieren_Button,eventdata,handles)


% --- Executes on button press in EinleseButton.
function EinleseButton_Callback(hObject, eventdata, handles)
% hObject    handle to EinleseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;
global Pattern
DC_Current = 0 ;
Index100percent = -1;
alter_pfad = pwd;
[filename, pathname] = uigetfile({'*.mat' 'µEis oder Eiskarte'; '*.txt;*.csv' 'Zahner';'*.log' 'EISlog';'*.xls;*.xlsx' 'Excel'}, 'Die Daten auswählen.', 'MultiSelect','on');
cd(alter_pfad);
if isempty(filename) || (~iscell(filename) && sum(filename == 0) )
    error('keine Daten eingelesen!!!');
    return
end
if ~iscell(filename)
    files{1} = filename;
else
    files = filename;
end
for i = 1:numel(files)
    filename = files{i};
%     set(handles.fileName_text,'String',strcat(pathname,filename),'ForegroundColor','k');
    
    DRT_GUI = [];
    DRT_GUI.Testparameter.fileName = strcat(pathname,filename);
    
    
    set(handles.PunkteWegnehmenTextBox,'String','');
    set(handles.ModellFormelTextBox,'String','');
    
    
    % set(handles.ModellAuswahlPopup,'Value',0);
    % set(handles.ModellAuswahlPopup,'String','Zuerst Modell aktualisieren');
    
    if strcmp(filename(end-3:end),'.txt') || strcmp(filename(end-3:end),'.csv')
        fid = fopen(strcat(pathname,filename));
        C = textscan(fid,'%s');
        C = C{1};
        fclose(fid);
        SpaltenAnzahl = str2double(C(find(strcmp(C,'Spalten:'),1)+1));
        if isempty(SpaltenAnzahl),
            SpaltenAnzahl = str2double(C(find(strcmp(C,'Columns:'),1)+1));
        end
        ZeilenAnzahl = str2double(C(find(strcmp(C,'Zeilen:'),1)+1));
        if isempty(ZeilenAnzahl),
            ZeilenAnzahl = str2double(C(find(strcmp(C,'Lines:'),1)+1));
        end
        if ~isempty(SpaltenAnzahl) && ~isempty(ZeilenAnzahl)
            StartIndex = find(strcmp(C,'Nummer'),1);
            if isempty(StartIndex),
                StartIndex = find(strcmp(C,'Number'),1);
            end
            
            StartIndex = StartIndex + find(strcmp(C(StartIndex+1:end),'1'),1);
            Daten = reshape(cellfun(@str2double,C(StartIndex:end)), SpaltenAnzahl+1,numel(C(StartIndex:end))/(SpaltenAnzahl+1));
            messung.diga.daten.ActFreq = Daten(2,:);
            messung.diga.daten.Zreal1 = Daten(3,:);
            messung.diga.daten.Zimg1 = Daten(4,:);
        else
            % kein Zahner-Format
            fid = fopen(strcat(pathname,filename));
            C = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s','delimiter',';');
            fclose(fid);
            for spaltenIndex = 1:numel(C)
                if isempty(C{spaltenIndex}{1}) , break,end
                messung.diga.daten.(C{spaltenIndex}{1}) = str2double(strrep(C{spaltenIndex}(3:end),',','.'))';
            end
        end
        
        
    elseif ( strcmp(filename(end-3:end),'.xls') || strcmp(filename(end-4:end),'.xlsx'))
       
        Daten=xlsread(strcat(pathname,filename));
        if sum((Daten(1:4,1)' ~= 1:4))==0 ,
            messung.diga.daten.ActFreq = Daten(:,2);
            messung.diga.daten.Zreal1 = Daten(:,3);
            messung.diga.daten.Zimg1 = -Daten(:,4);
        else
            messung.diga.daten.ActFreq = Daten(:,1);
            messung.diga.daten.Zreal1 = Daten(:,2);
            messung.diga.daten.Zimg1 = Daten(:,3);
        end
    elseif strcmp(filename(end-3:end),'.log')
        messung.eis = geteis10(strcat(pathname,filename));
    elseif strcmp(filename(end-3:end),'.mat')
        messung=load(strcat(pathname,filename));
        elseif strcmp(filename(end-3:end),'.mpt')
        fid = fopen(strcat(pathname,filename),'r');
        delimiter= '\t';
        startRow = 58;
        endRow = 141;
        formatSpec = '%f%f%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%f%f%*s%*s%f%f%*s%*s%*s%*s%[^\n\r]';
        
        textscan(fid, '%[^\n\r]', startRow(1)-1, 'ReturnOnError', false);
        dataArray = textscan(fid, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'ReturnOnError', false);
        for block=2:length(startRow)
            frewind(fid);
            textscan(fid, '%[^\n\r]', startRow(block)-1, 'ReturnOnError', false);
            dataArrayBlock = textscan(fid, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'ReturnOnError', false);
            for col=1:length(dataArray)
                dataArray{col} = [dataArray{col};dataArrayBlock{col}];
            end
        end
        fclose(fid);
        Daten=[dataArray{1:end-1}];
        list={'Zelle', 'Kathode', 'Anode'}; %Auswahlliste
        [Selection,~]=listdlg('ListString',list,'ListSize',[160,90],'PromptString','Welches Spektrum?','SelectionMode','single');
        if Selection == 1
            messung.diga.daten.ActFreq = Daten(:,1).';
            messung.diga.daten.Zreal1 = Daten(:,6).';
            messung.diga.daten.Zimg1 = -Daten(:,7).';
            Impedanzart = 'Zelle';
        elseif Selection ==2
            messung.diga.daten.ActFreq = Daten(:,1).';
            messung.diga.daten.Zreal1 = Daten(:,2).';
            messung.diga.daten.Zimg1 = -Daten(:,3).';
            Impedanzart = 'Kathode';
        elseif Selection ==3
            messung.diga.daten.ActFreq = Daten(:,1).';
            messung.diga.daten.Zreal1 = Daten(:,4).';
            messung.diga.daten.Zimg1 = -Daten(:,5).';
            Impedanzart = 'Anode';
        end
    end
    
    
    
    % FittingGUI = Extrakt;
    
    %%% die Batteriezustand durch die Pathname und Filename bekommen, (BatterieNr, SOC, Temperatur)
    % suchungsname initialisieren
    datefound = 0;
    [DString DStringOrig] = FindDateInStr(filename);
    if ~isempty(DString)
        datefound = 1;
        set(handles.DatumTextBox,'String',datestr(datenum(DString)))
        DatumTextBox_Callback(handles.DatumTextBox)
    end
    
    Batteriefound = 0;
    for i = 1:numel(Pattern.Batterie)
        [k,l] = regexp(filename,Pattern.Batterie{i});
        if isempty(k) && Pattern.Batterie{i}(1)=='_'
            [k,l] = regexp(filename(1:numel(Pattern.Batterie{i})),Pattern.Batterie{i}(2:end));
        end
        if k > 0
            set(handles.BatterieTextBox,'String',filename(k:l));
            BatterieTextBox_Callback(handles.BatterieTextBox);
            Batteriefound = 1;
            break
        end
    end
    if Batteriefound==0;
        while true
            Batteriename= inputdlg('Wie heißt die Batterie?','Batteriename',[1],{'dummy'});
            if  isempty(Batteriename) ||    strcmp(Batteriename,'') , 
                return
            else
                Batteriename=Batteriename{1};
                break
            end
        end
        set(handles.BatterieTextBox,'String',Batteriename);
        BatterieTextBox_Callback(handles.BatterieTextBox);
        Batteriefound = 1;
    end
    
    Temperaturfound = 0;
    for i = 1:numel(Pattern.Temperatur)
        [k,l] = regexp(filename,Pattern.Temperatur{i});
        if k > 0
            if k==1
                Temperatur = regexprep(regexprep(regexprep(regexprep(regexprep(regexprep(regexprep(filename(k:l),'low',''),'grad',''),'Grad',''),'m','-'),'_',''),'T',''),'Messung',''); %Ergänzung: Eine Stelle zu wenig betrachtet: Minus wurde nicht erkannt
            else
                Temperatur = regexprep(regexprep(regexprep(regexprep(regexprep(regexprep(regexprep(filename(k:l),'low',''),'grad',''),'Grad',''),'m','-'),'_',''),'T',''),'Messung',''); %Ergänzung: Eine Stelle zu wenig betrachtet: Minus wurde nicht erkannt
            end
            set(handles.TemperaturTextBox,'String',Temperatur);
            TemperaturTextBox_Callback(handles.TemperaturTextBox);
            Temperaturfound = 1;
            break
        end
    end
    
    Zustandfound = 0;
    for i = 1:numel(Pattern.Zustand)
        [k,l] = regexp(filename,Pattern.Zustand{i});
        if k > 0
            Zustandfound = 1;
            Zustand = filename(k:l);
            if strcmp(Zustand(end-3:end) , '_psa') && strcmp('=',Zustand(1)) && size(Zustand,2)==7
                Zustand = ['CU' Zustand(2:3)];
            end
            set(handles.ZustandTextBox,'String',Zustand);
            ZustandTextBox_Callback(handles.ZustandTextBox);
            break
        end
    end
    if ~Zustandfound
        if strcmp(filename(end-3:end),'.mpt');
            Zustandfound= 1;
            Zustand = Impedanzart;
            set(handles.ZustandTextBox,'String',Zustand);
            ZustandTextBox_Callback(handles.ZustandTextBox);
        else
            Zustand = 'default';
            set(handles.ZustandTextBox,'String',Zustand);
            ZustandTextBox_Callback(handles.ZustandTextBox);
        end
    end
    
    SOCfound = 0;
    for i = 1:numel(Pattern.SOC)
        [k,l] = regexp(filename,Pattern.SOC{i});
        if k > 0
            SOCfound = 1;
            SOC = regexprep(regexprep(regexprep(filename(k:l),'SOC',''),'m','-'),'_','');
            set(handles.SOCTextBox,'String',SOC);
            SOCTextBox_Callback(handles.SOCTextBox);
            break
        end
    end
    
    
    
    if sum(ismember(fieldnames(messung),'diga'))
        if sum(~diff(messung.diga.daten.ActFreq)~=0)
            index = find(messung.diga.daten.ActFreq>0 & [1 diff(messung.diga.daten.ActFreq)~=0]);
        else
            index = 1:numel(messung.diga.daten.ActFreq);
        end
        [k,l] = regexp(filename,'EIS\d\d\d\d\d');
        if ~isempty(k)
            eisnumber = str2double(filename(k+3:l));
        else
            eisnumber=0;
        end
        ind2 = find(diff(messung.diga.daten.ActFreq(index))>0);
        if ~isempty(ind2)
            ind2 = [1 ind2+1 numel(index)+1];
            if eisnumber>0 && eisnumber < numel(ind2)
                index = index(ind2(eisnumber):(ind2(eisnumber+1)-1));
            else
                eisnumber = inputdlg(['Which spectrum should be imported? ( 1 to '  num2str(numel(ind2)-1) ' )'],'number of spectrum',1,{'1'});
                if isempty(eisnumber), return , end
                eisnumber = str2num(cell2mat(eisnumber));
                index = index(ind2(eisnumber):(ind2(eisnumber+1)-1));

            end
            
        end
        DRT_GUI.Messdaten.frequenz = messung.diga.daten.ActFreq(index)';
        DRT_GUI.Messdaten.omega = 2*pi*messung.diga.daten.ActFreq(index)';
        DRT_GUI.Messdaten.tau = 1./DRT_GUI.Messdaten.omega;
        DRT_GUI.Messdaten.Zreal = messung.diga.daten.Zreal1(index)';
        DRT_GUI.Messdaten.Zimg = messung.diga.daten.Zimg1(index)';
        if ~isempty(find(strcmp(fieldnames(DRT_GUI.Messdaten),'U1'), 1))
            DRT_GUI.Messdaten.U1 = messung.diga.daten.U1(index)';
        end
    elseif sum(ismember(fieldnames(messung),'data')) && sum(ismember(fieldnames(messung.data),'values')) && sum(ismember(fieldnames(messung.data),'header'))
        f_index = find(strcmp(messung.data.header,'f [Hz]'));
        Zreal_index = find(strcmp(messung.data.header,'Zreal [Ohm]'));
        Zimag_index = find(strcmp(messung.data.header,'-Zimag [Ohm]'));

        DRT_GUI.Messdaten.frequenz = messung.data.values(:,f_index);
        DRT_GUI.Messdaten.omega = 2*pi*messung.data.values(:,f_index);
        DRT_GUI.Messdaten.tau = 1./DRT_GUI.Messdaten.omega;
        DRT_GUI.Messdaten.Zreal =messung.data.values(:,Zreal_index);
        DRT_GUI.Messdaten.Zimg = messung.data.values(:,Zimag_index);        
    elseif sum(ismember(fieldnames(messung),'eis'))
        if size(messung.eis.batdef.daten,1)>1
            BatNumber = listdlg('PromptString','Select a Battery:','SelectionMode','single','ListString',messung.eis.batdef.daten(:,1));
            set(handles.BatterieTextBox,'String',messung.eis.batdef.daten{BatNumber,1})
            BatterieTextBox_Callback(handles.BatterieTextBox);
            Batteriefound = 1;
        else
            BatNumber = 1;
        end
        
        ChannelNumber = str2num(messung.eis.batdef.daten{BatNumber,find(strcmp(messung.eis.batdef.spalten_namen,'connected voltage channels'))});
        if numel(messung.eis.SpektrumNamen) > 1
            SpecNumber = listdlg('PromptString','Select a spectrum:','SelectionMode','single','ListString',messung.eis.SpektrumNamen);
            SpecString = messung.eis.SpektrumNamen{SpecNumber};
            SOCfound = 0;
            for i = 1:numel(Pattern.SOC)
                [k,l] = regexp(SpecString,Pattern.SOC{i});
                if k > 0
                    SOCfound = 1;
                    SOC = regexprep(regexprep(regexprep(regexprep(SpecString(k:l),'SOC',''),'SO',''),'m','-'),'_','');
                    set(handles.SOCTextBox,'String',SOC);
                    SOCTextBox_Callback(handles.SOCTextBox);
                    break
                end
            end
            
        elseif  numel(messung.eis.SpektrumNamen)==1
            SpecNumber = 1;
            if ~isempty(messung.eis.SpektrumNamen)
                SpecString = messung.eis.SpektrumNamen{SpecNumber};
            else
                SpecString = '';
            end
            SOCfound = 0;
        else
            msgbox('kein Spektrum vorhanden');
            return
        end
        if ~datefound
            [DString DStringOrig]  = FindDateInStr(messung.eis.(SpecString){1}.datum);
            if ~isempty(DString)
                datefound = 1;
                set(handles.DatumTextBox,'String',datestr(datenum(DString)))
                DatumTextBox_Callback(handles.DatumTextBox)
            end
        end
        freqindex = find(strcmp(messung.eis.(SpecString){1}.spalten_namen,'frequency'));
        nonzeros = find(messung.eis.(SpecString){1}.daten(:,freqindex)~=0 & ~isnan(messung.eis.(SpecString){1}.daten(:,freqindex)));
        DRT_GUI.Messdaten.frequenz = messung.eis.(SpecString){1}.daten(nonzeros,freqindex);
        
        DRT_GUI.Messdaten.omega = 2*pi*DRT_GUI.Messdaten.frequenz;
        DRT_GUI.Messdaten.tau = 1./DRT_GUI.Messdaten.omega;
        realindex = find(strcmp(messung.eis.(SpecString){1}.spalten_namen,['U' num2str(ChannelNumber) 'R']));
        if isempty (realindex)
            realindex = find(strcmp(messung.eis.(SpecString){1}.spalten_namen,['Re.' num2str(ChannelNumber-1)]));
        end
        DRT_GUI.Messdaten.Zreal = messung.eis.(SpecString){1}.daten(nonzeros,realindex);
        imagindex = find(strcmp(messung.eis.(SpecString){1}.spalten_namen,['U' num2str(ChannelNumber) 'I']));
        if isempty(imagindex)
            imagindex = find(strcmp(messung.eis.(SpecString){1}.spalten_namen,['Im.' num2str(ChannelNumber-1)]));
        end
        DRT_GUI.Messdaten.Zimg = messung.eis.(SpecString){1}.daten(nonzeros,imagindex);
        
        
    else
        error('Dateiformat nicht bekannt!')
        return
    end
    if ~datefound
        while true
            DString = cell2mat(inputdlg('Bitte Testdatum angeben! (yyyy-mm-dd)','Datum',[1],{datestr(now,'yyyy-mm-dd')}));
            if  isempty(DString) , return,end
            if isdate(DString)
                set(handles.DatumTextBox,'String',datestr(datenum(DString,'yymmdd')))
                datefound = 1;
                break,
            end;
        end
    end
    if ~Temperaturfound
        while true
            if get(handles.AutoCapCheckBox,'Value')
                Temperatur = 25;
            else
                Temperatur = str2double(inputdlg('Welche Testtemperatur?','Temperatur',[1],{'25'}));
            end
            choice = num2str(Temperatur);
            if  strcmp(choice,'') , return,end
            if ~strcmp(choice,'NaN'), break, end;
        end
        set(handles.TemperaturTextBox,'String',choice)
        TemperaturTextBox_Callback(handles.TemperaturTextBox)
        Temperaturfound = 1;
    end
    if SOCfound == 0
        if ~exist('eisnumber')
            [k,l] = regexp(filename,'EIS\d\d\d\d\d');
            eisnumber = str2double(filename(k+3:l));
        end
        masterfound = 0;
        master_file = dir([pathname '*' DStringOrig '*.mat']);
        for Master_i = 1:numel(Pattern.MasterProgram)
            for j = 1:numel(master_file)
                if strfind(master_file(j).name,DRT_GUI.Testparameter.Batterie) & strfind(master_file(j).name,Pattern.MasterProgram{Master_i}) & strfind(master_file(j).name,'Format01') & isempty(strfind(master_file(j).name,'EIS00'))
                    
                    master = load([pathname master_file(j).name]);
                    Master_Pattern = Pattern.MasterProgram{Master_i};
                    masterfound = 1;
                    break
                end
                
            end
            if masterfound, break, end
        end
        if masterfound == 0 && strcmp('Ja',questdlg('Es wurde keine Digatron-Masterdatei gefunden. Wollen Sie selbst danach suchen?', ...
            'Masterfile', ...
            'Ja','Nein','Nein'))
            
            alter_pfad = pwd;
            [filename, pathname] = uigetfile({'*.mat' 'Matlab'}, 'MasterFile wählen.', 'MultiSelect','off');
            cd(alter_pfad);
            if isempty(filename) || (~iscell(filename) && sum(filename == 0) )
                masterfound = 0;
            else
                master = load([pathname filename]);
                masterfound = 1;
            end
            if masterfound
                Master_Pattern = inputdlg('Wie lautet Ihr Master-Programm-Name?');
            end
        end
        if masterfound
            
            if isempty(find(strcmp('EISstart',fieldnames(master.diga.daten)), 1))
                EIS_Dateien = dir([pathname '*' DStringOrig '*' Master_Pattern '*EIS00*.mat']);
                for EISD_i = 1:numel(EIS_Dateien)
                    EISFile = load([pathname '/' EIS_Dateien(EISD_i).name]);
                    
                    EIS_indexes(EISD_i) = find(master.diga.daten.Programmdauer <= EISFile.diga.daten.Programmdauer(1),1,'last');
                    nach_EIS_indexes(EISD_i) = find(master.diga.daten.Programmdauer > EISFile.diga.daten.Programmdauer(end),1,'first');
                end
                EIS_index = EIS_indexes(eisnumber);
                nach_EIS_index = find(master.diga.daten.Programmdauer > messung.diga.daten.Programmdauer(end),1,'first');
            elseif ~isempty(find(diff(master.diga.daten.EISstart)>0, 1)) && numel(find(diff(master.diga.daten.EISstart)>0))>=eisnumber
                EIS_indexes = find(diff(master.diga.daten.EISstart)>0);
                EIS_index = EIS_indexes(eisnumber);
                if sum(strcmp(fieldnames(master.diga.daten),'EISready')) 
                    nach_EIS_index = EIS_index+find(master.diga.daten.EISready(EIS_index+2:end),1,'first');
                    if isempty(nach_EIS_index), nach_EIS_index = numel(master.diga.daten.EISstart); end;
                else
                    nach_EIS_index = EIS_index-2+find(master.diga.daten.EISstart(EIS_index+1:end)==0,1,'first');
                    if isempty(nach_EIS_index), nach_EIS_index = numel(master.diga.daten.EISstart); end;
                end
            else
                masterfound = 0;
            end
        end
        if masterfound
            StepIndex = [ 1 1+find(abs(diff(master.diga.daten.Schritt)) > 0) numel(master.diga.daten.Schritt)+1];
            AhPrev = 0;
            for i_step = 2:(numel(StepIndex)-1)
                    master.diga.daten.AhAkku(StepIndex(i_step):(StepIndex(i_step+1)-1)) = ...
                        AhPrev + master.diga.daten.AhAkku(StepIndex(i_step):(StepIndex(i_step+1)-1))-master.diga.daten.AhAkku(StepIndex(i_step));
                AhPrev=master.diga.daten.AhAkku(StepIndex(i_step+1)-1);
            end

            
            if isempty(find(strcmp('EISstart',fieldnames(master.diga.daten)), 1))
                Vor_EIS_index = find(master.diga.daten.AhStep(1:EIS_index)>0.01*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku)) & ...
                    abs(master.diga.daten.Strom(1:EIS_index))>0.1*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku)) & (...
                    (strcmp(master.diga.daten.Zustand(1:EIS_index),'DCH') & (master.diga.daten.AhAkku(1:EIS_index)-master.diga.daten.AhAkku(EIS_index)) > 0.01*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku))) | ... 
                    (strcmp(master.diga.daten.Zustand(1:EIS_index),'CHA') & (master.diga.daten.AhAkku(1:EIS_index)-master.diga.daten.AhAkku(EIS_index)) < -0.01*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku))) ...
                    ),1,'last');
                Start_Vor_EIS_index = find(strcmp(master.diga.daten.Zustand(1:Vor_EIS_index),'PAU'),1,'last')-5;
            else
                Vor_EIS_index = find(master.diga.daten.EISstart(1:EIS_index)==0 & master.diga.daten.AhStep(1:EIS_index)>0.01*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku)) & ...
                    abs(master.diga.daten.Strom(1:EIS_index))>0.1*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku)) & (...
                    (strcmp(master.diga.daten.Zustand(1:EIS_index),'DCH') & (master.diga.daten.AhAkku(1:EIS_index)-master.diga.daten.AhAkku(EIS_index)) > 0.01*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku))) | ... 
                    (strcmp(master.diga.daten.Zustand(1:EIS_index),'CHA') & (master.diga.daten.AhAkku(1:EIS_index)-master.diga.daten.AhAkku(EIS_index)) < -0.01*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku))) ...
                    ),1,'last');
                Start_Vor_EIS_index = find(strcmp(master.diga.daten.Zustand(1:Vor_EIS_index),'PAU'),1,'last')-5;
            end
            if isempty(find(strcmp('EISstart',fieldnames(master.diga.daten)), 1))
                Naechste_SOC_Einstellung = EIS_index+find(master.diga.daten.AhStep(EIS_index+1:end)>0.02*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku)) & ...
                    abs(master.diga.daten.Strom(EIS_index+1:end))>0.2*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku)) & (...
                    (strcmp(master.diga.daten.Zustand(EIS_index+1:end),'CHA') & (master.diga.daten.AhAkku(EIS_index+1:end)-master.diga.daten.AhAkku(EIS_index)) > 0.02*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku))) | ... 
                    (strcmp(master.diga.daten.Zustand(EIS_index+1:end),'DCH') & (master.diga.daten.AhAkku(EIS_index+1:end)-master.diga.daten.AhAkku(EIS_index)) < -0.02*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku))) ...
                    ) ,1,'first');
                Ende_Naechste_SOC_Einstellung = Naechste_SOC_Einstellung+find(strcmp(master.diga.daten.Zustand(Naechste_SOC_Einstellung+1:end),'PAU'),1,'first')-1;
            else
                Naechste_SOC_Einstellung = EIS_index+find(master.diga.daten.EISstart(EIS_index+1:end)==0 & master.diga.daten.AhStep(EIS_index+1:end)>0.02*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku)) & ...
                    abs(master.diga.daten.Strom(EIS_index+1:end))>0.2*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku)) & (...
                    (strcmp(master.diga.daten.Zustand(EIS_index+1:end),'CHA') & (master.diga.daten.AhAkku(EIS_index+1:end)-master.diga.daten.AhAkku(EIS_index)) > 0.02*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku))) | ... 
                    (strcmp(master.diga.daten.Zustand(EIS_index+1:end),'DCH') & (master.diga.daten.AhAkku(EIS_index+1:end)-master.diga.daten.AhAkku(EIS_index)) < -0.02*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku))) ...
                    ) ,1,'first');
                Ende_Naechste_SOC_Einstellung = Naechste_SOC_Einstellung+find(strcmp(master.diga.daten.Zustand(Naechste_SOC_Einstellung+1:end),'PAU'),1,'first')-1;
            end
            if ((master.diga.daten.Programmdauer(EIS_index)-master.diga.daten.Programmdauer(Vor_EIS_index)) > 1e5) || max(master.diga.daten.Programmdauer)>3600*24*200
                master.diga.daten.Programmdauer = master.diga.daten.Programmdauer/1000;
            end
            while true
                Kapazitaet = 0 ;
                steps = find([diff(master.diga.daten.AhStep(1:ceil(numel(master.diga.daten.AhStep)/4)))<0 -1] & ...
                    strcmp(master.diga.daten.Zustand(1:ceil(numel(master.diga.daten.AhStep)/4)),'DCH') & ...
                    master.diga.daten.AhStep(1:ceil(numel(master.diga.daten.AhStep)/4))>0.7*(max(master.diga.daten.AhAkku)-min(master.diga.daten.AhAkku))) ;
                for step_i = 1:numel(steps)
                    StepStart = find(master.diga.daten.Schritt(1:steps(step_i))~=master.diga.daten.Schritt(steps(step_i)),1,'last');
                    StepDuration = (master.diga.daten.Programmdauer(steps(step_i))-master.diga.daten.Programmdauer(StepStart));
                    if step_i==1 || (StepDuration<(3600*1.2+10) )
                        stepCap = str2double(num2str(master.diga.daten.AhStep(steps(step_i))));
                        if stepCap > Kapazitaet , 
                            Kapazitaet = stepCap ; 
                            KapTestIndex  = steps(step_i);
                            Index100percent = find(~strcmp(master.diga.daten.Zustand(1:KapTestIndex),'DCH'),1,'last');
%                             indexes = KapTestIndex-100:KapTestIndex+100
%                             figure;plot(master.diga.daten.Programmdauer(indexes),master.diga.daten.Strom(indexes)/7);
%                             hold on; grid on;
%                             plot(master.diga.daten.Programmdauer(indexes),master.diga.daten.Spannung(indexes),'r')
%                             plot(master.diga.daten.Programmdauer(KapTestIndex),master.diga.daten.Spannung(KapTestIndex),'ro')
%                             plot(master.diga.daten.Programmdauer(indexes),master.diga.daten.AhStep(indexes)/7,'k')
%                             plot(master.diga.daten.Programmdauer(KapTestIndex),master.diga.daten.AhStep(KapTestIndex)/7,'ko')
                        end
                        
                    end
                end
                    
                if ~get(handles.AutoCapCheckBox,'Value')
                    Kapazitaet = str2double(inputdlg('Kapazität der Zelle [Ah]','Zellkapazität',[1],{num2str(Kapazitaet)}));
                end
                choice = num2str(Kapazitaet);
                if  strcmp(choice,'') , return,end
                if ~strcmp(choice,'NaN'), break, end;
            end
            
            set(handles.KapTextBox,'String',choice)
            KapTextBox_Callback(handles.KapTextBox)
            
            
                
            %Vor_EIS_index = find(master.diga.daten.Programmdauer>master.diga.daten.Programmdauer(Vor_EIS_index)+180,1,'first');
            relax_time = master.diga.daten.Programmdauer(Start_Vor_EIS_index:EIS_index)-master.diga.daten.Programmdauer(Start_Vor_EIS_index);
            if sum(cell2mat(strfind(fieldnames(master.diga.daten),'Spannung')))
                relax_spannung = master.diga.daten.Spannung(Start_Vor_EIS_index:EIS_index);
            elseif sum(cell2mat(strfind(fieldnames(master.diga.daten),'Span')))
                relax_spannung = master.diga.daten.Span(Start_Vor_EIS_index:EIS_index);
            end
            if sum(cell2mat(strfind(fieldnames(master.diga.daten),'Strom')))
                relax_strom = master.diga.daten.Strom(Start_Vor_EIS_index:EIS_index);
            elseif sum(cell2mat(strfind(fieldnames(master.diga.daten),'Current')))
                relax_strom = master.diga.daten.Current(Start_Vor_EIS_index:EIS_index);
            end
            DRT_GUI.Messdaten.relax.zeit = relax_time;
            DRT_GUI.Messdaten.relax.spannung = relax_spannung;
            DRT_GUI.Messdaten.relax.strom = relax_strom;
            
            if isempty(find(strcmp('EISstart',fieldnames(master.diga.daten))))
                eis_time = messung.diga.daten.Programmdauer-messung.diga.daten.Programmdauer(1);
                if sum(cell2mat(strfind(fieldnames(messung.diga.daten),'Spannung')))
                    eis_spannung = messung.diga.daten.Spannung;
                elseif sum(cell2mat(strfind(fieldnames(messung.diga.daten),'Span')))
                    eis_spannung = messung.diga.daten.Span;
                end
                if sum(cell2mat(strfind(fieldnames(messung.diga.daten),'Strom')))
                    eis_strom = messung.diga.daten.Strom;
                elseif sum(cell2mat(strfind(fieldnames(messung.diga.daten),'Current')))
                    eis_strom = messung.diga.daten.Current;
                end
                DRT_GUI.Messdaten.eis.zeit = eis_time;
                DRT_GUI.Messdaten.eis.spannung = eis_spannung;
                DRT_GUI.Messdaten.eis.strom = eis_strom;
            else
                eis_time = master.diga.daten.Programmdauer(EIS_index:nach_EIS_index)-master.diga.daten.Programmdauer(EIS_index);
                if sum(cell2mat(strfind(fieldnames(master.diga.daten),'Spannung')))
                    eis_spannung = master.diga.daten.Spannung(EIS_index:nach_EIS_index);
                elseif sum(cell2mat(strfind(fieldnames(master.diga.daten),'Span')))
                    eis_spannung = master.diga.daten.Span(EIS_index:nach_EIS_index);
                end
                if sum(cell2mat(strfind(fieldnames(master.diga.daten),'Strom')))
                    eis_strom = master.diga.daten.Strom(EIS_index:nach_EIS_index);
                elseif sum(cell2mat(strfind(fieldnames(master.diga.daten),'Current')))
                    eis_strom = master.diga.daten.Current(EIS_index:nach_EIS_index);
                end
                DRT_GUI.Messdaten.eis.zeit = eis_time;
                DRT_GUI.Messdaten.eis.spannung = eis_spannung;
                DRT_GUI.Messdaten.eis.strom = eis_strom;
            end
            nach_eis_time = master.diga.daten.Programmdauer(nach_EIS_index+1:Ende_Naechste_SOC_Einstellung)-master.diga.daten.Programmdauer(nach_EIS_index+1);
            if sum(cell2mat(strfind(fieldnames(master.diga.daten),'Spannung')))
                nach_eis_spannung = master.diga.daten.Spannung(nach_EIS_index+1:Ende_Naechste_SOC_Einstellung);
            elseif sum(cell2mat(strfind(fieldnames(master.diga.daten),'Span')))
                nach_eis_spannung = master.diga.daten.Span(nach_EIS_index+1:Ende_Naechste_SOC_Einstellung);
            end
            if sum(cell2mat(strfind(fieldnames(master.diga.daten),'Strom')))
                nach_eis_strom = master.diga.daten.Strom(nach_EIS_index+1:Ende_Naechste_SOC_Einstellung);
            elseif sum(cell2mat(strfind(fieldnames(master.diga.daten),'Current')))
                nach_eis_strom = master.diga.daten.Current(nach_EIS_index+1:Ende_Naechste_SOC_Einstellung);
            end
            DRT_GUI.Messdaten.nach_eis.zeit = nach_eis_time;
            DRT_GUI.Messdaten.nach_eis.spannung = nach_eis_spannung;
            DRT_GUI.Messdaten.nach_eis.strom = nach_eis_strom;
            
            if isempty(find(strcmp('EISstart',fieldnames(master.diga.daten)))) 
                if eisnumber == 1
                    Prev_EIS_index = 1;
                else
                    Prev_EIS_index = nach_EIS_indexes(eisnumber-1);
                end
  
                
                vor_relax_time = master.diga.daten.Programmdauer(Prev_EIS_index:Start_Vor_EIS_index)-master.diga.daten.Programmdauer(Prev_EIS_index);
                if sum(cell2mat(strfind(fieldnames(master.diga.daten),'Spannung')))
                    vor_relax_spannung = master.diga.daten.Spannung(Prev_EIS_index:Start_Vor_EIS_index);
                elseif sum(cell2mat(strfind(fieldnames(master.diga.daten),'Span')))
                    vor_relax_spannung = master.diga.daten.Span(Prev_EIS_index:Start_Vor_EIS_index);
                end
                if sum(cell2mat(strfind(fieldnames(master.diga.daten),'Strom')))
                    vor_relax_strom = master.diga.daten.Strom(Prev_EIS_index:Start_Vor_EIS_index);
                elseif sum(cell2mat(strfind(fieldnames(master.diga.daten),'Current')))
                    vor_relax_strom = master.diga.daten.Current(Prev_EIS_index:Start_Vor_EIS_index);
                end
                DRT_GUI.Messdaten.vor_relax.zeit = vor_relax_time;
                DRT_GUI.Messdaten.vor_relax.spannung = vor_relax_spannung;
                DRT_GUI.Messdaten.vor_relax.strom = vor_relax_strom;
            elseif sum(strcmp(fieldnames(master.diga.daten),'EISready'))
                if eisnumber == 1
                    Prev_EIS_index = 1;
                else
                    Prev_EIS_index = EIS_indexes(eisnumber-1);
                end
                Prev_EIS_index = Prev_EIS_index+find(master.diga.daten.EISready(Prev_EIS_index+2:end),1,'first');
                
                vor_relax_time = master.diga.daten.Programmdauer(Prev_EIS_index:Start_Vor_EIS_index)-master.diga.daten.Programmdauer(Prev_EIS_index);
                if sum(cell2mat(strfind(fieldnames(master.diga.daten),'Spannung')))
                    vor_relax_spannung = master.diga.daten.Spannung(Prev_EIS_index:Start_Vor_EIS_index);
                elseif sum(cell2mat(strfind(fieldnames(master.diga.daten),'Span')))
                    vor_relax_spannung = master.diga.daten.Span(Prev_EIS_index:Start_Vor_EIS_index);
                end
                if sum(cell2mat(strfind(fieldnames(master.diga.daten),'Strom')))
                    vor_relax_strom = master.diga.daten.Strom(Prev_EIS_index:Start_Vor_EIS_index);
                elseif sum(cell2mat(strfind(fieldnames(master.diga.daten),'Current')))
                    vor_relax_strom = master.diga.daten.Current(Prev_EIS_index:Start_Vor_EIS_index);
                end
                DRT_GUI.Messdaten.vor_relax.zeit = vor_relax_time;
                DRT_GUI.Messdaten.vor_relax.spannung = vor_relax_spannung;
                DRT_GUI.Messdaten.vor_relax.strom = vor_relax_strom;
            end
            % Überlagerten DC-Strom berechnen
            DC_Current = sum(diff(DRT_GUI.Messdaten.eis.zeit).*DRT_GUI.Messdaten.eis.strom(2:end))./sum(diff(DRT_GUI.Messdaten.eis.zeit));
            
            if sum(cell2mat(strfind(fieldnames(master.diga.daten),'Strom')))
                strom = master.diga.daten.Strom;
            elseif sum(cell2mat(strfind(fieldnames(master.diga.daten),'Current')))
                strom = master.diga.daten.Current;
            end
            
            %TestAhAkku = [0 cumsum(diff(master.diga.daten.Programmdauer/3600).*strom(1:end-1))];
            
            if Index100percent == -1
                AhAkku_werte = master.diga.daten.AhAkku(EIS_indexes)-max(master.diga.daten.AhAkku);
            else
                AhAkku_werte = master.diga.daten.AhAkku(EIS_indexes)-master.diga.daten.AhAkku(Index100percent);
            end
            SOC = round((DRT_GUI.Testparameter.Cap + AhAkku_werte(eisnumber))/DRT_GUI.Testparameter.Cap *100*10)/10;
            SOCfound = 1;
            set(handles.SOCTextBox,'String',num2str(SOC));
            SOCTextBox_Callback(handles.SOCTextBox);
            
            
            
            %                 p_init = [1000 40 relax_spannung(1) (relax_spannung(end)-relax_spannung(1))/2 (relax_spannung(end)-relax_spannung(1))/2];
            %                 modelformel = 'p(3)+p(4).*exp(-w./p(1))+p(5).*exp(-w./p(2))';
            %                 options = optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-12,'TolFun',1e-12);
            %                 [p,fval,exitflag,output]=function_fit_easyfit2(relax_time,[relax_spannung, zeros(size(relax_spannung))],p_init,@function_model_all_types2, [0 0 -inf -inf -inf], [inf,inf,inf,inf,inf] ,options, modelformel);
            %                 figure;
            %                     %plot(relax_time,relax_spannung,relax_time,relax_strom)
            %                     plot(relax_time,relax_spannung,'o')
            %                     hold on
            %                     w = relax_time;
            %                     fit_spannung = eval(modelformel);
            %                     plot(relax_time,fit_spannung,'r')
            %                     title({'Relaxationsvorgang vor der Messung',['tau1=' num2str(p(1)) ' s    tau2=' num2str(p(2)) 's']})
            clear master
            
        end
        
        
    end
    if ~SOCfound
        while true
            SOC = str2double(inputdlg('SOC','SOC',[1],{'25'}));
            choice = num2str(SOC);
            if  strcmp(choice,'') , return,end
            if ~strcmp(choice,'NaN'), break, end;
        end
        set(handles.SOCTextBox,'String',choice)
        SOCTextBox_Callback(handles.SOCTextBox)
        SOCfound = 1;
    end
    if ~Batteriefound
        while true
            BatterieName = inputdlg('BatterieName','Name',[1],{'Dummy'});
            choice = BatterieName;
            if  isempty(choice) ||strcmp(choice,'') , return,end
            if ~strcmp(choice,'NaN'), break, end;
        end
        set(handles.BatterieTextBox,'String',choice);
        BatterieTextBox_Callback(handles.BatterieTextBox);
        Batteriefound = 1;
    end
    DRT_GUI.Messdaten.DC_Overlay = DC_Current;
    
    clear messung
    
    if ~isempty(find(strcmp(fieldnames(DRT_GUI.Messdaten),'DC_Overlay'),1)) && ~isempty(find(strcmp(fieldnames(DRT_GUI.Testparameter),'Cap'),1))
        if ~isempty(DRT_GUI.Testparameter.Zustand)
            DRT_GUI.Testparameter.Zustand = [DRT_GUI.Testparameter.Zustand '_' ];
        end
        Rounded_Current = round(4*DRT_GUI.Messdaten.DC_Overlay./DRT_GUI.Testparameter.Cap)/4;
        if Rounded_Current == 0 && DRT_GUI.Messdaten.DC_Overlay > 0.01
            Rounded_Current_Str= 'p0C_DC';
        elseif Rounded_Current == 0 && DRT_GUI.Messdaten.DC_Overlay < -0.01
            Rounded_Current_Str= 'm0C_DC';
        else
            Rounded_Current_Str= [strrep(num2str(Rounded_Current),'-','m') 'C_DC'];
        end
        DRT_GUI.Testparameter.Zustand = [DRT_GUI.Testparameter.Zustand Rounded_Current_Str];
    end
    
    set(handles.fminTextBox,'String',min(DRT_GUI.Messdaten.frequenz))
    set(handles.fmaxTextBox,'String',max(DRT_GUI.Messdaten.frequenz))
    set(handles.MessPunkteTextBox,'String',numel(DRT_GUI.Messdaten.frequenz))
    
    if mean(DRT_GUI.Messdaten.Zreal)>0.1 && strcmp(filename(end-3:end),'.mat')
        DRT_GUI.Messdaten.Zreal = DRT_GUI.Messdaten.Zreal/1000;
        DRT_GUI.Messdaten.Zimg = DRT_GUI.Messdaten.Zimg/1000;
    end
    DRT_GUI.Messdaten.Z = DRT_GUI.Messdaten.Zreal + 1i .* DRT_GUI.Messdaten.Zimg;
    
    
    Typ = 'Nyquist';
    if ~strcmp(eventdata, 'kein_plot')
        axes(handles.axes1); hold off;
        plot_Auswaehl(DRT_GUI.Messdaten,[],[],DRT_GUI.Testparameter.Batterie,Typ);
    else
    end
    
    
    ModellAktualisierenButton_Callback(handles.ModellAktualisierenButton,eventdata,handles)
    DRT_Config_Reload_Button_Callback(handles.DRT_Config_Reload_Button, eventdata,handles)
    set(handles.PunkteWegnehmenTextBox,'string','')
    PunkteWegnehmenButton_Callback(handles.PunkteWegnehmenButton, eventdata, handles)
    % HFcorrectionButton_Callback(handles.InitHF_FittButton,eventdata,handles)
    
    PasteButton_Callback(handles.PasteButton,eventdata,handles)
    set(handles.GueltigeMessungCheck,'value',1)
    GueltigeMessungCheck_Callback(handles.GueltigeMessungCheck, eventdata,handles)
    FitButton_Callback(handles.FitButton, eventdata,handles)
    %FitButton_Callback(handles.FitButton, eventdata,handles)
    DRTButton_Callback(handles.DRTButton, eventdata,handles)
    CopyButton_Callback(handles.CopyButton,eventdata,handles)
    if isempty(cell2mat(strfind(fieldnames(DRT_GUI.Testparameter),'Zustand'))) || isempty(DRT_GUI.Testparameter.Zustand)
        DRT_GUI.Testparameter.Zustand = 'default';
        set(handles.ZustandTextBox,'string','default')
    end
    
    choice = 'Ja';
    pfad = ['output' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad/' ...
        DRT_GUI.Testparameter.Batterie '_' DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_' [strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m')] 'SOC.mat'];
    if iscell(pfad) , pfad = cell2mat(pfad);end
    if ~isempty(dir(pfad))
        choice = questdlg('Die Datei existiert bereits. Soll sie überschrieben werden?', ...
            'Überschreiben', ...
            'Ja','Nein','Nein');
    end
    if strcmp(choice,'Ja')
        SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)
    end
end




function PunkteWegnehmenTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to PunkteWegnehmenTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PunkteWegnehmenTextBox as text
%        str2double(get(hObject,'String')) returns contents of PunkteWegnehmenTextBox as a double


% --- Executes during object creation, after setting all properties.
function PunkteWegnehmenTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PunkteWegnehmenTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PunkteWegnehmenButton.
function PunkteWegnehmenButton_Callback(hObject, eventdata, handles)
% hObject    handle to PunkteWegnehmenButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;

if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten'))) || isempty(DRT_GUI.Messdaten)
    return
end

Typ = 'Nyquist';
if ~strcmp(eventdata,'kein_plot')
    axes(handles.axes1); hold off;
    plot_Auswaehl(DRT_GUI.Messdaten,[],[],DRT_GUI.Testparameter.Batterie,Typ);
else
end


LP_str = get(handles.PunkteWegnehmenTextBox,'string');

DRT_GUI.Messdaten.aktiv = ones(size(DRT_GUI.Messdaten.Z));
if ~isempty(get(handles.PunkteWegnehmenTextBox,'string'))
    eval(['DRT_GUI.Messdaten.aktiv([' LP_str ']) = 0;']);
end
DRT_GUI.Messdaten.low_Punkte_Weg = LP_str;
Typ = 'Messung';

% neu plot
if ~strcmp(eventdata, 'kein_plot')
    axes(handles.axes1); hold off;
    plot_Auswaehl(DRT_GUI.Messdaten,[],[],DRT_GUI.Testparameter.Batterie,Typ);
else
end

function ModellFormelTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to ModellFormelTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ModellFormelTextBox as text
%        str2double(get(hObject,'String')) returns contents of ModellFormelTextBox as a double

% --- Executes during object creation, after setting all properties.
function ModellFormelTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModellFormelTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ModellAktualisierenButton.
function ModellAktualisierenButton_Callback(hObject, eventdata, handles)
% hObject    handle to ModellAktualisierenButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Modell in Popmenu aktualisieren
global Modellliste
global DRT_GUI
config;
getModellname_temp = size(Modellliste.Modell);
for getModellname_i = 1:getModellname_temp(1)
    getModellname{getModellname_i,1} = Modellliste.Modell{getModellname_i,1};
end
set(handles.ModellAuswahlPopup,'String',getModellname);
if ~isempty(DRT_GUI) && sum(ismember(fieldnames(DRT_GUI),'Fit')) &&  ~isempty(DRT_GUI.Fit) && sum(ismember(fieldnames(DRT_GUI.Fit),'aktuell_Modell')) &&  ~isempty(DRT_GUI.Fit.aktuell_Modell) &&  sum(ismember(fieldnames(DRT_GUI.Fit.aktuell_Modell),'Modellname'))
    akt_index = find(ismember(getModellname,DRT_GUI.Fit.aktuell_Modell.Modellname));
    if isempty(akt_index)
        akt_index = numel(getModellname)+1;
        getModellname{akt_index} = DRT_GUI.Fit.aktuell_Modell.Modellname;
        set(handles.ModellAuswahlPopup,'string',getModellname);
        Modellliste.Modell(akt_index,1:numel(DRT_GUI.Fit.aktuell_Modell.ModellCell)) = DRT_GUI.Fit.aktuell_Modell.ModellCell;
    end
else
    akt_index = Modellliste.standard_modell;
end

set(handles.ModellAuswahlPopup,'value',akt_index)
ModellAuswahlPopup_Callback(handles.ModellAuswahlPopup, eventdata, handles)

% --- Executes on selection change in ModellAuswahlPopup.
function ModellAuswahlPopup_Callback(hObject, eventdata, handles)
% hObject    handle to ModellAuswahlPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ModellAuswahlPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ModellAuswahlPopup

%%% Modell auswählen
global DRT_GUI;
global Modellliste;
if isempty(DRT_GUI) || ~sum(ismember(fieldnames(DRT_GUI),'Messdaten'))
    return
end

value = get(hObject,'value');
if isempty(value), value=1;end
set(handles.ModellFormelTextBox,'string', Modellliste.Modell{value,2});


aktuell_Modell_P_str = textscan(strrep(Modellliste.Modell{value,3},' ',''),'%s','delimiter',',');
aktuell_Modell = Modellliste.Modell(value,:);

if ismember('Fit',fieldnames(DRT_GUI)) 
    oldFit = DRT_GUI.Fit;
else
    oldFit=[];
end

DRT_GUI.Fit.aktuell_Modell = [];

if isempty(DRT_GUI.Fit) || ~sum(ismember(fieldnames(DRT_GUI.Fit),'Parameter')) || isempty(DRT_GUI.Fit.Parameter) || numel(DRT_GUI.Fit.Parameter) ~= length(aktuell_Modell_P_str{1,1})
    DRT_GUI.Fit.Parameter = zeros(1,length(aktuell_Modell_P_str{1,1})); % für p_best
    DRT_GUI.Fit.Parameter_min = zeros(1,length(aktuell_Modell_P_str{1,1})); % für p_best
    DRT_GUI.Fit.Parameter_max = zeros(1,length(aktuell_Modell_P_str{1,1})); % für p_best
    DRT_GUI.Fit.gueltig = 0;
    DRT_GUI.Fit.Grenzenautomatik = 0;
    DRT_GUI.Fit.GrenzenBandbreite = zeros(numel(DRT_GUI.Fit.Parameter),2);
    
end
if ~sum(ismember(fieldnames(DRT_GUI.Fit),'gueltig')),DRT_GUI.Fit.gueltig = 0;end
if ~sum(ismember(fieldnames(DRT_GUI.Fit),'Grenzenautomatik')),DRT_GUI.Fit.Grenzenautomatik = 0;end
if ~sum(ismember(fieldnames(DRT_GUI.Fit),'GrenzenBandbreite')),DRT_GUI.Fit.GrenzenBandbreite = zeros(numel(DRT_GUI.Fit.Parameter),2);end

set(handles.GueltigeMessungCheck,'value',DRT_GUI.Fit.gueltig)
if sum(DRT_GUI.Fit.GrenzenBandbreite(:))~=0
    set(handles.GrenzenBandbreiteText,'string',[num2str(max(DRT_GUI.Fit.GrenzenBandbreite(:))*100) '%'])
else
    set(handles.GrenzenBandbreiteText,'string','')
end
% Die entsprechenden Parameter in Tabelle abgeben
DRT_GUI.Fit.aktuell_Modell.Modellname = Modellliste.Modell{value,1};  % name
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell = Modellliste.Modell{value,2};  % Formel, später mit p(0)..p(n) umschreiben
DRT_GUI.Fit.aktuell_Modell.ModellCell = Modellliste.Modell(value,:);
p_best = DRT_GUI.Fit.Parameter;
p_min = DRT_GUI.Fit.Parameter_min;
p_max = DRT_GUI.Fit.Parameter_max;
p_min_model = cell2mat(DRT_GUI.Fit.aktuell_Modell.ModellCell{5});
p_max_model = cell2mat(DRT_GUI.Fit.aktuell_Modell.ModellCell{6});
index = find((p_best<=p_min*1.001 & p_min~=p_max & p_min~=p_min_model )  |...
    (p_best>=p_max*0.999 & p_min~=p_max & p_max~=p_max_model ));

% die Parameter in Feld gezeigt und mit p(0)..p(i) abbilden
TableCell = cell(length(aktuell_Modell_P_str{1,1}),6);

for aktuell_Modell_P_i = 1: length(aktuell_Modell_P_str{1,1})
    P_Name = aktuell_Modell_P_str{1,1}{aktuell_Modell_P_i,1};
    DRT_GUI.Fit.aktuell_Modell.P_Name{1,aktuell_Modell_P_i} = P_Name;
    Par_temp = strcat('handles.Par',num2str(aktuell_Modell_P_i));
    TableCell{aktuell_Modell_P_i,1} = P_Name;
    
    
    
    if numel(find(DRT_GUI.Fit.Parameter~=0))==0
        TableCell{aktuell_Modell_P_i,3} = cell2mat(aktuell_Modell{4}(aktuell_Modell_P_i));
        TableCell{aktuell_Modell_P_i,4} = cell2mat(aktuell_Modell{5}(aktuell_Modell_P_i));
        TableCell{aktuell_Modell_P_i,5} = cell2mat(aktuell_Modell{6}(aktuell_Modell_P_i));
        if ~isempty(aktuell_Modell{7})
            TableCell{aktuell_Modell_P_i,2} = logical(cell2mat(aktuell_Modell{7}(aktuell_Modell_P_i)));
            
        else
            TableCell{aktuell_Modell_P_i,2} = false;
        end
    else
        TableCell{aktuell_Modell_P_i,3} = DRT_GUI.Fit.Parameter(aktuell_Modell_P_i);
        TableCell{aktuell_Modell_P_i,4} = DRT_GUI.Fit.Parameter_min(aktuell_Modell_P_i);
        TableCell{aktuell_Modell_P_i,5} = DRT_GUI.Fit.Parameter_max(aktuell_Modell_P_i);
        TableCell{aktuell_Modell_P_i,2} = logical(DRT_GUI.Fit.ParFix(aktuell_Modell_P_i));
    end
    if ~isempty(find(index==aktuell_Modell_P_i,1,'first'))
        TableCell{aktuell_Modell_P_i,6} = true;
    else
        TableCell{aktuell_Modell_P_i,6} = false;
    end

    if ~isempty(oldFit) && ismember(P_Name,oldFit.aktuell_Modell.P_Name(1,:)) && ~strcmp(oldFit.aktuell_Modell.Modellname,DRT_GUI.Fit.aktuell_Modell.Modellname)
        OldIndex = find(strcmp(oldFit.aktuell_Modell.P_Name(1,:),P_Name),1,'first');
        TableCell{aktuell_Modell_P_i,3} = oldFit.Parameter(OldIndex);
        TableCell{aktuell_Modell_P_i,4} = oldFit.Parameter_min(OldIndex);
        TableCell{aktuell_Modell_P_i,5} = oldFit.Parameter_max(OldIndex);
        if numel(oldFit.ParFix)>=OldIndex
            TableCell{aktuell_Modell_P_i,2} = logical(oldFit.ParFix(OldIndex));
        end
    end
    % Formel für Rechnen umschreiben
    neu_P = strcat('p(',num2str(aktuell_Modell_P_i),')');
    DRT_GUI.Fit.aktuell_Modell.P_Name{2,aktuell_Modell_P_i} = neu_P;
    DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell = strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell,P_Name,neu_P);
end
set(handles.ParamTable,'Data',TableCell)

DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_komp=DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell;
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_komp= strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_komp,'HF','0');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_komp = strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_komp,'LF','0');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_komp = strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_komp,'MF','1');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_HF=DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell;
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_HF= strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_HF,'HF','1');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_HF = strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_HF,'LF','0');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_HF = strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_HF,'MF','0');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_MF=DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell;
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_MF= strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_MF,'HF','0');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_MF = strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_MF,'LF','0');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_MF = strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_MF,'MF','1');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_LF=DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell;
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_LF= strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_LF,'HF','0');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_LF = strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_LF,'LF','1');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_LF = strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_LF,'MF','0');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell      = strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell,'HF','1');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell      = strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell,'LF','1');
DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell      = strrep(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell,'MF','1');

for aktuell_Modell_P_i = 1:length(aktuell_Modell_P_str{1,1})

end

if ~sum(ismember(fieldnames(DRT_GUI.Fit),'Implementierung')) || isempty(DRT_GUI.Fit.Implementierung) || ~sum(ismember(fieldnames(DRT_GUI.Fit.Implementierung),'Table')) || isempty(DRT_GUI.Fit.Implementierung.Table) || size(DRT_GUI.Fit.Implementierung.Table,1)==1
    Implementierung_Neu_Laden
else
    Mismatch=0;
    for i = 1:size(DRT_GUI.Fit.Implementierung.Table,1)-1
        for j = 5:size(DRT_GUI.Fit.Implementierung.Table,2)
            if ~isempty(DRT_GUI.Fit.Implementierung.Table{i,j}) && isempty(find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:) ,  DRT_GUI.Fit.Implementierung.Table{i,j}),1))
                Implementierung_Neu_Laden
                Mismatch = 1;
                break
            end
        end
        if Mismatch , break, end
    end
end

function Implementierung_Neu_Laden
global DRT_GUI

if numel(DRT_GUI.Fit.aktuell_Modell.ModellCell)<8 || isempty(DRT_GUI.Fit.aktuell_Modell.ModellCell{8})
    DRT_GUI.Fit.Implementierung=[];
    return

end

Modell=DRT_GUI.Fit.aktuell_Modell.ModellCell{8};

DRT_GUI.Fit.Implementierung.Table=cell(numel(Modell)+1,5);
DRT_GUI.Fit.Implementierung.Info=cell(numel(Modell)+1,1);

for i = 1:numel(Modell)
    TableZeile=[];
    if ismember('f',fieldnames(Modell{i})), 
        Funktionsname = func2str(Modell{i}.f)    ;
        index = strfind(Funktionsname,'/');
        if ~isempty(index),Funktionsname = Funktionsname(index(end)+1:end); end
    else
        Funktionsname = Modell{i}.Funktionsname;
    end
    TableZeile{1}= Funktionsname;
    TableZeile{2}='';
    TableZeile{3}=0;
    TableZeile{4}=0;
    for j=1:numel(Modell{i}.inputs);
        TableZeile{4+j}=Modell{i}.inputs{j};
    end
    DRT_GUI.Fit.Implementierung.Table(i,1:numel(TableZeile))=TableZeile;
    DRT_GUI.Fit.Implementierung.Info{i,1}=Modell{i};
end
DRT_GUI.Fit.Implementierung.Table(size(DRT_GUI.Fit.Implementierung.Table,1),1:size(DRT_GUI.Fit.Implementierung.Table,2))={''};
global Modellliste


% --- Executes during object creation, after setting all properties.
function ModellAuswahlPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModellAuswahlPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Fit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [akt_P_out std_P_out]=getInitWerte(handles,tempFit)


Folders = {};
BatterieName = get(handles.BatterieTextBox,'string');
if iscell(BatterieName),BatterieName = BatterieName{1}; end
NonDigit = regexp(BatterieName,'\D');
if iscell(NonDigit),NonDigit = NonDigit{1}; end
BatterieTyp = BatterieName(1:NonDigit(end));
if BatterieTyp(end)=='_' , BatterieTyp = BatterieTyp(1:end-1); end
Zustand = get(handles.ZustandTextBox,'string');
akt_SOC = str2num(get(handles.SOCTextBox,'string'));
akt_T = str2num(get(handles.TemperaturTextBox,'string'));

Batterien = {};

if isempty(Zustand ), Zustand = 'default'; end
f = dir(['output/' BatterieTyp '*']);
for i = 1:numel(f)
    if ~strcmp(f(i).name,'.') && ~strcmp(f(i).name,'..') && f(i).isdir
        Batterien = [Batterien;f(i).name];
    end
end
for j = 1:numel(Batterien)
    f = dir(['output/' Batterien{j} '/'  Zustand '/*grad']);
    for i = 1:numel(f)
        if ~strcmp(f(i).name,'.') && ~strcmp(f(i).name,'..') && f(i).isdir
            if isempty(Folders) | ~ismember(Folders,f(i).name)
                Folders = [Folders;f(i).name];
            end
        end
    end
end
Temperaturen = zeros(size(Folders));
SOCs = [];
SOCFiles = {};
for i = 1:numel(Folders)
    Temperaturen(i) = str2num(strrep(strrep(Folders{i},'grad',''),'m','-'));
    for k = 1:numel(Batterien)
        f = dir(['output/' Batterien{k} '/'  Zustand '/' Folders{i} '/*_*SOC_Modell.mat']);
        for j = 1:numel(f)
            if ~strcmp(f(j).name,'.') && ~strcmp(f(j).name,'..') && ~f(j).isdir
                SOCFiles = [SOCFiles;strrep(strrep(strrep(strrep(strrep(f(j).name,Folders{i},''),Batterien{k} ,''),  Zustand,''),'_',''),'Modell.mat','')];
            end
        end
    end
end
for j = 1:numel(SOCFiles)
    if ~sum(find(SOCs == str2num(strrep(strrep(SOCFiles{j},'SOC',''),'m','-'))))
        SOCs = [SOCs ; str2num(strrep(strrep(SOCFiles{j},'SOC',''),'m','-'))];
    end
end

Temperaturen = sort(Temperaturen,1);
SOCs = sort(SOCs,1);
akt_x(1,1) = (akt_T - min(Temperaturen) ) / (max(Temperaturen) - min(Temperaturen));
akt_x(1,2) = (akt_SOC - min(SOCs) ) / (max(SOCs) - min(SOCs));

FitStruct = struct([]);

for batnr = 1:numel(Batterien)
    for i = 1:numel(Temperaturen)
        for j = 1:numel(SOCs)
            TString = [strrep(num2str(Temperaturen(i)),'-','m') 'grad'];
            SOCString = [strrep(num2str(SOCs(j)),'-','m') 'SOC'];
            f = dir(['output/' Batterien{batnr} '/'  Zustand '/' TString '/*_' SOCString '_Modell.mat']);
            if ~isempty(f)
                tempModel = load(['output/' Batterien{batnr} '/'  Zustand '/' TString '/' f.name]);
                if ~isempty(tempModel) && sum(ismember(fieldnames(tempModel),'Fit'))
                    tempModel = tempModel.Fit;
                    if ~isempty(tempModel) &&  strcmp(tempModel.Modell.Modellname,tempFit.aktuell_Modell.Modellname) &&...
                            numel(tempModel.Parameter) == numel(tempFit.Parameter) && sum(ismember(fieldnames(tempModel),'gueltig')) && tempModel.gueltig &&...
                            ~(strcmp(Batterien{batnr},BatterieName) && Temperaturen(i)== akt_T && SOCs(j)==akt_SOC)
                        FitStruct(numel(FitStruct)+1).Batterie = Batterien{batnr};
                        FitStruct(end).x(1,1) = (Temperaturen(i) - min(Temperaturen) ) / (max(Temperaturen) - min(Temperaturen));
                        FitStruct(end).x(1,2) = (SOCs(j) - min(SOCs) ) / (max(SOCs) - min(SOCs));
                        FitStruct(end).Temperatur = Temperaturen(i);
                        FitStruct(end).SOC = SOCs(j);
                        FitStruct(end).Parameter = tempModel.Parameter;
                        FitStruct(end).Distance = sqrt(sum((akt_x-FitStruct(end).x).^2));
                    end
                end
            end
            
        end
    end
end
if isempty(FitStruct)
    akt_P_out=[]; std_P_out=[];
    return
end
distances = cell2mat({(FitStruct(:).Distance)});
sorted_distances = sort(distances);
if numel(FitStruct)>9
    FitStruct = FitStruct(distances <= sorted_distances(ceil(numel(distances)*0.6)));
end
distances = cell2mat({(FitStruct(:).Distance)});
if numel(distances)>5 , nachbaranzahl = 5; else  nachbaranzahl = numel(distances)-1;end
if nachbaranzahl<1,
    akt_P_out=[]; std_P_out=[];
    
    return,
end
sorted_distances = sort(distances);
closest = find(distances <= sorted_distances(nachbaranzahl));

% Gradient y(x) an der stelle x0 (gesuchter Zustand) berechnen
for p = 1:numel(tempFit.Parameter)
    y=[];  dist=[]; SOC_y = []; T_y=[]; guete = [];
    for k = 1:numel(FitStruct)
        A=[];b=[];
        for c = closest
            if c == k, continue,end
            A(end+1,:) = (FitStruct(c).x-FitStruct(k).x) ...
                .* 10000.^-FitStruct(c).Distance;
            b(end+1,:) = (FitStruct(c).Parameter(p)-FitStruct(k).Parameter(p)) .* 10000.^-FitStruct(c).Distance;
        end
        for i = 1:size(A,2)
            if isempty(find(A(:,i)~=0))
                A(end+1,:) = [zeros(1,i-1) 1 zeros(1,size(A,2)-i)];
                b(end+1,:) = 0;
            end
        end
        gradY = A\b;
        if isempty(gradY),continue,end
        y(end+1,1) = FitStruct(k).Parameter(p)+(akt_x-FitStruct(k).x)*gradY;
        dist(end+1,1) = FitStruct(k).Distance;
        SOC_y(end+1,1) = FitStruct(k).SOC;
        T_y(end+1,1) = FitStruct(k).Temperatur;
        guete(end+1,1) = 10000^-FitStruct(k).Distance;
        if y(end) < tempFit.aktuell_Modell.ModellCell{5}{p} || y(end) > tempFit.aktuell_Modell.ModellCell{6}{p}
            y(end) = [];
            dist(end) = [];
            guete(end) = [];
            SOC_y(end) = [];
            T_y(end) = [];
        end
    end
    % num2cell([y dist guete./sum(guete)*100 SOC_y T_y])
    y0=sum(y.*(10000.^-dist))/sum(10000.^-dist);
    akt_P_out(p) = y0;
    alle_P = cell2mat({FitStruct.Parameter}');
    std_P_out(p) = std(alle_P(:,p));
    
end



% --- Executes on button press in FitButton.
function FitButton_Callback(hObject, eventdata, handles)
% hObject    handle to FitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Fit
global DRT_GUI;

if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten')))
    return
end



formula = DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell;
if  isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) || isempty(DRT_GUI.Messdaten.relax_fft)
    m_w = DRT_GUI.Messdaten.omega(DRT_GUI.Messdaten.aktiv==1) ;
    m_real = DRT_GUI.Messdaten.Zreal(DRT_GUI.Messdaten.aktiv==1);
    m_imag = DRT_GUI.Messdaten.Zimg(DRT_GUI.Messdaten.aktiv==1);
else
    m_w = [DRT_GUI.Messdaten.omega(DRT_GUI.Messdaten.aktiv==1) ; DRT_GUI.Messdaten.relax_fft.omega(DRT_GUI.Messdaten.relax_fft.aktiv==1)] ;
    m_real = [DRT_GUI.Messdaten.Zreal(DRT_GUI.Messdaten.aktiv==1); DRT_GUI.Messdaten.relax_fft.Zreal(DRT_GUI.Messdaten.relax_fft.aktiv==1)+DRT_GUI.Messdaten.relax_fft.Zreal_korrektur];
    m_imag = [DRT_GUI.Messdaten.Zimg(DRT_GUI.Messdaten.aktiv==1); DRT_GUI.Messdaten.relax_fft.Zimg(DRT_GUI.Messdaten.relax_fft.aktiv==1)];
end
TableCell = get(handles.ParamTable,'Data');
TableCell = cell2struct(TableCell',{'Name','Fix','Value','Min','Max','Lim'});


% die initialisierte Werte aus Feld bekommen
DRT_GUI.Fit.ParFix = zeros(size(DRT_GUI.Fit.Parameter));
for Par_init_i = 1:length(DRT_GUI.Fit.Parameter)
    
    
    if ~isempty(TableCell(Par_init_i).Value)
        DRT_GUI.Fit.Parameter(Par_init_i) = TableCell(Par_init_i).Value;
    else
        DRT_GUI.Fit.Parameter(Par_init_i) = 0;
        TableCell(Par_init_i).Value = 0;
    end
    
    if ~isempty(TableCell(Par_init_i).Min) && ~TableCell(Par_init_i).Fix
        p_min(Par_init_i)= TableCell(Par_init_i).Min;
    elseif TableCell(Par_init_i).Fix
        DRT_GUI.Fit.ParFix(Par_init_i) = 1 ;
        p_min(Par_init_i) = TableCell(Par_init_i).Value;
    else
        p_min(Par_init_i) = 0;
        TableCell(Par_init_i).Min = 0 ;
    end
    if ~isempty(TableCell(Par_init_i).Min)
        DRT_GUI.Fit.Parameter_min(Par_init_i) = TableCell(Par_init_i).Min;
    else
        DRT_GUI.Fit.Parameter_min(Par_init_i) = 0;
    end
    if ~isempty(TableCell(Par_init_i).Max) && ~TableCell(Par_init_i).Fix
        p_max(Par_init_i)= TableCell(Par_init_i).Max;
    elseif TableCell(Par_init_i).Fix
        p_max(Par_init_i) = TableCell(Par_init_i).Value;
    else
        p_max(Par_init_i) = inf;
        TableCell(Par_init_i).Max = Inf;
    end
    if ~isempty(TableCell(Par_init_i).Max)
        DRT_GUI.Fit.Parameter_max(Par_init_i) = TableCell(Par_init_i).Max;
    else
        DRT_GUI.Fit.Parameter_max(Par_init_i) = inf;
    end
end

p_init = DRT_GUI.Fit.Parameter;
if strcmp(get(handles.MetaFitButton,'String'),'Stop') || get(handles.cont_process_checkbox,'Value')
    options = optimset('MaxIter',20000,'MaxFunEvals',20000,'TolX',1e-8,'TolFun',1e-8,'display','final');
else
    options = optimset('MaxIter',20000,'MaxFunEvals',20000,'TolX',1e-8,'TolFun',1e-8,'display','final');
end
p_min_model = cell2mat(DRT_GUI.Fit.aktuell_Modell.ModellCell{5});
p_max_model = cell2mat(DRT_GUI.Fit.aktuell_Modell.ModellCell{6});
set(handles.ParamTable,'Data',struct2cell(TableCell)')

[p_best,fval,exitflag,output]=function_fit_easyfit2(m_w,[m_real, m_imag],p_init,@function_model_all_types2, p_min, p_max ,options, formula);
index_min = find((p_best<=p_min*1.001 & p_min~=p_max & p_min~=p_min_model & ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Rser') & ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'C')& ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Cser')& ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Kskin')& ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Lser')));
index_max = find((p_best>=p_max*0.999 & p_min~=p_max & p_max~=p_max_model & ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Rser') & ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'C')& ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Cser')& ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Kskin')& ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Lser')));

DRT_GUI.Fit.Parameter = p_best;
DRT_GUI.Fit.Limit_Reached.index_min = index_min;
DRT_GUI.Fit.Limit_Reached.index_max = index_max;

% die Fittwerte(p-best) in Feld zeigen
for P_i = 1:length(p_best)
    
    TableCell(P_i).Value = p_best(P_i);
    if ~isempty(find([index_min index_max]==P_i,1,'first'))
        TableCell(P_i).Lim = true;
    else
        TableCell(P_i).Lim = false;
    end
end
TableCell = struct2cell(TableCell)';
set(handles.ParamTable,'Data',TableCell)




PlotFittedParametersButton_Callback(handles.PlotFittedParametersButton, eventdata, handles)
if get(handles.FitPlusSaveCheckbox,'value')
    
    if  isempty(cell2mat(strfind(fieldnames(handles),'mhandles')))
        Modelhandle = model;
        handles.mhandles = guidata(Modelhandle);
        guidata(hObject,handles)
        handles.mhandles.aktualisieren_button_Callback(handles.mhandles.aktualisieren_button,eventdata,handles.mhandles);
    end
    DRTButton_Callback(handles.DRTButton,eventdata,handles)
    SpeichernButton_Callback(handles.SpeichernButton, eventdata, handles)
    
    handles.mhandles.ReloadButton_Callback(handles.mhandles.ReloadButton,eventdata,handles.mhandles)
end
if get(handles.cont_process_checkbox,'value')
    
    DRTButton_Callback(handles.DRTButton, eventdata, handles)
end



% --- Executes on button press in SpeichernButton.
function SpeichernButton_Callback(hObject, eventdata, handles)
% hObject    handle to SpeichernButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Fitdaten auslesen
global DRT_GUI;
if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'DRT')))
    msgbox('Bitte erstellen Sie zunächst eine DRT!')
    return
end

if isempty(dir('output'))
    mkdir('output')
end
if iscell(DRT_GUI.Testparameter.Batterie)
    DRT_GUI.Testparameter.Batterie = cell2mat(DRT_GUI.Testparameter.Batterie);
end
if isempty( dir(['output' '/' DRT_GUI.Testparameter.Batterie]))
    mkdir(['output' '/' DRT_GUI.Testparameter.Batterie])
end
if isempty(cell2mat(strfind(fieldnames(DRT_GUI.Testparameter),'Zustand'))) || isempty(DRT_GUI.Testparameter.Zustand)
    DRT_GUI.Testparameter.Zustand = 'default';
    set(handles.ZustandTextBox,'string','default')
end
if ~isempty(cell2mat(strfind(fieldnames(DRT_GUI.DRT),'UserTau')))
    set(handles.UserTauText,'Visible','Off')
    set(handles.UserTauList,'Visible','Off')
    DRT_GUI.DRT=rmfield(DRT_GUI.DRT,'UserTau');
end
if isempty( dir(['output' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand]))
    mkdir(['output' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand])
end
if isempty( dir(['output' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad']))
    mkdir(['output' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad'])
end

save(['output' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad/' ...
    DRT_GUI.Testparameter.Batterie '_' DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_' [strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m')] 'SOC.mat'],'DRT_GUI');
Fit = [];
if sum(ismember(fieldnames(DRT_GUI),'Fit')) && ~isempty(DRT_GUI.Fit) &&  sum(ismember(fieldnames(DRT_GUI.Fit),'aktuell_Modell')) && ~isempty(DRT_GUI.Fit.aktuell_Modell) && sum(ismember(fieldnames(DRT_GUI.Fit),'Parameter')) && ~isempty(DRT_GUI.Fit.Parameter)
    Fit.Modell = rmfield(DRT_GUI.Fit.aktuell_Modell,'ModellCell');
    Fit.Modell.ModellCell = DRT_GUI.Fit.aktuell_Modell.ModellCell(1:7);
    Fit.Parameter = DRT_GUI.Fit.Parameter;
    Fit.residuum = DRT_GUI.Fit.residuum;
    Fit.Parameter_min = DRT_GUI.Fit.Parameter_min;
    Fit.Parameter_max = DRT_GUI.Fit.Parameter_max;
    
    if sum(ismember(fieldnames(DRT_GUI.Fit),'gueltig'))
        Fit.gueltig = DRT_GUI.Fit.gueltig;
    else
        Fit.gueltig = 0;
    end
    if sum(ismember(fieldnames(DRT_GUI.Fit),'Implementierung')) && ~isempty(DRT_GUI.Fit.Implementierung)
%         Fit.Implementierung = FittingGUI.Fit.Implementierung;
%         if ismember('Sim',fieldnames(Fit.Implementierung));
%             Fit.Implementierung = rmfield(Fit.Implementierung,'Sim');
%         end
        if sum(strcmp(fieldnames(DRT_GUI.Fit.Implementierung),'OCV')) && ~isempty(DRT_GUI.Fit.Implementierung.OCV)
            if numel(find(strcmp(DRT_GUI.Fit.Implementierung.OCV(:,1),'ROCV')))==1 && ...
                    numel(find(strcmp(DRT_GUI.Fit.Implementierung.OCV(:,1),'COCV')))==1 && ...
                    numel(find(strcmp(DRT_GUI.Fit.Implementierung.OCV(:,1),'UEnde')))==1
                ROCV = DRT_GUI.Fit.Implementierung.OCV{strcmp(DRT_GUI.Fit.Implementierung.OCV(:,1),'ROCV'),2};
                COCV = DRT_GUI.Fit.Implementierung.OCV{strcmp(DRT_GUI.Fit.Implementierung.OCV(:,1),'COCV'),2};
                UOCV = DRT_GUI.Fit.Implementierung.OCV{strcmp(DRT_GUI.Fit.Implementierung.OCV(:,1),'UEnde'),2};
                if isnumeric(ROCV) && isnumeric(COCV) && isnumeric(UOCV) && ~isnan(ROCV) && ~isnan(COCV) && ~isnan(UOCV)
                    Fit.Modell.Modellname = [Fit.Modell.Modellname '_OCV'];
                    Fit.Modell.P_Name = [Fit.Modell.P_Name {'ROCV','COCV','UOCV';'','',''}];
                    Fit.Modell.ModellCell{1,1}=Fit.Modell.Modellname;
                    Fit.Modell.ModellCell{1,3}=[Fit.Modell.ModellCell{1,3} ',ROCV,COCV,UOCV'];
                    Fit.Modell.ModellCell{1,4}=[Fit.Modell.ModellCell{1,4} zeros(1,3)];
                    Fit.Modell.ModellCell{1,5}=[Fit.Modell.ModellCell{1,5} zeros(1,3)];
                    Fit.Modell.ModellCell{1,6}=[Fit.Modell.ModellCell{1,6} zeros(1,3)];
                    Fit.Modell.ModellCell{1,7}=[Fit.Modell.ModellCell{1,7} ones(1,3)];
                    Fit.Parameter = [Fit.Parameter ROCV COCV UOCV];
                    Fit.Parameter_min = [Fit.Parameter_min ROCV COCV UOCV];
                    Fit.Parameter_max = [Fit.Parameter_max ROCV COCV UOCV];
                    
                end
                ReFit_indices = find(~cellfun(@isempty,regexp(DRT_GUI.Fit.Implementierung.OCV(:,1),'ReFit_*')))';
                if ~isempty(ReFit_indices)
                    ReFit_Values = cell2mat(DRT_GUI.Fit.Implementierung.OCV(ReFit_indices,2))';
                    ReFit_Names = DRT_GUI.Fit.Implementierung.OCV(ReFit_indices,1)';
                    Fit.Modell.P_Name = [Fit.Modell.P_Name [ReFit_Names ; repmat({''},1,numel(ReFit_indices))]];
                    for i_rf = 1:numel(ReFit_indices)
                        Fit.Modell.ModellCell{1,3}=[Fit.Modell.ModellCell{1,3} ',' ReFit_Names{i_rf}];
                    end
                    Fit.Modell.ModellCell{1,4}=[Fit.Modell.ModellCell{1,4} zeros(1,numel(ReFit_indices))];
                    Fit.Modell.ModellCell{1,5}=[Fit.Modell.ModellCell{1,5} zeros(1,numel(ReFit_indices))];
                    Fit.Modell.ModellCell{1,6}=[Fit.Modell.ModellCell{1,6} zeros(1,numel(ReFit_indices))];
                    Fit.Modell.ModellCell{1,7}=[Fit.Modell.ModellCell{1,7} ones(1,numel(ReFit_indices))];
                    Fit.Parameter = [Fit.Parameter ReFit_Values];
                    Fit.Parameter_min = [Fit.Parameter_min ReFit_Values];
                    Fit.Parameter_max = [Fit.Parameter_max ReFit_Values];
                    
                end
            end
        end
    end
    
end

save(['output' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad/' ...
     DRT_GUI.Testparameter.Batterie '_' DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_' [strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m')] 'SOC_Modell.mat'],'Fit');

Folders = {''};
f = dir('output/*');
for i = 1:numel(f)
    if ~strcmp(f(i).name,'.') && ~strcmp(f(i).name,'..') && f(i).isdir
        Folders = [Folders;f(i).name];
    end
end
set(handles.BatterieNamePopup,'string',Folders);
set(handles.BatterieNamePopup,'value',1);
BatterieNamePopup_Callback(handles.BatterieNamePopup,[],handles)


function DatumTextBox_Callback(hObject, eventdata, handles)
global DRT_GUI;
DRT_GUI.Testparameter.Messdatum = get(hObject,'String');
% hObject    handle to DatumTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DatumTextBox as text
%        str2double(get(hObject,'String')) returns contents of DatumTextBox as a double


% --- Executes during object creation, after setting all properties.

function DatumTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DatumTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BatterieTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to BatterieTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BatterieTextBox as text
%        str2double(get(hObject,'String')) returns contents of BatterieTextBox as a double
global DRT_GUI;
DRT_GUI.Testparameter.Batterie = get(hObject,'String');

% --- Executes during object creation, after setting all properties.
function BatterieTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BatterieTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TemperaturTextBox_Callback(hObject, eventdata, handles)
global DRT_GUI;
DRT_GUI.Testparameter.Temperatur = str2double(get(hObject,'String'));
% hObject    handle to TemperaturTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TemperaturTextBox as text
%        str2double(get(hObject,'String')) returns contents of TemperaturTextBox as a double


% --- Executes during object creation, after setting all properties.
function TemperaturTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TemperaturTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SOCTextBox_Callback(hObject, eventdata, handles)
global DRT_GUI;
DRT_GUI.Testparameter.SOC = str2double([strrep(get(hObject,'String'),'m','-')]);
% hObject    handle to SOCTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SOCTextBox as text
%        str2double(get(hObject,'String')) returns contents of SOCTextBox as a double


% --- Executes during object creation, after setting all properties.
function SOCTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SOCTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fmaxTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to fmaxTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fmaxTextBox as text
%        str2double(get(hObject,'String')) returns contents of fmaxTextBox as a double


% --- Executes during object creation, after setting all properties.
function fmaxTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fmaxTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fminTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to fminTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fminTextBox as text
%        str2double(get(hObject,'String')) returns contents of fminTextBox as a double


% --- Executes during object creation, after setting all properties.
function fminTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fminTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function KapTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to KapTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KapTextBox as text
%        str2double(get(hObject,'String')) returns contents of KapTextBox as a double
global DRT_GUI;
DRT_GUI.Testparameter.Cap = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function KapTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KapTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function DataCursorTool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to DataCursorTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in DRTButton.
function DRTButton_Callback(hObject, eventdata, handles)
% hObject    handle to DRTButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;


if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Korrigiert')))
    return
end


global DRT_Config
Schwingfaktor = DRT_Config.Schwingfaktor;
InterpolationsFaktor = DRT_Config.InterpolationsFaktor;
FilterFaktor_ext = DRT_Config.FilterFaktor_ext;
ZeroPadding = DRT_Config.ZeroPadding;
PeakSensitivitaet = DRT_Config.PeakSensitivitaet;

FilterFaktor_int = FilterFaktor_ext / InterpolationsFaktor * Schwingfaktor;
minfreq = min(DRT_GUI.Korrigiert.frequenz(DRT_GUI.Korrigiert.aktiv==true));
maxfreq = max(DRT_GUI.Korrigiert.frequenz(DRT_GUI.Korrigiert.aktiv==true));


% freq_ext = 10.^(...
%     log10(FittingGUI.Korrigiert.spaps.frequenz(1))-ZeroPadding*mean(diff(log10(FittingGUI.Korrigiert.spaps.frequenz))):...
%     mean(diff(log10(FittingGUI.Korrigiert.spaps.frequenz))):...
%     log10(FittingGUI.Korrigiert.spaps.frequenz(end))+ZeroPadding*mean(diff(log10(FittingGUI.Korrigiert.spaps.frequenz))));
%Z_ext = fnval(fnxtr(FittingGUI.Korrigiert.spaps.sp_real),log10(freq_ext))+1i .* fnval(fnxtr(FittingGUI.Korrigiert.spaps.sp_img),log10(freq_ext));
[freq_ext, Z_ext] = extrapolatesignal(DRT_GUI.Korrigiert.spaps.frequenz',(DRT_GUI.Korrigiert.spaps.Zreal + 1i *DRT_GUI.Korrigiert.spaps.Zimg).',[ZeroPadding ZeroPadding]);

[freq_int,Z_int_imag]=interpolate_signal(InterpolationsFaktor,imag(Z_ext),freq_ext);

[x_int,DRT_int]=makeDRT(Z_int_imag',freq_int',true,FilterFaktor_int);
DRT_int = DRT_int/Schwingfaktor;

[x,DRT]=makeDRT(imag(Z_ext),freq_ext,true,FilterFaktor_ext);


OrigFreqs = DRT_GUI.Korrigiert.frequenz(DRT_GUI.Korrigiert.aktiv==true);
OrigIndex = zeros(size(OrigFreqs));
for i = 1:numel(OrigIndex)
    OrigIndex(i) = find(freq_int>=OrigFreqs(i),1,'first');
end


DRT_GUI.DRT.Messgrenzen = [minfreq maxfreq];
DRT_GUI.DRT.E_DRT.frequenz = freq_ext;
DRT_GUI.DRT.E_DRT.omega= 2*pi*freq_ext;
DRT_GUI.DRT.E_DRT.tau= 1./(2*pi*freq_ext)';
DRT_GUI.DRT.E_DRT.g=real(DRT)';
DRT_GUI.DRT.E_DRT.x=x';
DRT_GUI.DRT.E_DRT.aktiv = freq_ext>=minfreq & freq_ext<=maxfreq;
DRT_GUI.DRT.E_DRT.Rpol = trapz(x(DRT_GUI.DRT.E_DRT.aktiv),abs(DRT(DRT_GUI.DRT.E_DRT.aktiv)));
DRT_GUI.DRT.E_DRT.Rser = min(real(Z_ext));
DRT_GUI.DRT.E_DRT.Rpol_EIS = max(real(Z_ext))-min(real(Z_ext));

DRT_GUI.DRT.EI_DRT.frequenz = freq_int;
DRT_GUI.DRT.EI_DRT.OrigIndex = OrigIndex;
DRT_GUI.DRT.EI_DRT.omega= 2*pi*freq_int;
DRT_GUI.DRT.EI_DRT.tau= 1./(2*pi*freq_int)';
DRT_GUI.DRT.EI_DRT.g=real(DRT_int)';
DRT_GUI.DRT.EI_DRT.x=x_int';
DRT_GUI.DRT.EI_DRT.aktiv = freq_int>=minfreq & freq_int<=maxfreq;
DRT_GUI.DRT.EI_DRT.Rpol = trapz(x_int(DRT_GUI.DRT.EI_DRT.aktiv),abs(DRT_int(DRT_GUI.DRT.EI_DRT.aktiv)));
DRT_GUI.DRT.EI_DRT.Rser = min(real(Z_ext));
DRT_GUI.DRT.EI_DRT.Rpol_EIS = max(real(Z_ext))-min(real(Z_ext));

DRT_GUI.DRT.Config = DRT_Config;
display(sprintf('Rpol_E: %0.5e, Rpol_EI: %0.5e, Rpol: %0.5e',trapz(x(DRT_GUI.DRT.E_DRT.aktiv),abs(DRT(DRT_GUI.DRT.E_DRT.aktiv))),trapz(x_int(DRT_GUI.DRT.EI_DRT.aktiv),abs(DRT_int(DRT_GUI.DRT.EI_DRT.aktiv))),max(real(Z_ext))-min(real(Z_ext))));

DRT_int_aktiv = DRT_GUI.DRT.EI_DRT.g(DRT_GUI.DRT.EI_DRT.aktiv);
Peaks = flipdim(peakfinder(DRT_int_aktiv,(max(real(DRT_int_aktiv))-min(DRT_int_aktiv))/(10000)),1);
g_diff1 = diff(DRT_int_aktiv);
index = find(abs([0 diff(g_diff1)])>(mean(diff(g_diff1))+5*std(diff(g_diff1)))) ;
g_diff1(index) = 0;
g_diff2 = diff(diff(DRT_int_aktiv));
index = find(abs([0 diff(g_diff2)])>(mean(diff(g_diff2))+5*std(diff(g_diff2)))) ;
g_diff2(index) = 0;
g_diff3 = diff(diff(diff(DRT_int_aktiv)));
index = find(abs([0 diff(g_diff3)])>(mean(diff(g_diff3))+5*std(diff(g_diff3)))) ;
g_diff3(index) =0;

Peaks2 = flipdim(peakfinder(abs(g_diff3)/max(abs(g_diff3)),1/(20)),1);
Peaks2 = Peaks2(find(abs(g_diff1(Peaks2))'<(mean(abs(g_diff1(Peaks2)))-2*(1-PeakSensitivitaet)*std(abs(g_diff1(Peaks2))))));
%figure; plot(real(DRT_int_aktiv)/max(real(DRT_int_aktiv))); hold on ; grid on;plot(abs(g_diff3)/max(abs(g_diff3)),'r');plot(abs(g_diff2)/max(abs(g_diff2)),'g');plot(abs(g_diff1)/max(abs(g_diff1)),'k') ;plot(Peaks,real(DRT_int_aktiv(Peaks))/max(real(DRT_int_aktiv)),'o');plot(Peaks2,abs(g_diff3(Peaks2))/max(abs(g_diff3)),'ro')

Peaks = sort([Peaks Peaks2],2,'descend');
Peaks(Peaks<DRT_GUI.DRT.Config.InterpolationsFaktor/2)=[];
Peaks(Peaks>(numel(DRT_int_aktiv)-DRT_GUI.DRT.Config.InterpolationsFaktor/2)) = [];
Peaks = Peaks + find(DRT_GUI.DRT.EI_DRT.aktiv,1,'first');
if ~isempty(cell2mat(strfind(fieldnames(DRT_GUI.DRT.EI_DRT),'peaks')))
    old_peaks = DRT_GUI.DRT.EI_DRT.peaks;
else
    old_peaks.used = 0;
end
DRT_GUI.DRT.EI_DRT.peaks.index = Peaks;
DRT_GUI.DRT.EI_DRT.peaks.tau = DRT_GUI.DRT.EI_DRT.tau(Peaks)';
DRT_GUI.DRT.EI_DRT.peaks.g = DRT_GUI.DRT.EI_DRT.g(Peaks)';
DRT_GUI.DRT.EI_DRT.peaks.used = zeros(size(DRT_GUI.DRT.EI_DRT.g(Peaks)'));
DRT_GUI.DRT.EI_DRT.peaks.used_parname = repmat({''},size(DRT_GUI.DRT.EI_DRT.peaks.used));
for i=find(old_peaks.used==1)'
    newpeak=find(abs(DRT_GUI.DRT.EI_DRT.peaks.tau-old_peaks.tau(i)) == min(abs(DRT_GUI.DRT.EI_DRT.peaks.tau-old_peaks.tau(i))),1,'first');
    if isempty(newpeak),continue,end
    oldfound = cell2mat(strfind(old_peaks.used_parname(1:i),DRT_GUI.DRT.EI_DRT.peaks.used_parname{newpeak}));
    if isempty(oldfound)
        DRT_GUI.DRT.EI_DRT.peaks.used(newpeak) = 1;
        DRT_GUI.DRT.EI_DRT.peaks.used_parname(newpeak) = old_peaks.used_parname(i);
    else
        if abs(old_peaks.tau(oldfound)-DRT_GUI.DRT.EI_DRT.peaks.tau(newpeak))>abs(old_peaks.tau(i)-DRT_GUI.DRT.EI_DRT.peaks.tau(newpeak))
            DRT_GUI.DRT.EI_DRT.peaks.used(newpeak) = 1;
            DRT_GUI.DRT.EI_DRT.peaks.used_parname(newpeak) = old_peaks.used_parname(i);
        end
    end
end

if ~strcmp(eventdata,'kein_plot')
    DRT_Taus_in_Tabelle(handles)
    Prozess_Taus_in_Tabelle(handles)
end





Typ = 'DRT';
if ~strcmp(eventdata,'kein_plot')
    axes(handles.axes3);
    plot_Auswaehl(DRT_GUI.Korrigiert,DRT_GUI.DRT.E_DRT,DRT_GUI.DRT.EI_DRT,[],Typ,handles)
    set(handles.HFLF_Axes_Panel,'visible','off')
    set(handles.DRT_Axes_Panel,'Visible','on')

else
    return;
end

if get(handles.cont_process_checkbox,'value')
    Prozesse_fitten_button_Callback(handles.Prozesse_fitten_button, eventdata, handles)
end




function Prozess_Taus_in_Tabelle(handles)
global DRT_GUI;
global DRT_Config;
if ~sum(ismember(fieldnames(DRT_GUI),'DRT')) || isempty(DRT_GUI.DRT) || ...
        ~sum(ismember(fieldnames(DRT_GUI.DRT),'EI_DRT')) || ...
        isempty(DRT_GUI.DRT.EI_DRT)|| ...
        ~sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT),'ProzessFit')) ...
        || isempty(DRT_GUI.DRT.EI_DRT.ProzessFit)  ...
        || ( numel(DRT_GUI.DRT.EI_DRT.ProzessFit.tau)==0 && ( ... 
            ~sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT.ProzessFit),'val')) ...
            || numel(DRT_GUI.DRT.EI_DRT.ProzessFit.val)==0 )...
            )
    %msgbox(['Bitte zuerst eine DRT erstellen'])
    if sum(ismember(fieldnames(handles),'ProzesseTable'))
        set(handles.ProzesseTable,'visible','off')
    end
    set(handles.ProzesseCaption,'visible','off')
    return
end
set(handles.ProzesseTable,'visible','on')
set(handles.ProzesseTable,'visible','on')
if sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT.ProzessFit),'val')) && numel(DRT_GUI.DRT.EI_DRT.ProzessFit.val)>0
    ColFormat = get(handles.ProzesseTable,'ColumnFormat');
     ColFormat{3} = DRT_GUI.DRT.EI_DRT.ProzessFit.used_parname';
     set(handles.ProzesseTable,'ColumnFormat',ColFormat);
     ColNames = get(handles.ProzesseTable,'ColumnName');
     ColNames{1} = 'Val';
     ColNames{4} = '';
     ColNames{5} = '';
     set(handles.ProzesseTable,'ColumnName',ColNames);
     TableCell = [num2cell(DRT_GUI.DRT.EI_DRT.ProzessFit.val) num2cell(logical(DRT_GUI.DRT.EI_DRT.ProzessFit.used)) DRT_GUI.DRT.EI_DRT.ProzessFit.used_parname  num2cell(zeros(numel(DRT_GUI.DRT.EI_DRT.ProzessFit.val),2))];
     set(handles.ProzesseTable,'Data',TableCell)
else
    ColFormat = get(handles.ProzesseTable,'ColumnFormat');
    Parameter_Taus = textscan(strrep(DRT_GUI.Fit.aktuell_Modell.ModellCell{1,3},' ',''),'%s','delimiter',',');
    Parameter_Taus = Parameter_Taus{1,1}(~cellfun(@isempty,strfind(Parameter_Taus{1,1}','Tau')));
    if isempty(Parameter_Taus) , Parameter_Taus = {' '};end
    ColFormat{3} = Parameter_Taus';
    set(handles.ProzesseTable,'ColumnFormat',ColFormat);
    ColNames = get(handles.ProzesseTable,'ColumnName');
     ColNames{1} = 'Tau';
     ColNames{4} = 'R';
     ColNames{5} = 'Phi';
     set(handles.ProzesseTable,'ColumnName',ColNames);
    TauCell = get(handles.ProzesseTable,'Data');
    if size(TauCell,1)>numel(DRT_GUI.DRT.EI_DRT.ProzessFit.tau),
        TauCell = TauCell(1:numel(DRT_GUI.DRT.EI_DRT.ProzessFit.tau),:);
    end
    TauCell = cell2struct(TauCell',{'Tau','Used','Parameter','R','Phi'});

    for i = 1:numel(DRT_GUI.DRT.EI_DRT.ProzessFit.tau)
        TauCell(i,1).Tau = DRT_GUI.DRT.EI_DRT.ProzessFit.tau(i);
        if sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT),'Rpol_EIS'))
            TauCell(i,1).R = DRT_GUI.DRT.EI_DRT.ProzessFit.r(i) .* DRT_GUI.DRT.EI_DRT.Rpol_EIS ./ DRT_GUI.DRT.EI_DRT.Rpol;
        else
            display('bitte DRT und Prozessfitting aktualisieren');
            TauCell(i,1).R = DRT_GUI.DRT.EI_DRT.ProzessFit.r(i) ;
        end
        TauCell(i,1).Phi = DRT_GUI.DRT.EI_DRT.ProzessFit.phi(i);
        if sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT.ProzessFit),'used')) && ...
                sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT.ProzessFit),'used_parname')) && ...
                DRT_GUI.DRT.EI_DRT.ProzessFit.used(i)

            TauCell(i,1).Used = true;
            TauCell(i,1).Parameter = DRT_GUI.DRT.EI_DRT.ProzessFit.used_parname{i};
        else
            TauCell(i,1).Used = false;
            TauCell(i,1).Parameter = '';
        end
    end
    TauCell = struct2cell(TauCell)';
    set(handles.ProzesseTable,'Data',TauCell)
end




% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if 1
    
end


function MessPunkteTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to MessPunkteTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MessPunkteTextBox as text
%        str2double(get(hObject,'String')) returns contents of MessPunkteTextBox as a double


% --- Executes during object creation, after setting all properties.
function MessPunkteTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MessPunkteTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Korrigiert_Punkte_Weg_TextBox_Callback(hObject, eventdata, handles)
% hObject    handle to Korrigiert_Punkte_Weg_TextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Korrigiert_Punkte_Weg_TextBox as text
%        str2double(get(hObject,'String')) returns contents of Korrigiert_Punkte_Weg_TextBox as a double


% --- Executes during object creation, after setting all properties.
function Korrigiert_Punkte_Weg_TextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Korrigiert_Punkte_Weg_TextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Korrigiert_Punkte_Weg_Button.
function Korrigiert_Punkte_Weg_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Korrigiert_Punkte_Weg_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;
if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Korrigiert')))
    return
end
LP_str = get(handles.Korrigiert_Punkte_Weg_TextBox,'string');
DRT_GUI.Korrigiert.aktiv = true(size(DRT_GUI.Korrigiert.Z));
if ~isempty(get(handles.Korrigiert_Punkte_Weg_TextBox,'string'))
    if strcmp(LP_str , '0:0'), LP_str = '1:end';        end
    eval(['DRT_GUI.Korrigiert.aktiv([' LP_str ']) = false;']);
    DRT_GUI.Korrigiert.aktiv = DRT_GUI.Korrigiert.aktiv(1:numel(DRT_GUI.Korrigiert.Z));
    if sum(DRT_GUI.Korrigiert.aktiv)<2 , DRT_GUI.Korrigiert.aktiv = true(size(DRT_GUI.Korrigiert.Z));end
end
DRT_GUI.Korrigiert.Punkte_Weg = LP_str;
%Smoothing Spline berechnen
[f_sorted,order] = sort(DRT_GUI.Korrigiert.frequenz(DRT_GUI.Korrigiert.aktiv));
Zreal_sorted = DRT_GUI.Korrigiert.Zreal(DRT_GUI.Korrigiert.aktiv);
Zreal_sorted = Zreal_sorted(order);
Zimg_sorted = DRT_GUI.Korrigiert.Zimg(DRT_GUI.Korrigiert.aktiv);
Zimg_sorted = Zimg_sorted(order);

min_delta_f = min(diff(log10(f_sorted)));

DRT_GUI.Korrigiert.spaps.frequenz = 10.^(log10(f_sorted(1)):min_delta_f:log10(f_sorted(end)));
DRT_GUI.Korrigiert.spaps.omega = 2*pi*DRT_GUI.Korrigiert.spaps.frequenz ;
DRT_GUI.Korrigiert.spaps.tau = 1./ DRT_GUI.Korrigiert.spaps.omega;

if license('checkout', 'Curve_Fitting_Toolbox')
    DRT_GUI.Korrigiert.spaps.sp_real = spaps(log10(f_sorted),Zreal_sorted,1e-11,[100 ones(1,numel(f_sorted)-2) 100]',3);
    DRT_GUI.Korrigiert.spaps.sp_img = spaps(log10(f_sorted),Zimg_sorted,1e-11,[100 ones(1,numel(f_sorted)-2) 100]',3);
    DRT_GUI.Korrigiert.spaps.Zreal = fnval(DRT_GUI.Korrigiert.spaps.sp_real,log10(DRT_GUI.Korrigiert.spaps.frequenz));
    DRT_GUI.Korrigiert.spaps.Zimg = fnval(DRT_GUI.Korrigiert.spaps.sp_img,log10(DRT_GUI.Korrigiert.spaps.frequenz));
else
    DRT_GUI.Korrigiert.spaps.Zreal = spline(log10(f_sorted),Zreal_sorted,log10(DRT_GUI.Korrigiert.spaps.frequenz));
    DRT_GUI.Korrigiert.spaps.Zimg = spline(log10(f_sorted),Zimg_sorted,log10(DRT_GUI.Korrigiert.spaps.frequenz));
end
% neu plot
Typ = 'Korrigiert_Fit';
if ~strcmp(eventdata, 'kein_plot')
    axes(handles.axes2); hold off;
    plot_Auswaehl(DRT_GUI.Korrigiert,DRT_GUI.Fit,[],DRT_GUI.Testparameter.Batterie,Typ)
    % Modellelemente plotten, falls der ESB-Generator genutzt wurde
    if get(handles.PlotElementsCheckbox,'Value') && ~isempty(DRT_GUI.Fit.aktuell_Modell.ModellCell{8})
        Zreal_vorher=0;
        for i = 1:numel(DRT_GUI.Fit.aktuell_Modell.ModellCell{8})
            Modell = DRT_GUI.Fit.aktuell_Modell.ModellCell{8}{i};
            Zfun = Modell.Zfun_MF;
            for j = 1:numel(Modell.ParameterIndexes)
                Zfun = strrep(Zfun,Modell.inputs{j},['p(' num2str(Modell.ParameterIndexes(j)) ')']);
            end
            p = DRT_GUI.Fit.Parameter;
            w = DRT_GUI.Fit.omega;
            Z = eval(Zfun);
%             if numel(Zreal_vorher) == 1, 
%                 index2 = 1;
%             else
%                 index = find(abs(imag(Z))>(mean(abs(imag(Z)))*1),1,'first');
%                 if isempty(index), index = 1; end
%                 index2 = index + find(Zreal_vorher(index:end)<Zreal_vorher(index),1,'last')-1;
%                 if isempty(index2), index2 = index; end
%             end
%             
            realverschiebung =  Zreal_vorher(end);
            if Modell.Plot  
                plot(real(Z)+realverschiebung,imag(Z),'k','display',Modell.Name)
            end
            Zreal_vorher = Zreal_vorher+real(Z);

        end
    end
    
else
end


% --- Executes during object creation, after setting all properties.
function ModellAktualisierenButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModellAktualisierenButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function SchwingungSlider_Callback(hObject, eventdata, handles)
% hObject    handle to SchwingungSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global DRT_Config
DRT_Config.Schwingfaktor = get(hObject,'Value');
DRTButton_Callback(handles.DRTButton, eventdata, handles)
set(handles.SchwingungEdit,'string',num2str(DRT_Config.Schwingfaktor))

% --- Executes during object creation, after setting all properties.
function SchwingungSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SchwingungSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

global DRT_Config
if isempty(DRT_Config)
    config
end
set(hObject,'String',num2str(DRT_Config.Schwingfaktor))

% --- Executes on slider movement.
function InterpolationSlider_Callback(hObject, eventdata, handles)
% hObject    handle to InterpolationSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global DRT_Config
DRT_Config.InterpolationsFaktor = round(10.^get(hObject,'Value'));
set(handles.InterpolationEdit,'string',num2str(DRT_Config.InterpolationsFaktor))
DRTButton_Callback(handles.DRTButton, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function InterpolationSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InterpolationSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

global DRT_Config
if isempty(DRT_Config)
    config
end
set(hObject,'value',log10(DRT_Config.InterpolationsFaktor))

% --- Executes on slider movement.
function ZeropaddingSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ZeropaddingSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global DRT_Config
DRT_Config.ZeroPadding = round(10.^get(hObject,'Value'));
set(handles.ZeropaddingEdit,'string',num2str(DRT_Config.ZeroPadding))
DRTButton_Callback(handles.DRTButton, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ZeropaddingSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZeropaddingSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

global DRT_Config
if isempty(DRT_Config)
    config
end
set(hObject,'value',log10(DRT_Config.ZeroPadding))

% --- Executes on slider movement.
function FilterFaktorSlider_Callback(hObject, eventdata, handles)
% hObject    handle to FilterFaktorSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global DRT_Config
DRT_Config.FilterFaktor_ext = get(hObject,'Value');
set(handles.FilterEdit,'string',num2str(DRT_Config.FilterFaktor_ext))
DRTButton_Callback(handles.DRTButton, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function FilterFaktorSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterFaktorSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

global DRT_Config
if isempty(DRT_Config)
    config
end
set(hObject,'value',DRT_Config.FilterFaktor_ext)

% --- Executes on button press in DRT_Config_Reload_Button.
function DRT_Config_Reload_Button_Callback(hObject, eventdata, handles)
% hObject    handle to DRT_Config_Reload_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
config
global DRT_Config
set(handles.SchwingungSlider,'value',DRT_Config.Schwingfaktor)
set(handles.SchwingungEdit,'string',num2str(DRT_Config.Schwingfaktor))

set(handles.InterpolationSlider,'value',log10(DRT_Config.InterpolationsFaktor))
set(handles.InterpolationEdit,'string',num2str(DRT_Config.InterpolationsFaktor))

set(handles.FilterFaktorSlider,'value',DRT_Config.FilterFaktor_ext)
set(handles.FilterEdit,'string',num2str(DRT_Config.FilterFaktor_ext))

set(handles.ZeropaddingSlider,'value',log10(DRT_Config.ZeroPadding))
set(handles.ZeropaddingEdit,'string',num2str(DRT_Config.ZeroPadding))

set(handles.PeakfinderSlider,'value',DRT_Config.PeakSensitivitaet)
set(handles.PeakfinderEdit,'string',num2str(DRT_Config.PeakSensitivitaet))

set(handles.ProzesseSlider,'value',DRT_Config.Prozesse)
set(handles.ProzesseEdit,'string',num2str(DRT_Config.Prozesse))
if ~sum(ismember(fieldnames(DRT_Config),'ZarcHN'))
    DRT_Config.ZarcHN=5;
end
set(handles.ZarcHNPopup,'value',DRT_Config.ZarcHN)


DRTButton_Callback(handles.DRTButton, eventdata, handles)



function SchwingungEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SchwingungEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SchwingungEdit as text
%        str2double(get(hObject,'String')) returns contents of SchwingungEdit as a double
global DRT_Config
try
    Wert = str2num(get(hObject,'string'));
catch error_msg
    set(hObject,'string',num2str(DRT_Config.Schwingfaktor))
    errordlg(error_msg)
end
if isempty(Wert)|| (Wert<get(handles.SchwingungSlider,'Min') || Wert>get(handles.SchwingungSlider,'Max'))
    set(hObject,'string',num2str(DRT_Config.Schwingfaktor))
    errordlg('Ungültiger Wert')
else
    DRT_Config.Schwingfaktor = Wert;
    set(handles.SchwingungSlider,'value',DRT_Config.Schwingfaktor)
    DRTButton_Callback(handles.DRTButton, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function SchwingungEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SchwingungEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global DRT_Config
if isempty(DRT_Config)
    config
end

set(hObject,'string',num2str(DRT_Config.Schwingfaktor))



function InterpolationEdit_Callback(hObject, eventdata, handles)
% hObject    handle to InterpolationEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InterpolationEdit as text
%        str2double(get(hObject,'String')) returns contents of InterpolationEdit as a double
global DRT_Config
try
    Wert = str2num(get(hObject,'string'));
catch error_msg
    set(hObject,'string',num2str(DRT_Config.InterpolationsFaktor))
    errordlg(error_msg)
end
if isempty(Wert)|| (Wert<10.^get(handles.InterpolationSlider,'Min') || Wert>10.^get(handles.InterpolationSlider,'Max'))
    set(hObject,'string',num2str(DRT_Config.InterpolationsFaktor))
    errordlg('Ungültiger Wert')
else
    DRT_Config.InterpolationsFaktor = Wert;
    set(handles.InterpolationSlider,'value',log10(DRT_Config.InterpolationsFaktor))
    DRTButton_Callback(handles.DRTButton, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function InterpolationEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InterpolationEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global DRT_Config
if isempty(DRT_Config)
    config
end

set(hObject,'string',num2str(DRT_Config.InterpolationsFaktor))



function FilterEdit_Callback(hObject, eventdata, handles)
% hObject    handle to FilterEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilterEdit as text
%        str2double(get(hObject,'String')) returns contents of FilterEdit as a double
global DRT_Config
try
    Wert = str2num(get(hObject,'string'));
catch error_msg
    set(hObject,'string',num2str(DRT_Config.FilterFaktor_ext))
    errordlg(error_msg)
end
if isempty(Wert)|| (Wert<get(handles.FilterFaktorSlider,'Min') || Wert>get(handles.FilterFaktorSlider,'Max'))
    set(hObject,'string',num2str(DRT_Config.FilterFaktor_ext))
    errordlg('Ungültiger Wert')
else
    DRT_Config.FilterFaktor_ext = Wert;
    set(handles.FilterFaktorSlider,'value',DRT_Config.FilterFaktor_ext)
    DRTButton_Callback(handles.DRTButton, eventdata, handles)
    
end

% --- Executes during object creation, after setting all properties.
function FilterEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global DRT_Config
if isempty(DRT_Config)
    config
end
set(hObject,'string',num2str(DRT_Config.FilterFaktor_ext))




function ZeropaddingEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ZeropaddingEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ZeropaddingEdit as text
%        str2double(get(hObject,'String')) returns contents of ZeropaddingEdit as a double
global DRT_Config
try
    Wert = str2num(get(hObject,'string'));
catch error_msg
    set(hObject,'string',num2str(DRT_Config.ZeroPadding))
    errordlg(error_msg)
end
if isempty(Wert)|| (Wert<10.^get(handles.ZeropaddingSlider,'Min') || Wert>10.^get(handles.ZeropaddingSlider,'Max'))
    set(hObject,'string',num2str(DRT_Config.ZeroPadding))
    errordlg('Ungültiger Wert')
else
    DRT_Config.ZeroPadding = Wert;
    set(handles.ZeropaddingSlider,'value',log10(DRT_Config.ZeroPadding))
    DRTButton_Callback(handles.DRTButton, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function ZeropaddingEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZeropaddingEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global DRT_Config
if isempty(DRT_Config)
    config
end

set(hObject,'string',num2str(DRT_Config.ZeroPadding))


% --- Executes on slider movement.
function PeakfinderSlider_Callback(hObject, eventdata, handles)
% hObject    handle to PeakfinderSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global DRT_Config
DRT_Config.PeakSensitivitaet = get(hObject,'Value');
set(handles.PeakfinderEdit,'string',num2str(DRT_Config.PeakSensitivitaet))
DRTButton_Callback(handles.DRTButton, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function PeakfinderSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PeakfinderSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

global DRT_Config
if isempty(DRT_Config)
    config
end
set(hObject,'value',DRT_Config.PeakSensitivitaet)



function PeakfinderEdit_Callback(hObject, eventdata, handles)
% hObject    handle to PeakfinderEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PeakfinderEdit as text
%        str2double(get(hObject,'String')) returns contents of PeakfinderEdit as a double
global DRT_Config
try
    Wert = str2num(get(hObject,'string'));
catch error_msg
    set(hObject,'string',num2str(DRT_Config.PeakSensitivitaet))
    errordlg(error_msg)
end
if isempty(Wert)|| (Wert<get(handles.PeakfinderSlider,'Min') || Wert>get(handles.PeakfinderSlider,'Max'))
    set(hObject,'string',num2str(DRT_Config.PeakSensitivitaet))
    errordlg('Ungültiger Wert')
else
    DRT_Config.PeakSensitivitaet = Wert;
    set(handles.PeakfinderSlider    ,'value',DRT_Config.PeakSensitivitaet)
    DRTButton_Callback(handles.DRTButton, eventdata, handles)
    
end
% --- Executes during object creation, after setting all properties.
function PeakfinderEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PeakfinderEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global DRT_Config
if isempty(DRT_Config)
    config
end

set(hObject,'string',num2str(DRT_Config.PeakSensitivitaet))

% --- Executes on button press in aktualisieren_Button.
function aktualisieren_Button_Callback(hObject, eventdata, handles)
% hObject    handle to aktualisieren_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
%Ergänzung:
Alles_Laden(handles,eventdata)




function  Alles_Laden(handles,eventdata)
global DRT_GUI

% if strcmp(eventdata,'kein_plot')
%     return
% end

Folders = {''};
f = dir('output/*');
for i = 1:numel(f)
    if ~strcmp(f(i).name,'.') && ~strcmp(f(i).name,'..') && f(i).isdir
        Folders = [Folders;f(i).name];
    end
end
set(handles.BatterieNamePopup,'string',Folders);
set(handles.BatterieNamePopup,'value',1);
BatterieNamePopup_Callback(handles.BatterieNamePopup,[],handles);

if isempty(DRT_GUI) || ~sum(ismember(fieldnames(DRT_GUI),'Testparameter')) || ~sum(ismember(fieldnames(DRT_GUI),'Messdaten'))
    return
end

if sum(ismember(fieldnames(DRT_GUI),'Testparameter'))
    if ~isempty(DRT_GUI.Testparameter) && sum(ismember(fieldnames(DRT_GUI.Testparameter),'Messdatum'))
        set(handles.DatumTextBox,'String',DRT_GUI.Testparameter.Messdatum)
    else
        set(handles.DatumTextBox,'String','')
    end
    if ~isempty(DRT_GUI.Testparameter) && sum(ismember(fieldnames(DRT_GUI.Testparameter),'Batterie'))
        set(handles.BatterieTextBox,'String',DRT_GUI.Testparameter.Batterie)
    else
        set(handles.BatterieTextBox,'String','')
    end
    if ~isempty(DRT_GUI.Testparameter) && sum(ismember(fieldnames(DRT_GUI.Testparameter),'Zustand'))
        set(handles.ZustandTextBox,'String',DRT_GUI.Testparameter.Zustand)
    else
        set(handles.ZustandTextBox,'String','')
    end
    if ~isempty(DRT_GUI.Testparameter) && sum(ismember(fieldnames(DRT_GUI.Testparameter),'Cap'))
        set(handles.KapTextBox,'String',num2str(DRT_GUI.Testparameter.Cap))
    else
        set(handles.KapTextBox,'String','')
    end
    if ~isempty(DRT_GUI.Testparameter) && sum(ismember(fieldnames(DRT_GUI.Testparameter),'Temperatur'))
        set(handles.TemperaturTextBox,'String',num2str(DRT_GUI.Testparameter.Temperatur))
    else
        set(handles.TemperaturTextBox,'String','')
    end
    if ~isempty(DRT_GUI.Testparameter) && sum(ismember(fieldnames(DRT_GUI.Testparameter),'SOC'))
        set(handles.SOCTextBox,'String',[strrep(num2str(DRT_GUI.Testparameter.SOC),'m','-')])
    else
        set(handles.SOCTextBox,'String','')
    end
%     if ~isempty(FittingGUI.Testparameter) && sum(ismember(fieldnames(FittingGUI.Testparameter),'fileName'))
%         set(handles.fileName_text,'String',FittingGUI.Testparameter.fileName)
%     else
%         set(handles.fileName_text,'String','')
%     end
    
end
if  isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten'))) || isempty(DRT_GUI.Messdaten)|| isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) || isempty(DRT_GUI.Messdaten.relax_fft)
    Relax_Visible(handles,'off')
else
    Relax_Visible(handles,'on')
    if isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten.relax_fft),'Zreal_korrektur'))) || isempty(DRT_GUI.Messdaten.relax_fft.Zreal_korrektur)
        DRT_GUI.Messdaten.relax_fft.Zreal_korrektur=0;
    end
    set(handles.Zreal_korrektur_textbox,'string',num2str(DRT_GUI.Messdaten.relax_fft.Zreal_korrektur,'%8.4e'));
end
if sum(ismember(fieldnames(DRT_GUI),'Messdaten'))
    if ~isempty(DRT_GUI.Messdaten) && sum(ismember(fieldnames(DRT_GUI.Messdaten),'frequenz'))
        set(handles.fmaxTextBox,'String',num2str(max(DRT_GUI.Messdaten.frequenz)))
        set(handles.fminTextBox,'String',num2str(min(DRT_GUI.Messdaten.frequenz)))
        set(handles.MessPunkteTextBox,'String',num2str(numel(DRT_GUI.Messdaten.frequenz)))
        Typ = 'Nyquist';
        if ~strcmp(eventdata, 'kein_plot')
            axes(handles.axes1); hold off;
            set(handles.axes1,'NextPlot','add')
            plot_Auswaehl(DRT_GUI.Messdaten,[],[],DRT_GUI.Testparameter.Batterie,Typ);
        else
        end
        if sum(ismember(fieldnames(DRT_GUI.Messdaten),'low_Punkte_Weg')) && ~isempty(DRT_GUI.Messdaten.low_Punkte_Weg)
            set(handles.PunkteWegnehmenTextBox,'string',DRT_GUI.Messdaten.low_Punkte_Weg)
            %Ergänzung:
            PunkteWegnehmenButton_Callback(handles.PunkteWegnehmenButton, eventdata, handles)
        end
        
    end
    if ~isempty(DRT_GUI.Messdaten) && sum(ismember(fieldnames(DRT_GUI.Messdaten),'relax'))
        set(handles.RelaxPanel,'Visible','on')
    else
        set(handles.RelaxPanel,'Visible','off')
    end
else
    set(handles.RelaxPanel,'Visible','off')
end

if sum(ismember(fieldnames(DRT_GUI),'Fit'))
    if ~isempty(DRT_GUI.Fit) && sum(ismember(fieldnames(DRT_GUI.Fit),'Parameter')) && ~isempty(DRT_GUI.Fit.Parameter)
        if sum(ismember(fieldnames(DRT_GUI),'Fit')) && ~isempty(DRT_GUI.Fit)
            ModellListe = get(handles.ModellAuswahlPopup,'String');
            set(handles.ModellAuswahlPopup,'value',find(strcmp(DRT_GUI.Fit.aktuell_Modell.Modellname,ModellListe)))
            ModellAuswahlPopup_Callback(handles.ModellAuswahlPopup, [], handles)
            Typ = 'Fit';
            if ~strcmp(eventdata, 'kein_plot')
                axes(handles.axes1); hold off;
                plot_Auswaehl(DRT_GUI.Messdaten,DRT_GUI.Fit,[],DRT_GUI.Testparameter.Batterie,Typ)
            else
            end
            if sum(ismember(fieldnames(DRT_GUI),'Korrigiert')) && ~isempty(DRT_GUI.Korrigiert)
                set(handles.Residuum,'string',num2str(DRT_GUI.Fit.residuum));
                set(handles.Korrigiert_Punkte_Weg_TextBox,'string',DRT_GUI.Korrigiert.Punkte_Weg)
                %Ergänzung:
                Korrigiert_Punkte_Weg_Button_Callback(handles.Korrigiert_Punkte_Weg_Button, eventdata, handles)
                if sum(ismember(fieldnames(DRT_GUI),'DRT')) && ~isempty(DRT_GUI.DRT)
                    
                    if ~strcmp(eventdata,'kein_plot')
                        
                        if sum(ismember(fieldnames(DRT_GUI.DRT),'Config')) && ~isempty(DRT_GUI.DRT.Config)
                            global DRT_Config
                            DRT_Config = DRT_GUI.DRT.Config;
                            if ~sum(ismember(fieldnames(DRT_Config),'PeakSensitivitaet')) || isempty(DRT_Config.PeakSensitivitaet)
                                DRT_Config.PeakSensitivitaet = 0.3 ;
                            end
                            if ~sum(ismember(fieldnames(DRT_Config),'Prozesse')) || isempty(DRT_Config.Prozesse)
                                DRT_Config.Prozesse = 3 ;
                            end
                            if DRT_Config.Schwingfaktor ~= 1
                                DRT_Config.FilterFaktor_ext = DRT_Config.FilterFaktor_ext * DRT_Config.Schwingfaktor;
                                DRT_Config.Schwingfaktor = 1;
                            end
                            set(handles.SchwingungSlider,'value',DRT_Config.Schwingfaktor)
                            set(handles.SchwingungEdit,'string',num2str(DRT_Config.Schwingfaktor))
                            set(handles.InterpolationSlider,'value',log10(DRT_Config.InterpolationsFaktor))
                            set(handles.InterpolationEdit,'string',num2str(DRT_Config.InterpolationsFaktor))
                            set(handles.FilterFaktorSlider,'value',DRT_Config.FilterFaktor_ext)
                            set(handles.FilterEdit,'string',num2str(DRT_Config.FilterFaktor_ext))
                            set(handles.ZeropaddingSlider,'value',log10(DRT_Config.ZeroPadding))
                            set(handles.ZeropaddingEdit,'string',num2str(DRT_Config.ZeroPadding))
                            set(handles.PeakfinderSlider,'value',DRT_Config.PeakSensitivitaet)
                            set(handles.PeakfinderEdit,'string',num2str(DRT_Config.PeakSensitivitaet))
                            set(handles.ProzesseSlider,'value',DRT_Config.Prozesse)
                            set(handles.ProzesseEdit,'string',num2str(DRT_Config.Prozesse))
                            if ~sum(ismember(fieldnames(DRT_Config),'ZarcHN'))
                                DRT_Config.ZarcHN=5;
                            end
                            set(handles.ZarcHNPopup,'value',DRT_Config.ZarcHN)
                            
                            minfreq = DRT_GUI.DRT.Messgrenzen(1);
                            maxfreq = DRT_GUI.DRT.Messgrenzen(2);
                            freq_int = DRT_GUI.DRT.EI_DRT.frequenz;
                            DRT_int = DRT_GUI.DRT.EI_DRT.g;
                            freq_ext = DRT_GUI.DRT.E_DRT.frequenz;
                            DRT = DRT_GUI.DRT.E_DRT.g;
                            
                            Typ = 'DRT';
                            if ~strcmp(eventdata, 'kein_plot')
                                axes(handles.axes3);
                                plot_Auswaehl(DRT_GUI.Korrigiert,DRT_GUI.DRT.E_DRT,DRT_GUI.DRT.EI_DRT,[],Typ,handles)
                            else
                            end
                            if ~strcmp(eventdata,'kein_plot')
                                DRT_Taus_in_Tabelle(handles)
                                Prozess_Taus_in_Tabelle(handles)
                            end
                        end
                    end
                end
            end
            PlotFittedParametersButton_Callback(handles.PlotFittedParametersButton,eventdata,handles)
        end
    end
end



% --- Executes on button press in laden_button.
function laden_button_Callback(hObject, eventdata, handles)
% hObject    handle to laden_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function DRT_Taus_in_Tabelle(handles)

global DRT_GUI;
if ~sum(ismember(fieldnames(DRT_GUI),'DRT')) || isempty(DRT_GUI.DRT) || numel(DRT_GUI.DRT.EI_DRT.peaks.tau)==0
    %msgbox(['Bitte zuerst eine DRT erstellen'])
    set(handles.TauTable,'visible','off')
    set(handles.TauCaption,'visible','off')
    return
end
set(handles.TauTable,'visible','on')
set(handles.TauCaption,'visible','on')
ColFormat = get(handles.TauTable,'ColumnFormat');
Parameter_Taus = textscan(strrep(DRT_GUI.Fit.aktuell_Modell.ModellCell{1,3},' ',''),'%s','delimiter',',');
Parameter_Taus = Parameter_Taus{1,1}(~cellfun(@isempty,strfind(Parameter_Taus{1,1}','Tau')));
if isempty(Parameter_Taus) , Parameter_Taus = {' '};end
ColFormat{3} = Parameter_Taus';
set(handles.TauTable,'ColumnFormat',ColFormat);

TauCell = get(handles.TauTable,'Data');
if size(TauCell,1)>numel(DRT_GUI.DRT.EI_DRT.peaks.tau),
    TauCell = TauCell(1:numel(DRT_GUI.DRT.EI_DRT.peaks.tau),:);
end
TauCell = cell2struct(TauCell',{'Tau','Used','Parameter'});

for i = 1:numel(DRT_GUI.DRT.EI_DRT.peaks.tau)
    TauCell(i,1).Tau = DRT_GUI.DRT.EI_DRT.peaks.tau(i);
    if sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT.peaks),'used')) && ...
            sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT.peaks),'used_parname')) && ...
            DRT_GUI.DRT.EI_DRT.peaks.used(i)
        
        TauCell(i,1).Used = true;
        TauCell(i,1).Parameter = DRT_GUI.DRT.EI_DRT.peaks.used_parname{i};
    else
        TauCell(i,1).Used = false;
        TauCell(i,1).Parameter = '';
    end
end
TauCell = struct2cell(TauCell)';
set(handles.TauTable,'Data',TauCell)


function ZustandTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to ZustandTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ZustandTextBox as text
%        str2double(get(hObject,'String')) returns contents of ZustandTextBox as a double
global DRT_GUI;
DRT_GUI.Testparameter.Zustand = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function ZustandTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZustandTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in BatterieNamePopup.
function BatterieNamePopup_Callback(hObject, eventdata, handles)
% hObject    handle to BatterieNamePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BatterieNamePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BatterieNamePopup
global DRT_GUI
Batterien = get(hObject,'string');
if isempty(Batterien) || numel(Batterien) == 1 ,return,end
if get(handles.BatterieNamePopup,'Value') == 1 && ~isempty(DRT_GUI) &&...
        sum(ismember(fieldnames(DRT_GUI),'Testparameter')) && ~isempty(DRT_GUI.Testparameter) &&...
        sum(ismember(fieldnames(DRT_GUI.Testparameter),'Batterie')) && ~isempty(DRT_GUI.Testparameter.Batterie)
    if ~isempty(find(ismember(Batterien,DRT_GUI.Testparameter.Batterie)))
        set(handles.BatterieNamePopup,'Value',find(ismember(Batterien,DRT_GUI.Testparameter.Batterie)))
    end
end


Folders = {''};
if get(handles.BatterieNamePopup,'Value') > 1
    f = dir(['output/' Batterien{get(hObject,'Value')} '/*']);
    for i = 1:numel(f)
        if ~strcmp(f(i).name,'.') && ~strcmp(f(i).name,'..') && f(i).isdir
            if ~isempty(DRT_GUI) && sum(ismember(fieldnames(DRT_GUI),'Testparameter')) &&...
                    ~isempty(DRT_GUI.Testparameter) && sum(ismember(fieldnames(DRT_GUI.Testparameter),'Temperatur')) &&...
                    ~isempty(DRT_GUI.Testparameter.Temperatur) && sum(ismember(fieldnames(DRT_GUI.Testparameter),'SOC'))&&...
                    ~isempty(DRT_GUI.Testparameter.SOC)
                
                f2 = dir(['output/' Batterien{get(hObject,'Value')} '/' f(i).name '/' ...
                    [strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad'] ...
                    '/' '*SOC.mat']);
                gefunden = 0;
                for fi = 1:numel(f2)
                    File_SOC = str2double(strrep(f2(fi).name(1+find(f2(fi).name=='_',1,'last'):end-numel('SOC.mat')),'m','-'));
                    if File_SOC > DRT_GUI.Testparameter.SOC-2.5 && File_SOC < DRT_GUI.Testparameter.SOC+2.5
                        gefunden = 1;
                        break
                    end
                end
                if gefunden;
                    Folders = [ Folders;f(i).name];
                else
                    Folders = [ Folders; '<HTML><FONT COLOR="gray">' f(i).name '</HTML>'];
                end
                
            else
                Folders = [Folders;f(i).name];
            end
        end
    end
end
set(handles.ZustandPopup,'string',Folders);
%set(handles.ZustandPopup,'string',{'<HTML><FONT COLOR="red" SIZE="10" FACE="ARIAL"><b><i>Here</i></b></HTML>','<HTML><FONT COLOR="blue" SIZE="4" FACE="Courier"><b>There</b></HTML>','<HTML><FONT COLOR="maroon" SIZE="6" FACE="GEORGIA">Anywhere</HTML>'})
set(handles.ZustandPopup,'value',1);
ZustandPopup_Callback(handles.ZustandPopup,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function BatterieNamePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BatterieNamePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ZustandPopup.
function ZustandPopup_Callback(hObject, eventdata, handles)
% hObject    handle to ZustandPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ZustandPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ZustandPopup

global DRT_GUI
Batterien = get(handles.BatterieNamePopup,'string');
Zustaende = killHTMLtags(get(handles.ZustandPopup,'string'));
if get(handles.ZustandPopup,'Value') == 1 && ~isempty(DRT_GUI) && ...
        sum(ismember(fieldnames(DRT_GUI),'Testparameter')) && ~isempty(DRT_GUI.Testparameter) &&...
        sum(ismember(fieldnames(DRT_GUI.Testparameter),'Zustand')) && ~isempty(DRT_GUI.Testparameter.Zustand)
    if ~isempty(find(ismember(Zustaende,DRT_GUI.Testparameter.Zustand)))
        set(handles.ZustandPopup,'Value',find(ismember(Zustaende,DRT_GUI.Testparameter.Zustand)))
    end
end

Folders = {''};
if get(handles.ZustandPopup,'Value') > 1
    f = dir(['output/' Batterien{get(handles.BatterieNamePopup,'Value')} '/'  Zustaende{get(handles.ZustandPopup,'Value')} '/*']);
    for i = 1:numel(f)
        if ~strcmp(f(i).name,'.') && ~strcmp(f(i).name,'..') && f(i).isdir
            Folders = [Folders;f(i).name];
        end
    end
end
set(handles.TemperaturPopup,'string',Folders);
set(handles.TemperaturPopup,'Value',1);
TemperaturPopup_Callback(handles.TemperaturPopup,eventdata,handles)

% --- Executes during object creation, after setting all properties.
function ZustandPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZustandPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TemperaturPopup.
function TemperaturPopup_Callback(hObject, eventdata, handles)
% hObject    handle to TemperaturPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TemperaturPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TemperaturPopup
global DRT_GUI
global alleTemperaturen
Batterien = get(handles.BatterieNamePopup,'string');
Zustaende = killHTMLtags( get(handles.ZustandPopup,'string'));
Temperaturen = get(handles.TemperaturPopup,'string');
alleTemperaturen = get(handles.TemperaturPopup,'string'); %Speichert sämtliche Temperaturen
%Ergänzung:
%Errechne die Anzahl der einzelnen Temperaturen:
if get(handles.TemperaturPopup,'Value') == 1 && ~isempty(DRT_GUI) &&...
        sum(ismember(fieldnames(DRT_GUI),'Testparameter')) && ~isempty(DRT_GUI.Testparameter) &&...
        sum(ismember(fieldnames(DRT_GUI.Testparameter),'Temperatur')) && ~isempty(DRT_GUI.Testparameter.Temperatur)
    if ~isempty(find(ismember(Temperaturen,[strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad'])))
        set(handles.TemperaturPopup,'Value',find(ismember(Temperaturen,[strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad'])))
    end
end
Folders = {''};
if get(handles.TemperaturPopup,'Value') > 1
    f = dir(['output/' Batterien{get(handles.BatterieNamePopup,'Value')} '/'  Zustaende{get(handles.ZustandPopup,'Value')} '/'  Temperaturen{get(handles.TemperaturPopup,'Value')} '/*SOC.mat']);
    for i = 1:numel(f)
        if ~strcmp(f(i).name,'.') && ~strcmp(f(i).name,'..') && ~f(i).isdir
            Folders = [Folders;...
                strrep(strrep(...
                strrep( ...
                strrep(...
                strrep(f(i).name,Batterien{get(handles.BatterieNamePopup,'Value')},'')...
                ,Zustaende{get(handles.ZustandPopup,'Value')},'')...
                ,Temperaturen{get(handles.TemperaturPopup,'Value')},'')...
                ,'_',''),'SOC.mat','')];
        end
    end
end


%Sortiert die Temperaturen im Folders-Ordner in aufsteigender Reihenfolge
matdata_vorzeichen_string = regexprep(Folders,'m','-');

matdata_vorzeichen_double = cellfun(@str2num,matdata_vorzeichen_string, 'UniformOutput',0);
double_matrix = cell2mat(matdata_vorzeichen_double);

double_matrix = sort(double_matrix);

double_cell = num2cell(double_matrix);
matdata_sortiert_string = cellfun(@num2str,double_cell, 'UniformOutput',0);
cellarray_sorted = [' '; matdata_sortiert_string];

cellarray_sorted = regexprep(cellarray_sorted,'-','m');

set(handles.SOCPopup,'string',cellarray_sorted);
set(handles.SOCPopup,'value',1);
SOCPopup_Callback(handles.TemperaturPopup,eventdata,handles)


% --- Executes during object creation, after setting all properties.
function TemperaturPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TemperaturPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SOCPopup.
function SOCPopup_Callback(hObject, eventdata, handles)
% hObject    handle to SOCPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SOCPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SOCPopup

global DRT_GUI
Batterien = get(handles.BatterieNamePopup,'string');
Zustaende = killHTMLtags(get(handles.ZustandPopup,'string'));
Temperaturen = get(handles.TemperaturPopup,'string');
SOCs = get(handles.SOCPopup,'string');
SOCsDbl = zeros(numel(SOCs)-1,1);
for i = 2:numel(SOCs)
    SOCsDbl(i-1) = str2num(strrep(SOCs{i},'m','-'));
end
%Ergänzung:
Folders = {''};
if get(handles.SOCPopup,'Value') == 1 && ~isempty(DRT_GUI) && ...
        sum(ismember(fieldnames(DRT_GUI),'Testparameter')) && ~isempty(DRT_GUI.Testparameter) &&...
        sum(ismember(fieldnames(DRT_GUI.Testparameter),'SOC')) && ~isempty(DRT_GUI.Testparameter.SOC) && ...
        (~strcmp(Batterien{get(handles.BatterieNamePopup,'Value')},DRT_GUI.Testparameter.Batterie) || ...
        ~strcmp(Zustaende{get(handles.ZustandPopup,'Value')},DRT_GUI.Testparameter.Zustand) || ...
        ~strcmp(Temperaturen{get(handles.TemperaturPopup,'Value')},[strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad']))
    
    nextSOC = 1+find(abs(SOCsDbl-DRT_GUI.Testparameter.SOC)==min(abs(SOCsDbl-DRT_GUI.Testparameter.SOC)),1,'first');
    if ~isempty(nextSOC)
        set(handles.SOCPopup,'Value',nextSOC)
    end
elseif get(handles.SOCPopup,'Value') == 1 && ~isempty(DRT_GUI) && ...
        sum(ismember(fieldnames(DRT_GUI),'Testparameter')) && ~isempty(DRT_GUI.Testparameter) &&...
        sum(ismember(fieldnames(DRT_GUI.Testparameter),'SOC')) && ~isempty(DRT_GUI.Testparameter.SOC)
    nextSOC = 1+find(SOCsDbl==DRT_GUI.Testparameter.SOC,1,'first');
    if ~isempty(nextSOC)
        set(handles.SOCPopup,'Value',nextSOC)
    end
    
end


if ~isempty(DRT_GUI) && sum(ismember(fieldnames(DRT_GUI),'Testparameter')) && ~isempty(DRT_GUI.Testparameter) &&...
        sum(ismember(fieldnames(DRT_GUI.Testparameter),'SOC')) && ~isempty(DRT_GUI.Testparameter.SOC) &&...
        strcmp(Batterien{get(handles.BatterieNamePopup,'Value')},DRT_GUI.Testparameter.Batterie) && ...
        strcmp(Zustaende{get(handles.ZustandPopup,'Value')},DRT_GUI.Testparameter.Zustand) && ...
        strcmp(Temperaturen{get(handles.TemperaturPopup,'Value')},[strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad']) && ...
        strcmp(SOCs{get(handles.SOCPopup,'Value')},[strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m')])
    
    %Nichts machen
elseif get(handles.SOCPopup,'Value') > 1
    f = dir(['output/' Batterien{get(handles.BatterieNamePopup,'Value')} '/'  Zustaende{get(handles.ZustandPopup,'Value')} '/'  Temperaturen{get(handles.TemperaturPopup,'Value')} '/*_' SOCs{get(handles.SOCPopup,'Value')} 'SOC.mat']);
    if ~isempty(f) && numel(f)==1
        load(['output/' Batterien{get(handles.BatterieNamePopup,'Value')} '/'  Zustaende{get(handles.ZustandPopup,'Value')} '/'  Temperaturen{get(handles.TemperaturPopup,'Value')} '/' f(1).name]);
        StructReparieren
        aktualisieren_Button_Callback(handles.aktualisieren_Button,eventdata,handles)
    end
end

function StructReparieren

    global DRT_GUI
    if ~isempty(DRT_GUI) && isstruct(DRT_GUI) && ismember('Fit',fieldnames(DRT_GUI)) && ...
        ~isempty(DRT_GUI.Fit) 
        if ismember('aktuell_Modell',fieldnames(DRT_GUI.Fit)) && numel(DRT_GUI.Fit.aktuell_Modell.ModellCell)>8 && ~isempty(DRT_GUI.Fit.aktuell_Modell.ModellCell{8})
            for i = 1:numel(DRT_GUI.Fit.aktuell_Modell.ModellCell{8})
                if ~ismember('Funktionsname',fieldnames(DRT_GUI.Fit.aktuell_Modell.ModellCell{8}{i}))
                    DRT_GUI.Fit.aktuell_Modell.ModellCell{8}{i}.Funktionsname = func2str(DRT_GUI.Fit.aktuell_Modell.ModellCell{8}{i}.f);
                end
                if ismember('f',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                    DRT_GUI.Fit.Implementierung.Info{i}=rmfield(DRT_GUI.Fit.Implementierung.Info{i},'f');
                end
                if ismember('Z',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                    DRT_GUI.Fit.Implementierung.Info{i}=rmfield(DRT_GUI.Fit.Implementierung.Info{i},'Z');
                end
                if ismember('Z_LF',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                    DRT_GUI.Fit.Implementierung.Info{i}=rmfield(DRT_GUI.Fit.Implementierung.Info{i},'Z_LF');
                end
                if ismember('Z_MF',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                    DRT_GUI.Fit.Implementierung.Info{i}=rmfield(DRT_GUI.Fit.Implementierung.Info{i},'Z_MF');
                end
                if ismember('Z_HF',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                    DRT_GUI.Fit.Implementierung.Info{i}=rmfield(DRT_GUI.Fit.Implementierung.Info{i},'Z_HF');
                end
            end
        end
    end

    
            

% --- Executes during object creation, after setting all properties.
function SOCPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SOCPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GueltigeMessungCheck.
function GueltigeMessungCheck_Callback(hObject, eventdata, handles)
% hObject    handle to GueltigeMessungCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GueltigeMessungCheck
global DRT_GUI
if isempty(DRT_GUI) || ~sum(ismember(fieldnames(DRT_GUI),'Messdaten'))
    set(hObject,'value',0)
    return
end

if sum(ismember(fieldnames(DRT_GUI),'Fit'))
    DRT_GUI.Fit.gueltig = get(hObject,'value');
else
    set(hObject,'value',0)
    return
end





% --- Executes on button press in spline_check.
function spline_check_Callback(hObject, eventdata, handles)
% hObject    handle to spline_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of spline_check


% --- Executes on button press in model_explorer_button.
function model_explorer_button_Callback(hObject, eventdata, handles)
% hObject    handle to model_explorer_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Modelhandle = model;
handles.mhandles = guidata(Modelhandle);
handles.mhandles.aktualisieren_button_Callback(handles.mhandles.aktualisieren_button,eventdata,handles.mhandles);
guidata(hObject,handles)

% --- Executes on button press in show_model_button.
function show_model_button_Callback(hObject, eventdata, handles)
% hObject    handle to show_model_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox(get(handles.ModellFormelTextBox,'String'))


% --- Executes on button press in fig1_export_button.
function fig1_export_button_Callback(hObject, eventdata, handles)
% hObject    handle to fig1_export_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
axes(handles.axes1);
[a,b,c,legende] = legend;
legendPosition = get(a,'Location');
AltePosition = get(handles.axes1,'Position');
AltePosition(1:2)=5;
newfig=figure('UnitS','characters','Position',AltePosition+10);
neueAchse=copyobj([a,handles.axes1],newfig);
set(neueAchse(2),'Position',AltePosition)
if isempty(dir('export'))
    mkdir('export')
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie])
end
savefig(['export/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie '_Nyquist_' ...
    DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_'...
    strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m') 'SOC'...
    '.fig'])

function fig2_export_button_Callback(hObject, eventdata, handles)
global DRT_GUI
axes(handles.axes2);
[a,b,c,legende] = legend;
legendPosition = get(a,'Location');
AltePosition = get(handles.axes2,'Position');
AltePosition(1:2)=5;
newfig=figure('UnitS','characters','Position',AltePosition+10);
neueAchse=copyobj([a,handles.axes2],newfig);
set(neueAchse(2),'Position',AltePosition)
if isempty(dir('export'))
    mkdir('export')
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie])
end
savefig(['export/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie '_Nyquist_MF_' ...
    DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_'...
    strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m') 'SOC'...
    '.fig'])


% --- Executes on button press in fig3_export_button.
function fig3_export_button_Callback(hObject, eventdata, handles)
% hObject    handle to fig3_export_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% axes(handles.axes3);
global DRT_GUI
figure;
plot_Auswaehl(DRT_GUI.Korrigiert,DRT_GUI.DRT.E_DRT,DRT_GUI.DRT.EI_DRT,[],'DRT',handles)
if isempty(dir('export'))
    mkdir('export')
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie])
end
savefig(['export/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie '_DRT_' ...
    DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_'...
    strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m') 'SOC'...
    '.fig'])

% [a,b,c,legende] = legend;
% legendPosition = get(a,'Location');
% x_label =  get(get(gca,'xlabel'),'string');
% y_label =  get(get(gca,'ylabel'),'string');
% xlimits = xlim;
% ylimits = ylim;
% figure;
% semilogx(1,1)
% new_ax = gca;
% copyobj(get(handles.axes3,'Children'),new_ax)
% grid on;
% xlabel(x_label);ylabel(y_label);
% xlim(xlimits)
% ylim(ylimits)
% axes(handles.axes3);
% % legend(legende,'Location',legendPosition);
% axes(new_ax);
% % legend(legende,'Location',legendPosition);


% --- Executes when entered data in editable cell(s) in TauTable.
function TauTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to TauTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
TauCell = get(handles.TauTable,'Data');
TauCell = cell2struct(TauCell',{'Tau','Used','Parameter'});
Parameter_Taus = textscan(strrep(DRT_GUI.Fit.aktuell_Modell.ModellCell{1,3},' ',''),'%s','delimiter',',');
Parameter_Taus = Parameter_Taus{1,1}(~cellfun(@isempty,strfind(Parameter_Taus{1,1}','Tau')));
if eventdata.Indices(2) == 2 % used checkbox
    if eventdata.NewData
        used_nr = 0;
        for i = 1:eventdata.Indices(1)-1
            index = find( strcmp(TauCell(i).Parameter,Parameter_Taus),1,'first');
            if index > used_nr , used_nr = index; end
        end
        if used_nr == numel( Parameter_Taus)
            TauCell(eventdata.Indices(1)).Parameter = '';
            TauCell(eventdata.Indices(1)).Used = false;
        else
            TauCell(eventdata.Indices(1)).Parameter = Parameter_Taus{used_nr+1};
        end
    else
        TauCell(eventdata.Indices(1)).Parameter = '';
    end
end
if eventdata.Indices(2) == 2 || eventdata.Indices(2) == 3 % used checkbox or Parameter Dropdown-Box
    if TauCell(eventdata.Indices(1)).Used
        used_nr = 0;
        
        for i = 1:numel(TauCell)
            index = find( strcmp(TauCell(i).Parameter,Parameter_Taus),1,'first');
            if ~isempty(index) && index <= used_nr
                if used_nr == numel( Parameter_Taus)
                    TauCell(i).Parameter = '';
                    TauCell(i).Used = false;
                else
                    used_nr = used_nr + 1;
                    TauCell(i).Parameter = Parameter_Taus{used_nr};
                end
            elseif ~isempty(index) && index > used_nr
                used_nr = index;
            end
        end
    else
        TauCell(eventdata.Indices(1)).Parameter = '';
    end
end
TauCell = struct2cell(TauCell)';
set(handles.TauTable,'Data',TauCell)
DRT_GUI.DRT.EI_DRT.peaks.used = cell2mat(TauCell(:,2));
DRT_GUI.DRT.EI_DRT.peaks.used_parname = TauCell(:,3);
axes(handles.axes3);
Typ = 'DRT';
plot_Auswaehl(DRT_GUI.Korrigiert,DRT_GUI.DRT.E_DRT,DRT_GUI.DRT.EI_DRT,[],Typ,handles)

% --- Executes on button press in GuessButton.
function GuessButton_Callback(hObject, eventdata, handles)
% hObject    handle to GuessButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;


if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten')))
    return
end
TableCell = get(handles.ParamTable,'Data');
TableCell = cell2struct(TableCell',{'Name','Fix','Value','Min','Max','Lim'});

TauCell = get(handles.TauTable,'Data');
TauCell = cell2struct(TauCell',{'tau','used','parname'});
[akt_P std_p] = getInitWerte(handles,DRT_GUI.Fit);
if isempty(akt_P)
    akt_P = cell2mat({TableCell.Value});
end
DRT_GUI.Fit.GrenzenBandbreite = 0.1*ones(numel(DRT_GUI.Fit.Parameter),2);
%Schreibt die Tau1, Tau2 Werte aus der Tautabelle in die Daten_Fix_Tabelle
for i = 1:numel(TauCell)
    parnummer = find(strcmp(TauCell(i).parname,DRT_GUI.Fit.aktuell_Modell.P_Name(1,:)));
    if ~isempty(parnummer)
        akt_P(parnummer) = TauCell(i).tau;
        
    end
end
DRT_GUI.Fit.Guessed_Parameters = akt_P;
DRT_GUI.Fit.Guessed_std = std_p;

for i_p = 1:numel(akt_P)
    if ~TableCell(i_p).Fix
        TableCell(i_p).Value = akt_P(i_p) ;
        if ~isempty(find(strcmp(TableCell(i_p).Name,{TauCell.parname}), 1))
            TableCell(i_p).Min = akt_P(i_p)/ 1.5;
            TableCell(i_p).Max = akt_P(i_p)* 1.5;
        end
    end
end
TableCell = struct2cell(TableCell)';
set(handles.ParamTable,'Data',TableCell)


PlotFittedParametersButton_Callback(handles.PlotFittedParametersButton, eventdata, handles)

% --- Executes on button press in MetaFitButton.
function MetaFitButton_Callback(hObject, eventdata, handles)
% hObject    handle to MetaFitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;

if strcmp(get(handles.MetaFitButton,'string'),'Stop')
    set(handles.MetaFitButton,'string','Meta-Fit')
    return
else
    set(handles.MetaFitButton,'string','Stop')
end

if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten')))
    return
end


if isempty(cell2mat(strfind(fieldnames(DRT_GUI.Fit),'Guessed_std'))),
    GuessButton_Callback(handles.GuessButton, eventdata, handles)
end

TableCell = get(handles.ParamTable,'Data');
TableCell = cell2struct(TableCell',{'Name','Fix','Value','Min','Max','Lim'});

akt_P = cell2mat({TableCell.Value});
std_p = DRT_GUI.Fit.Guessed_std;
while strcmp(get(handles.MetaFitButton,'string'),'Stop')
    TableCell = get(handles.ParamTable,'Data');
    TableCell = cell2struct(TableCell',{'Name','Fix','Value','Min','Max','Lim'});
    for i_p = 1:numel(akt_P)
        if ~TableCell(i_p).Fix
            %TableCell(i_p).Value = akt_P(i_p) ;
            if strfind(TableCell(i_p).Name,'Tau')
                TableCell(i_p).Min = akt_P(i_p)*(10^(-DRT_GUI.Fit.GrenzenBandbreite(i_p,1)/20));
                TableCell(i_p).Max = akt_P(i_p)*(10^(DRT_GUI.Fit.GrenzenBandbreite(i_p,2)/20));
            elseif strfind(TableCell(i_p).Name,'Phi')
                TableCell(i_p).Min = akt_P(i_p)-DRT_GUI.Fit.GrenzenBandbreite(i_p,1)*0.1;
                TableCell(i_p).Max = akt_P(i_p)+DRT_GUI.Fit.GrenzenBandbreite(i_p,2)*0.1;
            elseif ~strcmp(TableCell(i_p).Name,'Rser') && ~strcmp(TableCell(i_p).Name,'C') && ~strcmp(TableCell(i_p).Name,'Cser')&& ~strcmp(TableCell(i_p).Name,'Kskin')&& ~strcmp(TableCell(i_p).Name,'Lser')
                TableCell(i_p).Min = akt_P(i_p)-DRT_GUI.Fit.GrenzenBandbreite(i_p,1)*std_p(i_p);
                TableCell(i_p).Max = akt_P(i_p)+DRT_GUI.Fit.GrenzenBandbreite(i_p,2)*std_p(i_p);
            end
            
            if TableCell(i_p).Min < DRT_GUI.Fit.aktuell_Modell.ModellCell{5}{i_p}
                TableCell(i_p).Min = DRT_GUI.Fit.aktuell_Modell.ModellCell{5}{i_p};
            end
            if TableCell(i_p).Max > DRT_GUI.Fit.aktuell_Modell.ModellCell{6}{i_p}
                TableCell(i_p).Max = DRT_GUI.Fit.aktuell_Modell.ModellCell{6}{i_p};
            end
            set(handles.GrenzenBandbreiteText,'string',[num2str(max(DRT_GUI.Fit.GrenzenBandbreite(:))*100) '%'])
        end
    end
    set(handles.ParamTable,'Data',struct2cell(TableCell)')
    
    for Fittingdurchgaenge = 1:3
        
        
        FitButton_Callback(handles.FitButton, eventdata, handles)
        
        
        index_min = DRT_GUI.Fit.Limit_Reached.index_min;
        index_max = DRT_GUI.Fit.Limit_Reached.index_max;
        if  ~(numel(index_min) == 0  && numel(index_max) == 0)
            DRT_GUI.Fit.GrenzenBandbreite(index_min,1) = DRT_GUI.Fit.GrenzenBandbreite(index_min,1)+0.1;
            DRT_GUI.Fit.GrenzenBandbreite(index_max,2) = DRT_GUI.Fit.GrenzenBandbreite(index_max,2)+0.1;
            break;
        end
    end
    if  numel(index_min) == 0  && numel(index_max) == 0
        set(handles.MetaFitButton,'string','Meta-Fit')
    end
end


% --- Executes on button press in PlotFittedParametersButton.
function PlotFittedParametersButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlotFittedParametersButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;


if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten')))
    return
end

if ~strcmp(eventdata,'kein_plot')
    (handles.axes1); hold off;
else
end

Typ = 'Fit';
formula = DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell;
formula_komp = DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_komp;
if  isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) || isempty(DRT_GUI.Messdaten.relax_fft)
    m_w = DRT_GUI.Messdaten.omega(DRT_GUI.Messdaten.aktiv==1) ;
    m_real = DRT_GUI.Messdaten.Zreal(DRT_GUI.Messdaten.aktiv==1);
    m_imag = DRT_GUI.Messdaten.Zimg(DRT_GUI.Messdaten.aktiv==1);
else
    m_w = [DRT_GUI.Messdaten.omega(DRT_GUI.Messdaten.aktiv==1) ; DRT_GUI.Messdaten.relax_fft.omega(DRT_GUI.Messdaten.relax_fft.aktiv==1)] ;
    m_real = [DRT_GUI.Messdaten.Zreal(DRT_GUI.Messdaten.aktiv==1); DRT_GUI.Messdaten.relax_fft.Zreal(DRT_GUI.Messdaten.relax_fft.aktiv==1)+DRT_GUI.Messdaten.relax_fft.Zreal_korrektur];
    m_imag = [DRT_GUI.Messdaten.Zimg(DRT_GUI.Messdaten.aktiv==1); DRT_GUI.Messdaten.relax_fft.Zimg(DRT_GUI.Messdaten.relax_fft.aktiv==1)];
end

TableCell = get(handles.ParamTable,'Data');
TableCell = cell2struct(TableCell',{'Name','Fix','Value','Min','Max','Lim'});
p_best = cell2mat({TableCell.Value});
% Residuum
distances=zeros(1,length(m_real));
p = p_best; w = m_w;
f_real = real(eval(formula));
f_imag = imag(eval(formula));
for m=1:length(m_real)
    distances(m)=sqrt((m_real(m)-f_real(m))^2+(m_imag(m)-f_imag(m))^2);
end
resid=sum(distances)/length(distances);
DRT_GUI.Fit.residuum = resid;
set(handles.Residuum,'string',num2str(resid));
p = p_best;

w = m_w;

f_real = real(eval(formula));
f_imag = imag(eval(formula));

DRT_GUI.Fit.Zreal = f_real;
DRT_GUI.Fit.Zimg = f_imag;
DRT_GUI.Fit.frequenz = w/2/pi;
DRT_GUI.Fit.omega = w;
DRT_GUI.Fit.tau = 1./w;
DRT_GUI.Fit.Z = f_real + 1i * f_imag;
if ~strcmp(eventdata,'kein_plot')
    axes(handles.axes1); hold off;
    plot_Auswaehl(DRT_GUI.Messdaten,DRT_GUI.Fit,[],DRT_GUI.Testparameter.Batterie,Typ)
    % Modellelemente plotten, falls der ESB-Generator genutzt wurde
    if get(handles.PlotElementsCheckbox,'Value') && ~isempty(DRT_GUI.Fit.aktuell_Modell.ModellCell{8})
        
        if ~get(handles.cont_process_checkbox,'value')
            % DRT unsichtbar machen
            set(handles.HFLF_Axes_Panel,'visible','on')
            set(handles.DRT_Axes_Panel,'Visible','off')
        end
        
        Z_LF = eval(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_LF);
        Z_HF = eval(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_HF);
        Z_MF = eval(DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_MF);
               
        FarbenLaden
        
        axes(handles.axes6);hold off
        plot(m_real-real(Z_HF+Z_MF),m_imag-imag(Z_HF+Z_MF),'o','color',RWTHBlau,'displayname','LF-Messung','LineWidth',1,'MarkerSize',7)
        grid on; axis square; axis equal; set(gca,'ydir', 'reverse');hold on;
        xlabel('$\Re\{\underline Z\}$ in $\Omega$','Interpreter','latex');ylabel('$\Im\{\underline Z\}$ in $\Omega$','Interpreter','latex'); %title(Plot_Title,'Interpreter','none');
        plot(real(Z_LF),imag(Z_LF),'x','color',RWTHRot,'displayname','LF-Fit','LineWidth',1,'MarkerSize',7)
        h1 = legend('LF-Messung','LF-Fit');
        set(h1,'Interpreter','none','Location','NorthWest');
        
        axes(handles.axes5);hold off
        plot(m_real-real(Z_LF+Z_MF),m_imag-imag(Z_LF+Z_MF),'o','color',RWTHBlau,'displayname','HF-Messung','LineWidth',1,'MarkerSize',7)
        grid on; axis square; axis equal; set(gca,'ydir', 'reverse');hold on;
        xlabel('$\Re\{\underline Z\}$ in $\Omega$','Interpreter','latex');ylabel('$\Im\{\underline Z\}$ in $\Omega$','Interpreter','latex'); %title(Plot_Title,'Interpreter','none');
        plot(real(Z_HF),imag(Z_HF),'x','color',RWTHRot,'displayname','HF-Fit','LineWidth',1,'MarkerSize',7)
        h1 = legend('HF-Messung','HF-Fit');
        set(h1,'Interpreter','none','Location','NorthEast');
        
        axes(handles.axes1);
        Zreal_vorher=0;Zreal_vorher_LF=0;Zreal_vorher_HF=0;
        if numel(DRT_GUI.Fit.aktuell_Modell.ModellCell)>=8
        for i = 1:numel(DRT_GUI.Fit.aktuell_Modell.ModellCell{8})
            
            Modell = DRT_GUI.Fit.aktuell_Modell.ModellCell{8}{i};
            
            axes(handles.axes1);
            Zfun = Modell.Zfun;
            for j = 1:numel(Modell.ParameterIndexes)
                Zfun = strrep(Zfun,Modell.inputs{j},['p(' num2str(Modell.ParameterIndexes(j)) ')']);
            end
            Z = eval(Zfun);
            index = find(abs(imag(Z))>(mean(abs(imag(Z)))*3),1,'first');
            if isempty(index), index = 1; end
            if index>numel(Zreal_vorher),
                index2=numel(Zreal_vorher);
            else
                index2 = index + find(Zreal_vorher(index:end)<Zreal_vorher(index),1,'last')-1;
            end
            if isempty(index2) 
                realverschiebung = Zreal_vorher(index); 
            else
                realverschiebung =  Zreal_vorher(index2);
                Zreal_vorher(1:index2) = Zreal_vorher(index2);
            end
            if Modell.Plot  
                plot(real(Z)+realverschiebung,imag(Z),'k','display',Modell.Name)
            end
            Zreal_vorher = Zreal_vorher(end)+real(Z);
            
            
            axes(handles.axes6);
            Zfun_LF = Modell.Zfun_LF;
            for j = 1:numel(Modell.ParameterIndexes)
                Zfun_LF = strrep(Zfun_LF,Modell.inputs{j},['p(' num2str(Modell.ParameterIndexes(j)) ')']);
            end
            if ~strcmp(Zfun_LF,'0')
                Z = eval(Zfun_LF);
                index = find(abs(imag(Z))>(mean(abs(imag(Z)))*3),1,'first');
                if isempty(index), index = 1; end
                if index>numel(Zreal_vorher_LF),
                    index2=numel(Zreal_vorher_LF);
                else
                    index2 = index + find(Zreal_vorher_LF(index:end)<Zreal_vorher_LF(index),1,'last')-1;
                end
                if isempty(index2), index2 = index; end
                realverschiebung =  Zreal_vorher_LF(index2);
                if Modell.Plot  
                    plot(real(Z)+realverschiebung,imag(Z),'k','display',Modell.Name)
                end
                Zreal_vorher_LF = Zreal_vorher_LF+real(Z);
            end
            
            axes(handles.axes5);
            Zfun_HF = Modell.Zfun_HF;
            for j = 1:numel(Modell.ParameterIndexes)
                Zfun_HF = strrep(Zfun_HF,Modell.inputs{j},['p(' num2str(Modell.ParameterIndexes(j)) ')']);
            end
            if ~strcmp(Zfun_HF,'0')
                Z = eval(Zfun_HF);
                index = find(abs(imag(Z))>(mean(abs(imag(Z)))*3),1,'first');
                if isempty(index), index = 1; end
                if index>numel(Zreal_vorher_HF),
                    index2=numel(Zreal_vorher_HF);
                else
                    index2 = index + find(Zreal_vorher_HF(index:end)<Zreal_vorher_HF(index),1,'last')-1;
                end
                if isempty(index2), index2 = index; end
                realverschiebung =  Zreal_vorher_HF(index2);
                if Modell.Plot  
                    plot(real(Z)+realverschiebung,imag(Z),'k','display',Modell.Name)
                end
                Zreal_vorher_HF = Zreal_vorher_HF+real(Z);
            end
        end
        end
    else
        set(handles.HFLF_Axes_Panel,'visible','off')
        set(handles.DRT_Axes_Panel,'Visible','on')

    end
    
   
else
end

f_real = real(eval(formula_komp));
f_imag = imag(eval(formula_komp));
DRT_GUI.Fit.korrigiert.Z = f_real + 1i *f_imag;
DRT_GUI.Fit.korrigiert.Zreal = f_real ;
DRT_GUI.Fit.korrigiert.Zimg =  f_imag;
Hz50 = find(w==(2*pi*50));

DRT_GUI.Korrigiert = DRT_GUI.Messdaten;
if  ~isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) && ~isempty(DRT_GUI.Messdaten.relax_fft)
    
    DRT_GUI.Korrigiert.omega = [DRT_GUI.Messdaten.omega(DRT_GUI.Messdaten.aktiv==1) ; DRT_GUI.Messdaten.relax_fft.omega(DRT_GUI.Messdaten.relax_fft.aktiv==1)] ;
    DRT_GUI.Korrigiert.Zreal = [DRT_GUI.Messdaten.Zreal(DRT_GUI.Messdaten.aktiv==1); DRT_GUI.Messdaten.relax_fft.Zreal(DRT_GUI.Messdaten.relax_fft.aktiv==1)+DRT_GUI.Messdaten.relax_fft.Zreal_korrektur];
    DRT_GUI.Korrigiert.Zimg = [DRT_GUI.Messdaten.Zimg(DRT_GUI.Messdaten.aktiv==1); DRT_GUI.Messdaten.relax_fft.Zimg(DRT_GUI.Messdaten.relax_fft.aktiv==1)];
    DRT_GUI.Korrigiert.Z = DRT_GUI.Korrigiert.Zreal + 1i * DRT_GUI.Korrigiert.Zimg;
    DRT_GUI.Korrigiert.frequenz = DRT_GUI.Korrigiert.omega /2/pi;
    DRT_GUI.Korrigiert.tau = 1./ DRT_GUI.Korrigiert.omega ;
else
    DRT_GUI.Korrigiert.omega = [DRT_GUI.Messdaten.omega(DRT_GUI.Messdaten.aktiv==1) ] ;
    DRT_GUI.Korrigiert.Zreal = [DRT_GUI.Messdaten.Zreal(DRT_GUI.Messdaten.aktiv==1)];
    DRT_GUI.Korrigiert.Zimg = [DRT_GUI.Messdaten.Zimg(DRT_GUI.Messdaten.aktiv==1)];
    DRT_GUI.Korrigiert.Z = DRT_GUI.Korrigiert.Zreal + 1i * DRT_GUI.Korrigiert.Zimg;
    DRT_GUI.Korrigiert.frequenz = DRT_GUI.Korrigiert.omega /2/pi;
    DRT_GUI.Korrigiert.tau = 1./ DRT_GUI.Korrigiert.omega ;
    
end


if numel(Hz50 == 1)
    DRT_GUI.Fit.korrigiert.Zreal(Hz50) = spline(log(w([1:(Hz50-1) (Hz50+1):end])),f_real([1:(Hz50-1) (Hz50+1):end]),log(2*pi*50));
    DRT_GUI.Fit.korrigiert.Zimg(Hz50) = spline(log(w([1:(Hz50-1) (Hz50+1):end])),f_imag([1:(Hz50-1) (Hz50+1):end]),log(2*pi*50));
    DRT_GUI.Fit.korrigiert.Z(Hz50) = DRT_GUI.Fit.korrigiert.Zreal(Hz50) + 1i * DRT_GUI.Fit.korrigiert.Zimg(Hz50);
    DRT_GUI.Korrigiert.Zreal(Hz50) = spline(log(w([1:(Hz50-1) (Hz50+1):end])),DRT_GUI.Korrigiert.Zreal([1:(Hz50-1) (Hz50+1):end]),log(2*pi*50));
    DRT_GUI.Korrigiert.Zimg(Hz50) =  spline(log(w([1:(Hz50-1) (Hz50+1):end])),DRT_GUI.Korrigiert.Zimg( [1:(Hz50-1) (Hz50+1):end]),log(2*pi*50));
    DRT_GUI.Korrigiert.Z(Hz50) = DRT_GUI.Korrigiert.Zreal(Hz50) + 1i * DRT_GUI.Korrigiert.Zimg(Hz50);
    
end



DRT_GUI.Korrigiert.Z = DRT_GUI.Korrigiert.Z - DRT_GUI.Fit.Z + DRT_GUI.Fit.korrigiert.Z  ;
DRT_GUI.Korrigiert.Zreal = DRT_GUI.Korrigiert.Zreal - DRT_GUI.Fit.Zreal  + DRT_GUI.Fit.korrigiert.Zreal ;
DRT_GUI.Korrigiert.Zimg = DRT_GUI.Korrigiert.Zimg - DRT_GUI.Fit.Zimg + DRT_GUI.Fit.korrigiert.Zimg ;

if isempty(get( handles.Korrigiert_Punkte_Weg_TextBox,'string'))
    Erster_Wert = find(DRT_GUI.Korrigiert.Zimg<0,1,'first');
    if isempty(Erster_Wert)
        String1 = '';
    elseif Erster_Wert == 1
        String1 = ['1:' num2str(Erster_Wert) , ', '];
    else
        String1 = ['1:' num2str(Erster_Wert-1) , ', '];
    end
    Letzter_Wert = Erster_Wert + find(DRT_GUI.Korrigiert.Zimg(Erster_Wert+1:end)>0,1,'first')-1;
    if  ~sum(DRT_GUI.Messdaten.aktiv)
        String2 = [num2str(numel(DRT_GUI.Korrigiert.Z)) ':' num2str(numel(DRT_GUI.Korrigiert.Z)) ];
        
    elseif Letzter_Wert<0.5*numel(DRT_GUI.Korrigiert.Z)
        
        String2 = [num2str(find(DRT_GUI.Messdaten.aktiv,1,'first')) ':' num2str(numel(DRT_GUI.Korrigiert.Z)) ];
        
    elseif isempty(Letzter_Wert)
        String2 = [num2str(find(DRT_GUI.Messdaten.aktiv,1,'last')) ':' num2str(numel(DRT_GUI.Korrigiert.Z)) ];
    else
        String2 = [ num2str(Letzter_Wert+1) ':' num2str(numel(DRT_GUI.Korrigiert.Z))];
    end
    set(handles.Korrigiert_Punkte_Weg_TextBox,'string',[String1 String2])
end
Korrigiert_Punkte_Weg_Button_Callback(handles.Korrigiert_Punkte_Weg_Button, eventdata, handles)
if ~strcmp(eventdata,'kein_plot')
    
else
end

% --- Executes on button press in InitHF_FittButton.
function InitHF_FittButton_Callback(hObject, eventdata, handles)
% hObject    handle to InitHF_FittButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
NullPunkt = find(DRT_GUI.Messdaten.Zreal==min(DRT_GUI.Messdaten.Zreal),1,'first');
%if NullPunkt == 1, return,end
NullPunkt = NullPunkt+4;
Schnittpunkt = find(DRT_GUI.Messdaten.Zreal>min(DRT_GUI.Messdaten.Zreal) & DRT_GUI.Messdaten.Zimg<0,1,'first');
if Schnittpunkt == 1, return,end
Schnittpunkt=Schnittpunkt+4;
PunkteWegVorher = get(handles.PunkteWegnehmenTextBox,'string');
set(handles.PunkteWegnehmenTextBox,'string',[num2str(Schnittpunkt) ':' num2str(numel(DRT_GUI.Messdaten.frequenz)) ])
PunkteWegnehmenButton_Callback(handles.PunkteWegnehmenButton, eventdata, handles)
KorrigiertPunkteWegVorher = get(handles.Korrigiert_Punkte_Weg_TextBox,'string');
set(handles.Korrigiert_Punkte_Weg_TextBox,'string','')
Korrigiert_Punkte_Weg_Button_Callback(handles.Korrigiert_Punkte_Weg_Button, eventdata, handles)


if ~isempty(find(strcmp(fieldnames(DRT_GUI.Messdaten),'relax_fft'), 1)) && ~isempty(DRT_GUI.Messdaten.relax_fft)
    Relax_fft_PunkteWegVorher = get(handles.RelaxFFT_PunkteWegnehmenTextBox,'string');
    set(handles.RelaxFFT_PunkteWegnehmenTextBox,'string','1:end')
    RelaxFFT_PunkteWegnehmenButton_Callback(handles.RelaxFFT_PunkteWegnehmenButton, eventdata, handles)
end

Parameter_liste = textscan(strrep(DRT_GUI.Fit.aktuell_Modell.ModellCell{1,3},' ',''),'%s','delimiter',',');
Parameter_liste = Parameter_liste{1};
R_index = find(~cellfun(@isempty,regexp(Parameter_liste','(Sigma|R)(2|3|4|5|6|7|8|9|10|_|por)')));
Cser_index = find(~cellfun(@isempty,regexp(Parameter_liste','Cser|CLim(1|2|3|4|5|6|7|8|9|10)|CLim|C_|CLim_')));
HF_index = find(~cellfun(@isempty,regexp(Parameter_liste','Kskin|Lser|RL|PhiL|L0|Rind|Lind|Phiind')));
Zarc1_index =find(~cellfun(@isempty,regexp(Parameter_liste','R1|Tau1|Phi1')));
if isempty(Zarc1_index)
    Zarc1_index = R_index(1);
    R_index(1)=[];
end
    

TableCell = get(handles.ParamTable,'Data');
%TableCell = cell2struct(TableCell',{'Name','Fix','Value','Min','Max','Lim'});
alt_R_fix = TableCell(R_index,2);
alt_R_values = TableCell(R_index,3);
alt_Cser_fix = TableCell(Cser_index,2);
alt_Cser_values = TableCell(Cser_index,3);
alt_Zarc1_fix = TableCell(Zarc1_index,2);
alt_Zarc1_values = TableCell(Zarc1_index,3);
alt_Zarc1_min = TableCell(Zarc1_index,4);
alt_Zarc1_max = TableCell(Zarc1_index,5);

TableCell(R_index,2) = {true};
TableCell(R_index,3) = {0};
TableCell(Cser_index,2) = {true};
TableCell(Cser_index,3) = {1e19};
TableCell(HF_index,2) = {false};
TableCell(Zarc1_index,2) = {false};
TableCell(Zarc1_index,4) = {0};
TableCell(Zarc1_index,5) = {inf};

set(handles.ParamTable,'Data',TableCell);

FitButton_Callback(handles.FitButton, eventdata, handles)
FitButton_Callback(handles.FitButton, eventdata, handles)
FitButton_Callback(handles.FitButton, eventdata, handles)
% pause(2)
TableCell = get(handles.ParamTable,'Data');

TableCell(R_index,2) = alt_R_fix;
TableCell(R_index,3) = alt_R_values;
TableCell(Cser_index,2) = alt_Cser_fix;
TableCell(Cser_index,3) = alt_Cser_values;
TableCell(HF_index,2) = {true};
TableCell(Zarc1_index,2) = alt_Zarc1_fix;
TableCell(Zarc1_index,3) = alt_Zarc1_values;
TableCell(Zarc1_index,4) = alt_Zarc1_min;
TableCell(Zarc1_index,5) = alt_Zarc1_max;

set(handles.ParamTable,'Data',TableCell);

set(handles.PunkteWegnehmenTextBox,'string',PunkteWegVorher)
PunkteWegnehmenButton_Callback(handles.PunkteWegnehmenButton, eventdata, handles)


FitButton_Callback(handles.FitButton, eventdata, handles)

set(handles.Korrigiert_Punkte_Weg_TextBox,'string',KorrigiertPunkteWegVorher)
Korrigiert_Punkte_Weg_Button_Callback(handles.Korrigiert_Punkte_Weg_Button, eventdata, handles)


if ~isempty(find(strcmp(fieldnames(DRT_GUI.Messdaten),'relax_fft'), 1)) && ~isempty(DRT_GUI.Messdaten.relax_fft)
    set(handles.RelaxFFT_PunkteWegnehmenTextBox,'string',Relax_fft_PunkteWegVorher);
    RelaxFFT_PunkteWegnehmenButton_Callback(handles.RelaxFFT_PunkteWegnehmenButton, eventdata, handles)
end

% --- Executes on button press in AutoCapCheckBox.
function AutoCapCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to AutoCapCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AutoCapCheckBox


% --- Executes on button press in CopyButton.
function CopyButton_Callback(hObject, eventdata, handles)
% hObject    handle to CopyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CopyFit
global DRT_GUI
if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Fit')))
    return
end
CopyFit.Fit = DRT_GUI.Fit;
CopyFit.PunkteWegnehmenTextBox = get(handles.PunkteWegnehmenTextBox,'String');
CopyFit.Korrigiert_Punkte_Weg_TextBox = get(handles.Korrigiert_Punkte_Weg_TextBox,'String');
CopyFit.RelaxFFT_PunkteWegnehmenTextBox = get(handles.RelaxFFT_PunkteWegnehmenTextBox,'String');
CopyFit.DRT = DRT_GUI.DRT;


% --- Executes on button press in PasteButton.
function PasteButton_Callback(hObject, eventdata, handles)
% hObject    handle to PasteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
global CopyFit
global DRT_Config
if ~isempty(CopyFit)
    DRT_GUI.Fit = CopyFit.Fit;
    set(handles.PunkteWegnehmenTextBox,'String',CopyFit.PunkteWegnehmenTextBox)
    PunkteWegnehmenButton_Callback(handles.PunkteWegnehmenButton, eventdata, handles)
    set(handles.Korrigiert_Punkte_Weg_TextBox,'String',CopyFit.Korrigiert_Punkte_Weg_TextBox)
    Korrigiert_Punkte_Weg_Button_Callback(handles.Korrigiert_Punkte_Weg_Button, eventdata, handles)
    set(handles.RelaxFFT_PunkteWegnehmenTextBox,'String',CopyFit.RelaxFFT_PunkteWegnehmenTextBox)
    DRT_GUI.DRT = CopyFit.DRT;
    DRT_Config=DRT_GUI.DRT.Config;
    aktualisieren_Button_Callback(handles.aktualisieren_Button, eventdata, handles)
end

% --- Executes on button press in LF_Fit_Button.
function LF_Fit_Button_Callback(hObject, eventdata, handles)
% hObject    handle to LF_Fit_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI

if 0 && sum(strcmp(fields(DRT_GUI.Messdaten),'relax')) ...
        && sum(strcmp(fields(DRT_GUI.Messdaten.relax),'spannung'))  ...
        && sum(strcmp(fields(DRT_GUI.Messdaten.relax),'zeit'))  ...
        && numel(DRT_GUI.Messdaten.relax.spannung)>0 ...
        && ( sum(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'CLim')) ||...
        sum(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Cser'))||...
        sum(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'CSer'))||...
        sum(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'C0')))
    % es gibt eine gespeicherte Relaxation vor der Messung
    % Das Modell enthällt eine Serienkapazität
    % Die letzten 60 Minuten sollen gefittet werden
    FitIndex = find((DRT_GUI.Messdaten.relax.zeit(end)-DRT_GUI.Messdaten.relax.zeit)<3600);
    
    FitSpannung = DRT_GUI.Messdaten.relax.spannung(FitIndex);
    FitZeit = DRT_GUI.Messdaten.relax.zeit(FitIndex)-DRT_GUI.Messdaten.relax.zeit(FitIndex(1));
    
    p_init = [1000 FitSpannung(end) FitSpannung(1)-FitSpannung(end)];
    modelformel = 'p(2)+p(3).*exp(-w./p(1))';
    options = optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-12,'TolFun',1e-12);
    [p,fval,exitflag,output]=function_fit_easyfit2(FitZeit,[FitSpannung, zeros(size(FitSpannung))],p_init,@function_model_all_types2, [0 0 -inf ], [inf,inf,inf] ,options, modelformel);
    w = FitZeit;
    NeuSpannung = eval(modelformel);
    w = 1e19;
    EndSpannung = eval(modelformel);
    if ~strcmp(eventdata,'kein_plot')
        figure;
        plot(DRT_GUI.Messdaten.relax.zeit,DRT_GUI.Messdaten.relax.spannung)
        grid on,hold on
        plot(DRT_GUI.Messdaten.relax.zeit(FitIndex(1))+FitZeit,NeuSpannung,'r')
        plot(DRT_GUI.Messdaten.relax.zeit,repmat(EndSpannung, size(DRT_GUI.Messdaten.relax.zeit)),'--k')
        plot(DRT_GUI.Messdaten.relax.zeit,repmat(DRT_GUI.Messdaten.relax.spannung(1), size(DRT_GUI.Messdaten.relax.zeit)),'--k')
    end
    
    CLimNr = find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'CLim'));
    if isempty(CLimNr),CLimNr = find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Cser'));end
    if isempty(CLimNr),CLimNr = find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'CSer'));end
    if isempty(CLimNr),CLimNr = find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'C0'));end
    Ladung = [0 cumsum(DRT_GUI.Messdaten.relax.strom(1:end-1) .* diff(DRT_GUI.Messdaten.relax.zeit))];
    TableCell = get(handles.ParamTable,'Data');
    
    TableCell{CLimNr,2}=true;
    TableCell{CLimNr,3}=Ladung(end)/(EndSpannung-DRT_GUI.Messdaten.relax.spannung(1));
    
    set(handles.ParamTable,'Data',TableCell);
    FitButton_Callback(handles.FitButton, eventdata, handles)
    
else
    
    PunkteWegVorher = get(handles.PunkteWegnehmenTextBox,'string');
    
    set(handles.PunkteWegnehmenTextBox,'string','1:end-2')
    PunkteWegnehmenButton_Callback(handles.PunkteWegnehmenButton, eventdata, handles)
    Parameter_liste = textscan(strrep(DRT_GUI.Fit.aktuell_Modell.ModellCell{1,3},' ',''),'%s','delimiter',',');
    Parameter_liste = Parameter_liste{1};
    R_index = find(~cellfun(@isempty,regexp(Parameter_liste','R(2|3|4|5|6|7|8|9|10)')));
    Tau1_index = find(~cellfun(@isempty,regexp(Parameter_liste','Tau1')));
    R1_index = find(~cellfun(@isempty,regexp(Parameter_liste','R1')));
    Rser_index = find(~cellfun(@isempty,regexp(Parameter_liste','Rser')));
    Cser_index = find(~cellfun(@isempty,regexp(Parameter_liste','Cser')));
    HF_index = find(~cellfun(@isempty,regexp(Parameter_liste','Rser|Kskin|Lser')));
    %Zarc1_index =find(~cellfun(@isempty,regexp(Parameter_liste','R1|Tau1|Phi1')));
    TableCell = get(handles.ParamTable,'Data');
    %TableCell = cell2struct(TableCell',{'Name','Fix','Value','Min','Max','Lim'});
    alt_R_fix = TableCell(R_index,2);
    alt_R_values = TableCell(R_index,3);
    alt_R1_fix = TableCell(R1_index,2);
    alt_R1_values = TableCell(R1_index,3);
    alt_Tau1_fix = TableCell(Tau1_index,2);
    alt_Tau1_values = TableCell(Tau1_index,3);
    alt_HF_fix = TableCell(HF_index,2);
    alt_HF_values = TableCell(HF_index,3);
    alt_Rser_fix = TableCell(Rser_index,2);
    alt_Rser_values = TableCell(Rser_index,3);
    TableCell(R_index,2) = {true};
    TableCell(R_index,3) = {0};
    TableCell(R1_index,2) = {false};
    TableCell(Tau1_index,3) = {0};
    TableCell(Tau1_index,2) = {true};
    TableCell(Rser_index,2) = {true};
    TableCell(HF_index,2) = {true};
    
    TableCell(Cser_index,2) = {false};
    set(handles.ParamTable,'Data',TableCell);
    
    FitButton_Callback(handles.FitButton, eventdata, handles)
    FitButton_Callback(handles.FitButton, eventdata, handles)
    FitButton_Callback(handles.FitButton, eventdata, handles)
    % pause(2)
    TableCell = get(handles.ParamTable,'Data');
    
    TableCell(R_index,2) = alt_R_fix;
    TableCell(R_index,3) = alt_R_values;
    TableCell(R1_index,2) = alt_R1_fix;
    TableCell(R1_index,3) = alt_R1_values;
    TableCell(Tau1_index,2) = alt_Tau1_fix;
    TableCell(Tau1_index,3) = alt_Tau1_values;
    TableCell(Rser_index,2) = alt_Rser_fix;
    TableCell(Rser_index,3) = alt_Rser_values;
    TableCell(HF_index,2) = alt_HF_fix;
    TableCell(HF_index,3) = alt_HF_values;
    % TableCell(Cser_index,2) = {true};
    
    set(handles.ParamTable,'Data',TableCell);
    
    set(handles.PunkteWegnehmenTextBox,'string',PunkteWegVorher)
    PunkteWegnehmenButton_Callback(handles.PunkteWegnehmenButton, eventdata, handles)
end
% --- Executes on button press in analyze_Button.
function analyze_Button_Callback(hObject, eventdata, handles)
% hObject    handle to analyze_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
batteriename_pop_handle = @BatterieNamePopup_Callback;
zustand_pop_handle = @ZustandPopup_Callback;
temp_pop_handle = @TemperaturPopup_Callback;
soc_pop_handle = @SOCPopup_Callback;
hf_correction_handle = @HFcorrectionButton_Callback;
lf_correction_handle = @LF_Fit_Button_Callback;
FitButton_handle = @FitButton_Callback;
korrigiert_punkte_handle = @Korrigiert_Punkte_Weg_Button_Callback;
drt_button_handle = @DRTButton_Callback;
aktualisieren_button_handle = @aktualisieren_Button_Callback;
CopyButton_handle = @CopyButton_Callback;
PasteButton_handle = @PasteButton_Callback;
ModellAuswahl_handle = @ModellAuswahlPopup_Callback;
plot_Auswaehl_handle = @plot_Auswaehl;
Analyze_GUI(batteriename_pop_handle,zustand_pop_handle, temp_pop_handle,soc_pop_handle,hf_correction_handle,lf_correction_handle,FitButton_handle,korrigiert_punkte_handle,drt_button_handle,aktualisieren_button_handle,CopyButton_handle,PasteButton_handle,ModellAuswahl_handle,plot_Auswaehl_handle,handles);


% --- Executes when entered data in editable cell(s) in RelaxTable.
function RelaxTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to RelaxTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in TimeDomainPlotButton.
function TimeDomainPlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to TimeDomainPlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;
FarbenLaden;
figure
plot(DRT_GUI.Messdaten.relax.zeit,DRT_GUI.Messdaten.relax.spannung,'color',RWTHBlau,'displayname','Messung')
title('Relax')
grid on
hold on
if sum(strcmp(fieldnames(DRT_GUI.Fit),'Implementierung')) && ~isempty(DRT_GUI.Fit.Implementierung)
    R_RC_all = [];
    C_RC_all = [];
    R_ser_all = 0;
    C_ser_all = [];
    R_RC_ReFit_all = [];
    C_RC_ReFit_all = [];
    R_ser_ReFit_all = 0;
    C_ser_ReFit_all = [];for i = 1:numel(DRT_GUI.Fit.Implementierung.Info)-1
        args = cell(1,numel(DRT_GUI.Fit.Implementierung.Info{i}.inputs));
        argliste = '';
        for k = 1:numel(DRT_GUI.Fit.Implementierung.Info{i}.inputs)
            ParNr = find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),DRT_GUI.Fit.Implementierung.Table{i,k+4}));
            if isempty(ParNr)
                warning('Konnte Parameter aus Implementierung nicht finden. Implementierungsinfos werden reseted!')
                rmfield(DRT_GUI.Fit,'Implementierung');
                return
            end
            args{k} = DRT_GUI.Fit.Parameter(ParNr);
            argliste = [argliste 'args{' num2str(k) '},' ];
        end
        
        argliste = argliste(1:end-1);
        if strcmp(DRT_GUI.Fit.Implementierung.Table{i,1},'OCV_source')
            DeltaU = DRT_GUI.Messdaten.relax.spannung(end)-DRT_GUI.Messdaten.relax.spannung(1);
            Ladung = [0 cumsum(DRT_GUI.Messdaten.relax.strom(1:end-1) .* diff(DRT_GUI.Messdaten.relax.zeit))];
            C_OCV = Ladung(end) / DeltaU;
            if ismember('Funktionsname',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                [R_RC, C_RC, C_ser, R_ser, ~, ~] = RunLocalESBeFunction(DRT_GUI.Fit.Implementierung.Info{i}.Funktionsname,C_OCV);
            elseif ismember('f',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                [R_RC, C_RC, C_ser, R_ser, ~, ~] = DRT_GUI.Fit.Implementierung.Info{i}.f(C_OCV);
            end
        elseif isempty(argliste)
            if ismember('Funktionsname',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                [R_RC, C_RC, C_ser, R_ser, ~, ~] = RunLocalESBeFunction(DRT_GUI.Fit.Implementierung.Info{i}.Funktionsname);
            elseif ismember('f',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
            elseif ismember('f',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                eval(['[R_RC, C_RC, C_ser, R_ser, ~, ~] = DRT_GUI.Fit.Implementierung.Info{i}.f;'])
            end
        else
            if ismember('Funktionsname',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                [R_RC, C_RC, C_ser, R_ser, ~, ~] = RunLocalESBeFunction(DRT_GUI.Fit.Implementierung.Info{i}.Funktionsname,args{:});
            elseif ismember('f',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                eval(['[R_RC, C_RC, C_ser, R_ser, ~, ~] = DRT_GUI.Fit.Implementierung.Info{i}.f(' argliste ');'])
            end
        end
        if strcmp(DRT_GUI.Fit.Implementierung.Table{i,2},'Re-Fit')
            args_ReFit = cell(1,numel(DRT_GUI.Fit.Implementierung.Info{i}.inputs));
            argliste_ReFit = '';
            for k = 1:numel(DRT_GUI.Fit.Implementierung.Info{i}.inputs)
                ParNr_ReFit = find(strcmp(DRT_GUI.Fit.Implementierung.OCV(:,1),['ReFit_' DRT_GUI.Fit.Implementierung.Table{i,k+4}]));
                args_ReFit{k} = DRT_GUI.Fit.Implementierung.OCV{ParNr_ReFit,2};
                argliste_ReFit = [argliste_ReFit 'args_ReFit{' num2str(k) '},' ];
            end
            argliste_ReFit = argliste_ReFit(1:end-1);
            if ismember('Funktionsname',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                [R_RC_ReFit, C_RC_ReFit, C_ser_ReFit, R_ser_ReFit,~ , ~] = RunLocalESBeFunction(DRT_GUI.Fit.Implementierung.Info{i}.Funktionsname,args_ReFit{:});
            elseif ismember('f',fieldnames(DRT_GUI.Fit.Implementierung.Info{i}))
                eval(['[R_RC_ReFit, C_RC_ReFit, C_ser_ReFit, R_ser_ReFit, ~, ~] = DRT_GUI.Fit.Implementierung.Info{i}.f(' argliste_ReFit ');'])
            end
        else
           R_RC_ReFit = R_RC;
           C_RC_ReFit = C_RC;
           C_ser_ReFit = C_ser;
           R_ser_ReFit = R_ser;
        end
        R_RC_all = [R_RC_all ;R_RC'];
        C_RC_all = [C_RC_all ;C_RC'];
        if ~isempty(R_ser) , R_ser_all = R_ser_all + R_ser; end
        if ~isempty(C_ser)
            if isempty(C_ser_all) || abs(C_ser_all) > 1e16
                C_ser_all = C_ser;
            else
                C_ser_all = (C_ser_all .* C_ser)./(C_ser_all + C_ser);
            end
        end
        
        R_RC_ReFit_all = [R_RC_ReFit_all ;R_RC_ReFit'];
        C_RC_ReFit_all = [C_RC_ReFit_all ;C_RC_ReFit'];
        if ~isempty(R_ser_ReFit) , R_ser_ReFit_all = R_ser_ReFit_all + R_ser_ReFit; end
        if ~isempty(C_ser_ReFit)
            if isempty(C_ser_ReFit_all) || abs(C_ser_ReFit_all) > 1e16
                C_ser_ReFit_all = C_ser_ReFit;
            else
                C_ser_ReFit_all = (C_ser_ReFit_all .* C_ser_ReFit)./(C_ser_ReFit_all + C_ser_ReFit);
            end
        end
    end
    stromindex = [1 1+find(abs(diff(DRT_GUI.Messdaten.relax.strom))>0.01)];
    if stromindex(end) < numel(DRT_GUI.Messdaten.relax.strom),
        stromindex(end+1) = numel(DRT_GUI.Messdaten.relax.strom);
    end
    strom = zeros(1,numel(stromindex));
    timediff = [ diff(DRT_GUI.Messdaten.relax.zeit) 0];
    for i = 1:numel(stromindex)-1
        if numel(stromindex(i):stromindex(i+1)-1) == 1
            strom(i) = DRT_GUI.Messdaten.relax.strom(stromindex(i));
        else
            strom(i) = sum(DRT_GUI.Messdaten.relax.strom(stromindex(i):stromindex(i+1)-1).*timediff(stromindex(i):stromindex(i+1)-1)./sum(timediff(stromindex(i):stromindex(i+1)-1)));
        end
    end
    zeit = DRT_GUI.Messdaten.relax.zeit(stromindex);
    
    ModellSpannung = DRT_GUI.Messdaten.relax.strom * R_ser_all + ...
        DRT_GUI.Messdaten.relax.spannung(1)+...
        [0 cumsum(diff(DRT_GUI.Messdaten.relax.zeit).*DRT_GUI.Messdaten.relax.strom(1:end-1)./C_ser_all)];
    U_RC = zeros(numel(R_RC_all),numel(DRT_GUI.Messdaten.relax.strom));
    for i = 1:numel(stromindex)-1
        if stromindex(i)==1
            U0 = zeros(size(R_RC_all));
        else
            U0 = U_RC(:,stromindex(i));
        end
        Umax = strom(i).*R_RC_all;
        t = DRT_GUI.Messdaten.relax.zeit(stromindex(i)+1:stromindex(i+1))-DRT_GUI.Messdaten.relax.zeit(stromindex(i));
        for k = 1:numel(R_RC_all)
            if abs(U0(k)-Umax(k))<=0.0001
                U_RC(k,stromindex(i)+1:stromindex(i+1)) = Umax(k);
            else
                U_RC(k,stromindex(i)+1:stromindex(i+1)) = U0(k)+(Umax(k)-U0(k)).*(1-exp(-t./(R_RC_all(k).*C_RC_all(k))));
            end
        end
    end
    ModellSpannung = ModellSpannung + sum(U_RC,1);
    
    ModellSpannung_ReFit = DRT_GUI.Messdaten.relax.strom * R_ser_ReFit_all + ...
        DRT_GUI.Messdaten.relax.spannung(1)+...
        [0 cumsum(diff(DRT_GUI.Messdaten.relax.zeit).*DRT_GUI.Messdaten.relax.strom(1:end-1)./C_ser_ReFit_all)];
    U_RC_ReFit = zeros(numel(R_RC_ReFit_all),numel(DRT_GUI.Messdaten.relax.strom));
    for i = 1:numel(stromindex)-1
        if stromindex(i)==1
            U0_ReFit = zeros(size(R_RC_ReFit_all));
        else
            U0_ReFit = U_RC_ReFit(:,stromindex(i));
        end
        Umax_ReFit = strom(i).*R_RC_ReFit_all;
        t = DRT_GUI.Messdaten.relax.zeit(stromindex(i)+1:stromindex(i+1))-DRT_GUI.Messdaten.relax.zeit(stromindex(i));
        for k = 1:numel(R_RC_ReFit_all)
            if abs(U0_ReFit(k)-Umax_ReFit(k))<=0.0001
                U_RC_ReFit(k,stromindex(i)+1:stromindex(i+1)) = Umax_ReFit(k);
            else
                U_RC_ReFit(k,stromindex(i)+1:stromindex(i+1)) = U0_ReFit(k)+(Umax_ReFit(k)-U0_ReFit(k)).*(1-exp(-t./(R_RC_ReFit_all(k).*C_RC_ReFit_all(k))));
            end
        end
    end
    ModellSpannung_ReFit = ModellSpannung_ReFit + sum(U_RC_ReFit,1);
    
    
    plot(DRT_GUI.Messdaten.relax.zeit,ModellSpannung,'Color',RWTHTuerkis,'DisplayName','EISModell');
    plot(DRT_GUI.Messdaten.relax.zeit,ModellSpannung_ReFit,'Color',RWTHRot,'DisplayName','TDMModell');
    l=legend('show');
    set(l,'Location','SouthEast')
    
end

figure
plot(DRT_GUI.Messdaten.eis.zeit,DRT_GUI.Messdaten.eis.spannung)
grid on
title('EIS')
if sum(strcmp(fieldnames(DRT_GUI.Messdaten),'vor_relax')) && ~isempty(DRT_GUI.Messdaten.vor_relax)&& ~isempty(DRT_GUI.Messdaten.vor_relax.zeit)
    figure
    plot(DRT_GUI.Messdaten.vor_relax.zeit,DRT_GUI.Messdaten.vor_relax.spannung)
    grid on;hold on
    title('Messungen vor der Relaxation')
    if sum(strcmp(fieldnames(DRT_GUI.Fit),'Implementierung')) && ~isempty(DRT_GUI.Fit.Implementierung)
        stromindex = [1 1+find(abs(diff(DRT_GUI.Messdaten.vor_relax.strom))>0.0005)];
        if stromindex(end) < numel(DRT_GUI.Messdaten.vor_relax.strom),
            stromindex(end+1) = numel(DRT_GUI.Messdaten.vor_relax.strom);
        end
        strom = zeros(1,numel(stromindex));
        timediff = [ diff(DRT_GUI.Messdaten.vor_relax.zeit) 0];
        for i = 1:numel(stromindex)-1
            if numel(stromindex(i):stromindex(i+1)-1) == 1
                strom(i) = DRT_GUI.Messdaten.vor_relax.strom(stromindex(i));
            else
                strom(i) = sum(DRT_GUI.Messdaten.vor_relax.strom(stromindex(i):stromindex(i+1)-1).*timediff(stromindex(i):stromindex(i+1)-1)./sum(timediff(stromindex(i):stromindex(i+1)-1)));
            end
        end
        zeit = DRT_GUI.Messdaten.vor_relax.zeit(stromindex);
        ModellSpannung = DRT_GUI.Messdaten.vor_relax.strom * R_ser_all + ...
            DRT_GUI.Messdaten.vor_relax.spannung(1)+...
            [0 cumsum(diff(DRT_GUI.Messdaten.vor_relax.zeit).*DRT_GUI.Messdaten.vor_relax.strom(1:end-1)./C_ser_all)];
        U_RC = zeros(numel(R_RC_all),numel(DRT_GUI.Messdaten.vor_relax.strom));
        for i = 1:numel(stromindex)-1
            if stromindex(i)==1
                U0 = zeros(size(R_RC_all));
            else
                U0 = U_RC(:,stromindex(i));
            end
            Umax = strom(i).*R_RC_all;
            t = DRT_GUI.Messdaten.vor_relax.zeit(stromindex(i)+1:stromindex(i+1))-DRT_GUI.Messdaten.vor_relax.zeit(stromindex(i));
            for k = 1:numel(R_RC_all)
                if abs(U0(k)-Umax(k))<=0.0001
                    U_RC(k,stromindex(i)+1:stromindex(i+1)) = Umax(k);
                else
                    U_RC(k,stromindex(i)+1:stromindex(i+1)) = U0(k)+(Umax(k)-U0(k)).*(1-exp(-t./(R_RC_all(k).*C_RC_all(k))));
                end
            end
            
        end
        
        ModellSpannung = ModellSpannung + sum(U_RC,1);
        ModellSpannung = ModellSpannung + DRT_GUI.Messdaten.vor_relax.spannung(end) - ModellSpannung(end);
        plot(DRT_GUI.Messdaten.vor_relax.zeit,ModellSpannung,'r'); 
    end
    
end

if sum(strcmp(fieldnames(DRT_GUI.Messdaten),'nach_eis')) && ~isempty(DRT_GUI.Messdaten.nach_eis) && ~isempty(DRT_GUI.Messdaten.nach_eis.zeit)
    p_index = 0;
    p_i=0;
    ind2 = p_index(end);
        ind1 = find(~DRT_GUI.Messdaten.nach_eis.strom(ind2+1:end)==0,1,'first')-1;
        ind2 = numel(DRT_GUI.Messdaten.nach_eis.strom);
        
            start = find(DRT_GUI.Messdaten.nach_eis.zeit>DRT_GUI.Messdaten.nach_eis.zeit(ind1)-30,1,'first');
            if isempty(start), start = 1;end
            p_index =  start:ind2;
            p_i=p_i+1;
      
    

    figure
    plot(DRT_GUI.Messdaten.nach_eis.zeit(p_index)-DRT_GUI.Messdaten.nach_eis.zeit(p_index(1)),DRT_GUI.Messdaten.nach_eis.spannung(p_index),'color',RWTHBlau,'LineWidth',1,'DisplayName','Messung')
    grid on;hold on
    title(['Messungen nach der EIS-Messung'])
    if sum(strcmp(fieldnames(DRT_GUI.Fit),'Implementierung')) && ~isempty(DRT_GUI.Fit.Implementierung)
        stromindex = [1 1+find(abs(diff(DRT_GUI.Messdaten.nach_eis.strom(p_index)))>0.0005)];
        if stromindex(end) < numel(DRT_GUI.Messdaten.nach_eis.strom(p_index)),
            stromindex(end+1) = numel(DRT_GUI.Messdaten.nach_eis.strom(p_index));
        end
        strom = zeros(1,numel(stromindex));
        timediff = [ diff(DRT_GUI.Messdaten.nach_eis.zeit(p_index)) 0];
        for i = 1:numel(stromindex)-1
            if numel(stromindex(i):stromindex(i+1)-1) == 1
                strom(i) = DRT_GUI.Messdaten.nach_eis.strom(p_index(stromindex(i)));
            else
                strom(i) = sum(DRT_GUI.Messdaten.nach_eis.strom(p_index(stromindex(i):stromindex(i+1)-1)).*timediff(stromindex(i):stromindex(i+1)-1)./sum(timediff(stromindex(i):stromindex(i+1)-1)));
            end
        end
        zeit = DRT_GUI.Messdaten.nach_eis.zeit(p_index(stromindex));
        ModellSpannung = DRT_GUI.Messdaten.nach_eis.strom(p_index) * R_ser_all + ...
            DRT_GUI.Messdaten.nach_eis.spannung(p_index(1))+...
            [0 cumsum(diff(DRT_GUI.Messdaten.nach_eis.zeit(p_index)).*DRT_GUI.Messdaten.nach_eis.strom(p_index(1:end-1))./C_ser_all)];
        U_RC = zeros(numel(R_RC_all),numel(DRT_GUI.Messdaten.nach_eis.strom(p_index)));
        for i = 1:numel(stromindex)-1
            if stromindex(i)==1
                U0 = zeros(size(R_RC_all));
            else
                U0 = U_RC(:,stromindex(i));
            end
            Umax = strom(i).*R_RC_all;
            t = DRT_GUI.Messdaten.nach_eis.zeit(p_index(stromindex(i)+1:stromindex(i+1)))-DRT_GUI.Messdaten.nach_eis.zeit(p_index(stromindex(i)));
            for k = 1:numel(R_RC_all)
                if abs(U0(k)-Umax(k))<=0.0001
                    U_RC(k,stromindex(i)+1:stromindex(i+1)) = Umax(k);
                else
                    U_RC(k,stromindex(i)+1:stromindex(i+1)) = U0(k)+(Umax(k)-U0(k)).*(1-exp(-t./(R_RC_all(k).*C_RC_all(k))));
                end
            end

        end
        ModellSpannung = ModellSpannung + sum(U_RC,1);
        ModellSpannung = ModellSpannung + DRT_GUI.Messdaten.nach_eis.spannung(p_index(1)) - ModellSpannung(1);
        plot(DRT_GUI.Messdaten.nach_eis.zeit(p_index)-DRT_GUI.Messdaten.nach_eis.zeit(p_index(1)),ModellSpannung,'color',RWTHTuerkis,'LineWidth',1,'DisplayName','EISFit'); 


        ModellSpannung_ReFit = DRT_GUI.Messdaten.nach_eis.strom(p_index) * R_ser_ReFit_all + ...
            DRT_GUI.Messdaten.nach_eis.spannung(p_index(1))+...
            [0 cumsum(diff(DRT_GUI.Messdaten.nach_eis.zeit(p_index)).*DRT_GUI.Messdaten.nach_eis.strom(p_index(1:end-1))./C_ser_ReFit_all)];
        U_RC_ReFit = zeros(numel(R_RC_ReFit_all),numel(DRT_GUI.Messdaten.nach_eis.strom(p_index)));
        for i = 1:numel(stromindex)-1
            if stromindex(i)==1
                U0_ReFit = zeros(size(R_RC_ReFit_all));
            else
                U0_ReFit = U_RC_ReFit(:,stromindex(i));
            end
            Umax_ReFit = strom(i).*R_RC_ReFit_all;
            t = DRT_GUI.Messdaten.nach_eis.zeit(p_index(stromindex(i)+1:stromindex(i+1)))-DRT_GUI.Messdaten.nach_eis.zeit(p_index(stromindex(i)));
            for k = 1:numel(R_RC_ReFit_all)
                if abs(U0_ReFit(k)-Umax_ReFit(k))<=0.0001
                    U_RC_ReFit(k,stromindex(i)+1:stromindex(i+1)) = Umax_ReFit(k);
                else
                    U_RC_ReFit(k,stromindex(i)+1:stromindex(i+1)) = U0_ReFit(k)+(Umax_ReFit(k)-U0_ReFit(k)).*(1-exp(-t./(R_RC_ReFit_all(k).*C_RC_ReFit_all(k))));
                end
            end

        end
        ModellSpannung_ReFit = ModellSpannung_ReFit + sum(U_RC_ReFit,1);
        ModellSpannung_ReFit = ModellSpannung_ReFit + DRT_GUI.Messdaten.nach_eis.spannung(p_index(1)) - ModellSpannung_ReFit(1);
        plot(DRT_GUI.Messdaten.nach_eis.zeit(p_index)-DRT_GUI.Messdaten.nach_eis.zeit(p_index(1)),ModellSpannung_ReFit,'color',RWTHRot,'LineWidth',1,'DisplayName','TDMFit'); 
        legend('show')
    end

        
    
end

if sum(strcmp(fieldnames(DRT_GUI.Messdaten),'nach_eis')) && ~isempty(DRT_GUI.Messdaten.nach_eis) && ~isempty(DRT_GUI.Messdaten.nach_eis.zeit)
    p_index = 0;
    p_i=0;
    while true
        ind2 = p_index(end);
        while true
            ind1 = ind2+find(DRT_GUI.Messdaten.nach_eis.strom(ind2+1:end)==0,1,'first');
            ind2 = ind1+find(~DRT_GUI.Messdaten.nach_eis.strom(ind1:end)==0,1,'first')-2;
            if isempty(ind2),break;end
            if ind1>1 && (DRT_GUI.Messdaten.nach_eis.zeit(ind2)-DRT_GUI.Messdaten.nach_eis.zeit(ind1))>655
                if p_index(end)==0
                    p_index = [1 find(~DRT_GUI.Messdaten.nach_eis.strom(1:ind2)==0,1,'first')-1];
                end
                start = p_index(1)+find(DRT_GUI.Messdaten.nach_eis.zeit(p_index(1)+1:ind2)>DRT_GUI.Messdaten.nach_eis.zeit(p_index(end)+1)-30,1,'first');
                if isempty(start), start = p_index(end)+1;end
                p_index =  start:ind2;
                p_i=p_i+1;
                break
            end
        end
        if isempty(ind2),break;end

        figure
        plot(DRT_GUI.Messdaten.nach_eis.zeit(p_index)-DRT_GUI.Messdaten.nach_eis.zeit(p_index(1)),DRT_GUI.Messdaten.nach_eis.spannung(p_index),'color',RWTHBlau,'LineWidth',1,'DisplayName','Messung')
        grid on;hold on
        title(['Messungen nach der EIS-Messung Teil' num2str(p_i)])
        if sum(strcmp(fieldnames(DRT_GUI.Fit),'Implementierung')) && ~isempty(DRT_GUI.Fit.Implementierung)
            stromindex = [1 1+find(abs(diff(DRT_GUI.Messdaten.nach_eis.strom(p_index)))>0.0005)];
            if stromindex(end) < numel(DRT_GUI.Messdaten.nach_eis.strom(p_index)),
                stromindex(end+1) = numel(DRT_GUI.Messdaten.nach_eis.strom(p_index));
            end
            strom = zeros(1,numel(stromindex));
            timediff = [ diff(DRT_GUI.Messdaten.nach_eis.zeit(p_index)) 0];
            for i = 1:numel(stromindex)-1
                if numel(stromindex(i):stromindex(i+1)-1) == 1
                    strom(i) = DRT_GUI.Messdaten.nach_eis.strom(p_index(stromindex(i)));
                else
                    strom(i) = sum(DRT_GUI.Messdaten.nach_eis.strom(p_index(stromindex(i):stromindex(i+1)-1)).*timediff(stromindex(i):stromindex(i+1)-1)./sum(timediff(stromindex(i):stromindex(i+1)-1)));
                end
            end
            zeit = DRT_GUI.Messdaten.nach_eis.zeit(p_index(stromindex));
            ModellSpannung = DRT_GUI.Messdaten.nach_eis.strom(p_index) * R_ser_all + ...
                DRT_GUI.Messdaten.nach_eis.spannung(p_index(1))+...
                [0 cumsum(diff(DRT_GUI.Messdaten.nach_eis.zeit(p_index)).*DRT_GUI.Messdaten.nach_eis.strom(p_index(1:end-1))./C_ser_all)];
            U_RC = zeros(numel(R_RC_all),numel(DRT_GUI.Messdaten.nach_eis.strom(p_index)));
            for i = 1:numel(stromindex)-1
                if stromindex(i)==1
                    U0 = zeros(size(R_RC_all));
                else
                    U0 = U_RC(:,stromindex(i));
                end
                Umax = strom(i).*R_RC_all;
                t = DRT_GUI.Messdaten.nach_eis.zeit(p_index(stromindex(i)+1:stromindex(i+1)))-DRT_GUI.Messdaten.nach_eis.zeit(p_index(stromindex(i)));
                for k = 1:numel(R_RC_all)
                    if abs(U0(k)-Umax(k))<=0.0001
                        U_RC(k,stromindex(i)+1:stromindex(i+1)) = Umax(k);
                    else
                        U_RC(k,stromindex(i)+1:stromindex(i+1)) = U0(k)+(Umax(k)-U0(k)).*(1-exp(-t./(R_RC_all(k).*C_RC_all(k))));
                    end
                end

            end
            ModellSpannung = ModellSpannung + sum(U_RC,1);
            ModellSpannung = ModellSpannung + DRT_GUI.Messdaten.nach_eis.spannung(p_index(1)) - ModellSpannung(1);
            plot(DRT_GUI.Messdaten.nach_eis.zeit(p_index)-DRT_GUI.Messdaten.nach_eis.zeit(p_index(1)),ModellSpannung,'color',RWTHTuerkis,'LineWidth',1,'DisplayName','EISFit'); 
  
            
            ModellSpannung_ReFit = DRT_GUI.Messdaten.nach_eis.strom(p_index) * R_ser_ReFit_all + ...
                DRT_GUI.Messdaten.nach_eis.spannung(p_index(1))+...
                [0 cumsum(diff(DRT_GUI.Messdaten.nach_eis.zeit(p_index)).*DRT_GUI.Messdaten.nach_eis.strom(p_index(1:end-1))./C_ser_ReFit_all)];
            U_RC_ReFit = zeros(numel(R_RC_ReFit_all),numel(DRT_GUI.Messdaten.nach_eis.strom(p_index)));
            for i = 1:numel(stromindex)-1
                if stromindex(i)==1
                    U0_ReFit = zeros(size(R_RC_ReFit_all));
                else
                    U0_ReFit = U_RC_ReFit(:,stromindex(i));
                end
                Umax_ReFit = strom(i).*R_RC_ReFit_all;
                t = DRT_GUI.Messdaten.nach_eis.zeit(p_index(stromindex(i)+1:stromindex(i+1)))-DRT_GUI.Messdaten.nach_eis.zeit(p_index(stromindex(i)));
                for k = 1:numel(R_RC_ReFit_all)
                    if abs(U0_ReFit(k)-Umax_ReFit(k))<=0.0001
                        U_RC_ReFit(k,stromindex(i)+1:stromindex(i+1)) = Umax_ReFit(k);
                    else
                        U_RC_ReFit(k,stromindex(i)+1:stromindex(i+1)) = U0_ReFit(k)+(Umax_ReFit(k)-U0_ReFit(k)).*(1-exp(-t./(R_RC_ReFit_all(k).*C_RC_ReFit_all(k))));
                    end
                end

            end
            ModellSpannung_ReFit = ModellSpannung_ReFit + sum(U_RC_ReFit,1);
            ModellSpannung_ReFit = ModellSpannung_ReFit + DRT_GUI.Messdaten.nach_eis.spannung(p_index(1)) - ModellSpannung_ReFit(1);
            plot(DRT_GUI.Messdaten.nach_eis.zeit(p_index)-DRT_GUI.Messdaten.nach_eis.zeit(p_index(1)),ModellSpannung_ReFit,'color',RWTHRot,'LineWidth',1,'DisplayName','TDMFit'); 
            legend('show')
        end
    end
end



% --- Executes on button press in DRT_Tau_use_button.
function DRT_Tau_use_button_Callback(hObject, eventdata, handles)
% hObject    handle to DRT_Tau_use_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;


if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten')))
    return
end
TableCell = get(handles.ParamTable,'Data');
TableCell = cell2struct(TableCell',{'Name','Fix','Value','Min','Max','Lim'});

TauCell = get(handles.TauTable,'Data');
TauCell = cell2struct(TauCell',{'tau','used','parname'});

%Schreibt die Tau1, Tau2 Werte aus der Tautabelle in die Daten_Fix_Tabelle
for i = 1:numel(TauCell)
    parnummer = find(strcmp(TauCell(i).parname,DRT_GUI.Fit.aktuell_Modell.P_Name(1,:)));
    if ~isempty(parnummer)
        TableCell(parnummer).Value = TauCell(i).tau;
        TableCell(parnummer).Min = TauCell(i).tau / 1.2;
        TableCell(parnummer).Max = TauCell(i).tau * 1.2;
    end
end

TableCell = struct2cell(TableCell)';
set(handles.ParamTable,'Data',TableCell)


PlotFittedParametersButton_Callback(handles.PlotFittedParametersButton, eventdata, handles)


% --- Executes on button press in fig1_bode_button.
function fig1_bode_button_Callback(hObject, eventdata, handles)
% hObject    handle to fig1_bode_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten')))
    return
end
figure
subplot(2,1,1)
semilogx(DRT_GUI.Messdaten.frequenz,abs(DRT_GUI.Messdaten.Z),'o')
grid on, hold on
if ~isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) && ~isempty(DRT_GUI.Messdaten.relax_fft)
    semilogx(DRT_GUI.Messdaten.relax_fft.frequenz,abs(DRT_GUI.Messdaten.relax_fft.Z+DRT_GUI.Messdaten.relax_fft.Zreal_korrektur),'ko')
end
ylabel('|Z| [\Omega]')
xlabel('f [Hz]')
subplot(2,1,2)
semilogx(DRT_GUI.Messdaten.frequenz,angle(DRT_GUI.Messdaten.Z),'o')

grid on, hold on
if ~isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) && ~isempty(DRT_GUI.Messdaten.relax_fft)
    semilogx(DRT_GUI.Messdaten.relax_fft.frequenz,angle(DRT_GUI.Messdaten.relax_fft.Z+DRT_GUI.Messdaten.relax_fft.Zreal_korrektur),'ko')
end
ylabel('angle(Z) [°]')
xlabel('f [Hz]')

if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Fit'))) ||  ...
        isempty(DRT_GUI.Fit) || isempty(cell2mat(strfind(fieldnames(DRT_GUI.Fit),'Zreal'))) || isempty(DRT_GUI.Fit.Zreal)
    return
end

subplot(2,1,1)
semilogx(DRT_GUI.Fit.frequenz,abs(DRT_GUI.Fit.Z),'rx')
grid on, hold on


subplot(2,1,2)
semilogx(DRT_GUI.Fit.frequenz,angle(DRT_GUI.Fit.Z),'rx')


subplot(2,1,1)

if ~isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) && ~isempty(DRT_GUI.Messdaten.relax_fft)
    legend('EIS','Relax\_FFT','Fitpunkte')
else
    legend('Messung','Fit')
end

subplot(2,1,2)
if ~isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) && ~isempty(DRT_GUI.Messdaten.relax_fft)
    legend('EIS','Relax\_FFT','Fitpunkte','Location','SouthEast')
else
    legend('Messung','Fit','Location','SouthEast')
end

% --- Executes on button press in fig1_Z_button.
function fig1_Z_button_Callback(hObject, eventdata, handles)
% hObject    handle to fig1_Z_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DRT_GUI
FarbenLaden
if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten')))
    return
end
if isempty(dir('export'))
    mkdir('export')
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie])
end

figure('Name','Vgl. EIS-Relax','NumberTitle','off','UnitS','centimeters','Position',[0, 0, 25, 10])
subplot(2,5,[1:2 6:7])
plot(DRT_GUI.Messdaten.Z,'o','color',RWTHBlau,'DisplayName','Messung','LineWidth',1,'MarkerSize',7);hold on;
if ~isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) && ~isempty(DRT_GUI.Messdaten.relax_fft)
    plot(DRT_GUI.Messdaten.relax_fft.Z+DRT_GUI.Messdaten.relax_fft.Zreal_korrektur...
        ,'o','color',RWTHSchwarz,'DisplayName','RelaxFFT','LineWidth',1,'MarkerSize',7)
end
grid on; axis square; axis equal; set(gca,'ydir', 'reverse');
xlabel('$\Re\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
ylabel('$\Im\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
h1 = legend('show','Location','NorthWest');
set(h1,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex')
axis equal
subplot(2,5,3:5)
semilogx(DRT_GUI.Messdaten.frequenz,real(DRT_GUI.Messdaten.Z),'o','color',RWTHBlau,'DisplayName','Messung','LineWidth',1,'MarkerSize',7);hold on;
if ~isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) && ~isempty(DRT_GUI.Messdaten.relax_fft)
    semilogx(DRT_GUI.Messdaten.relax_fft.frequenz,real(DRT_GUI.Messdaten.relax_fft.Z)+DRT_GUI.Messdaten.relax_fft.Zreal_korrektur...
        ,'o','color',RWTHSchwarz,'DisplayName','RelaxFFT','LineWidth',1,'MarkerSize',7)
end
set(gca,'xdir','reverse'),grid on, hold on
set(gca,'TickLabelInterpreter','latex')
h1 = legend('show','Location','NorthWest');
set(h1,'Interpreter','latex');
ylabel('$\Re\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
xlabel('$f$ in Hz','Interpreter','latex');
subplot(2,5,8:10)
semilogx(DRT_GUI.Messdaten.frequenz,imag(DRT_GUI.Messdaten.Z),'o','color',RWTHBlau,'DisplayName','Messung','LineWidth',1,'MarkerSize',7);hold on;
if ~isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) && ~isempty(DRT_GUI.Messdaten.relax_fft)
    semilogx(DRT_GUI.Messdaten.relax_fft.frequenz,imag(DRT_GUI.Messdaten.relax_fft.Z)...
        ,'o','color',RWTHSchwarz,'DisplayName','RelaxFFT','LineWidth',1,'MarkerSize',7)
end
set(gca,'xdir','reverse'),grid on, hold on
set(gca,'ydir','reverse')
set(gca,'TickLabelInterpreter','latex')
ylabel('$\Im\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
xlabel('$f$ in Hz','Interpreter','latex');
savefig(['export/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie '_Messung_' ...
    DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_'...
    strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m') 'SOC'...
    '.fig'])


if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Fit'))) ||  ...
        isempty(DRT_GUI.Fit) || isempty(cell2mat(strfind(fieldnames(DRT_GUI.Fit),'Zreal'))) || isempty(DRT_GUI.Fit.Zreal)
    return
end

subplot(2,5,[1:2 6:7])
plot(DRT_GUI.Fit.Z,'x','color',RWTHRot,'DisplayName','Fit','LineWidth',1,'MarkerSize',7);
legend('off');
h1 = legend('show','Location','NorthWest');
set(h1,'Interpreter','latex');
subplot(2,5,3:5)
semilogx(DRT_GUI.Fit.frequenz,real(DRT_GUI.Fit.Z),'x','color',RWTHRot,'DisplayName','Fit','LineWidth',1,'MarkerSize',7);
legend('off')
h1 = legend('show','Location','NorthWest');
set(h1,'Interpreter','latex');
subplot(2,5,8:10)
semilogx(DRT_GUI.Fit.frequenz,imag(DRT_GUI.Fit.Z),'x','color',RWTHRot,'DisplayName','Fit','LineWidth',1,'MarkerSize',7);

savefig(['export/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie '_Fit_' ...
    DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_'...
    strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m') 'SOC'...
    '.fig'])



% --- Executes on button press in FitPlusSaveCheckbox.
function FitPlusSaveCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to FitPlusSaveCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FitPlusSaveCheckbox


% --- Executes on button press in KopieErstellen_Button.
function KopieErstellen_Button_Callback(hObject, eventdata, handles)
% hObject    handle to KopieErstellen_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
DRT_GUI_prev = DRT_GUI;
BatterieName = inputdlg('neuer BatterieName','Name',[1],{DRT_GUI.Testparameter.Batterie});
choice = BatterieName;
if  isempty(choice) ||strcmp(choice,'') || strcmp(choice{1},DRT_GUI.Testparameter.Batterie) , return,end
copyfile(['output/' DRT_GUI.Testparameter.Batterie],['output/' BatterieName{1}])

Change_BatterieName_inFolder(['output/' BatterieName{1}],DRT_GUI.Testparameter.Batterie,BatterieName{1})
DRT_GUI = DRT_GUI_prev ;
aktualisieren_Button_Callback(handles.aktualisieren_Button,eventdata,handles)
msgbox('Kopie wurde erstellt')

function Change_BatterieName_inFolder(Folder,AlterName,NeuerName)
global DRT_GUI
if Folder(end) == '/' || Folder(end) == '\'
    Folder = Folder(1:end-1);
end

FileList = dir([Folder '/*' AlterName '*.mat']);
for i = 1:numel(FileList)
    movefile([Folder '/' FileList(i).name],  [Folder '/' strrep(FileList(i).name,AlterName,NeuerName)])
    if ~strcmp(FileList(i).name(end-10:end),'_Modell.mat')
        display(['Modifiziere ' FileList(i).name]);
        load([Folder '/' strrep(FileList(i).name,AlterName,NeuerName)])
        DRT_GUI.Testparameter.Batterie = NeuerName;
        save([Folder '/' strrep(FileList(i).name,AlterName,NeuerName)],'DRT_GUI')
        clear DRT_GUI Fit
    end
end
FolderList = dir([Folder '/*']);
for i = 1:numel(FolderList)
    if FolderList(i).isdir && ~strcmp(FolderList(i).name,'.') && ~strcmp(FolderList(i).name,'..')
        Change_BatterieName_inFolder([Folder '/' FolderList(i).name],AlterName,NeuerName)
    end
end



% --------------------------------------------------------------------
function MenScript_Callback(hObject, eventdata, handles)
% hObject    handle to MenScript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice = questdlg('Dieses Script tauscht bei allen SOCs und allen Temperaturen die beiden Diffusionsäste. Fortfahren?', ...
    'Script', ...
    'Abbrechen','Alle ändern','Abbrechen');
% Handle response
if isempty(choice), return,end
switch choice
    case 'Abbrechen'
        return
end
TList = get(handles.TemperaturPopup,'String');
for k = 2:numel(TList)
    set(handles.TemperaturPopup,'Value',k)
    TemperaturPopup_Callback(handles.TemperaturPopup,eventdata,handles)
    SOCList = get(handles.SOCPopup,'String');
    for i = 2:numel(SOCList)
        set(handles.SOCPopup,'Value',i)
        SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
        ParTableAlt = get(handles.ParamTable,'Data');
        ParTableNeu = ParTableAlt;
        ParTableNeu(15,2:end) = ParTableAlt(17,2:end);
        ParTableNeu(16,2:end) = ParTableAlt(18,2:end);
        ParTableNeu(17,2:end) = ParTableAlt(15,2:end);
        ParTableNeu(18,2:end) = ParTableAlt(16,2:end);
        set(handles.ParamTable,'Data',ParTableNeu)
        FitButton_Callback(handles.FitButton,eventdata,handles)
        FitButton_Callback(handles.FitButton,eventdata,handles)
        SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)
        %         a = inputdlg('Test');
        %         if isempty(a), return, end
    end
end
% --------------------------------------------------------------------
function MenExtras_Callback(hObject, eventdata, handles)
% hObject    handle to MenExtras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OCV_Fitting_Button.
function OCV_Fitting_Button_Callback(hObject, eventdata, handles)
% hObject    handle to OCV_Fitting_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if strcmp(a,'Speichern');
%     SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)
% end

% --------------------------------------------------------------------
function MenDatei_Callback(hObject, eventdata, handles)
% hObject    handle to MenDatei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MenExportieren_Callback(hObject, eventdata, handles)
% hObject    handle to MenExportieren (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
Data = DRT_GUI;
Data2 = load(['output' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad/' ...
    DRT_GUI.Testparameter.Batterie '_' DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_' [strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m')] 'SOC_Modell.mat']);
Data.Messdaten = rmfield(Data.Messdaten,{'aktiv','low_Punkte_Weg'});
Data.Fit = rmfield(Data.Fit,{'Parameter_min','Parameter_max','gueltig','Grenzenautomatik','GrenzenBandbreite','ParFix','Limit_Reached','korrigiert'});
Data.Fit.aktuell_Modell = rmfield(Data.Fit.aktuell_Modell,{'ModellCell','Rechnen_Modell_komp','Rechnen_Modell_HF'});
Data.ReFit = Data2.Fit;
Data.ReFit = rmfield(Data.ReFit,{'Parameter_min','Parameter_max','gueltig'});

if ismember('Implementierung',fieldnames(Data.ReFit))
    Data.ReFit = rmfield(Data.ReFit,{'Implementierung'});
end

Data = rmfield(Data,{'Korrigiert','DRT'});
if isempty(dir('export'))
    mkdir('export')
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie])
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand])
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad']))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad'])
end
save(['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad/' ...
    DRT_GUI.Testparameter.Batterie '_' DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_' [strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m')] 'SOC.mat'],'Data');


% --------------------------------------------------------------------
function MenMasterFileEinlesen_Callback(hObject, eventdata, handles)
% hObject    handle to MenMasterFileEinlesen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;
alter_pfad = pwd;
[filename, pathname] = uigetfile({'*.mat' 'Digatron-File'}, 'MasterFile auswählen.', 'MultiSelect','off');
cd(alter_pfad);
if isempty(filename) || (~iscell(filename) && sum(filename == 0) )
    return
end
master = load([pathname filename]);
if ~sum(strcmp(fieldnames(master),'diga')) || isempty(master.diga) || ~sum(strcmp(fieldnames(master.diga),'daten')) || isempty(master.diga.daten)
    warning('%s ist kein Digatron-File',filename);
    return
end
if sum(strcmp(fieldnames(master.diga.daten),'Strom'))
    Strom = master.diga.daten.Strom;
elseif sum(strcmp(fieldnames(master.diga.daten),'Current'))
    Strom = master.diga.daten.Current;
else
    warning('Es wurden keine Werte für Strom gefunden!');
    return;
end
if max(Strom) > 1000, Strom = Strom/1000;end
if sum(strcmp(fieldnames(master.diga.daten),'Programmdauer'))
    Zeit = master.diga.daten.Programmdauer;
else
    warning('Es wurden keine Werte für Programmdauer gefunden!');
    return;
end
if sum(strcmp(fieldnames(master.diga.daten),'Schritt'))
    Schritt = master.diga.daten.Schritt;
else
    warning('Es wurden keine Werte für Schritt gefunden!');
    return;
end
if sum(strcmp(fieldnames(master.diga.daten),'Zyklus'))
    Zyklus = master.diga.daten.Zyklus;
else
    warning('Es wurden keine Werte für Zyklus gefunden!');
    return;
end
if sum(strcmp(fieldnames(master.diga.daten),'Zustand'))
    Zustand = master.diga.daten.Zustand;
    Zustand=regexprep(Zustand,'ELA','DCH');
    Zustand=regexprep(Zustand,'LAD','CHA');
    
else
    warning('Es wurden keine Werte für Zustand gefunden!');
    return;
end
if sum(strcmp(fieldnames(master.diga.daten),'Span'))
    Spannung = master.diga.daten.Span;
elseif sum(strcmp(fieldnames(master.diga.daten),'Spannung'))
    Spannung = master.diga.daten.Spannung;
else
    warning('Es wurden keine Werte für Spannung gefunden!');
    return;
end
if max(Spannung) > 1000, Spannung = Spannung/1000;end
AhAkku = [0 cumsum(Strom(1:end-1).*diff(Zeit))]/3600;
if ~sum(strcmp(fieldnames(master.diga.daten),'EISstart')) || isempty(find(diff(master.diga.daten.EISstart)==1, 1))
    warning('%s enthält keine EIS-Messungen, die über EISstart getriggert werden.',filename)
    return
end
EIS_indexes = find(diff(master.diga.daten.EISstart)==1);
[k,l] = regexp(DRT_GUI.Testparameter.fileName,'EIS\d\d\d\d\d');
if ~isempty(k) && ~isempty(l)
    eisnumber = str2double(DRT_GUI.Testparameter.fileName(k+3:l));
else
    Prompt = ['Bitte wählen Sie eine Eismessung aus!'];
    for i = 1:numel(EIS_indexes);
        Prompt = [Prompt sprintf('\n%3d - nach %5.2f Ah Entladung und IDC = %5.2f',i,...
            max(AhAkku)-AhAkku(EIS_indexes(i)),mean(Strom(Schritt==Schritt(EIS_indexes(i)+1) & Zyklus==Zyklus(EIS_indexes(i)+1))))];
    end
    choice = cell2mat(inputdlg(Prompt,'Sprektrum auswählen'));
    if isempty(choice) || str2num(choice) ==0 || str2num(choice) > numel(EIS_indexes), return,end
    eisnumber = str2num(choice);
end
EIS_index = EIS_indexes(eisnumber);
nach_EIS_index = EIS_index-2+find(strcmp(Zustand(EIS_index:end),'CHA')|strcmp(Zustand(EIS_index:end),'DCH'),1,'first');
if isempty(nach_EIS_index), nach_EIS_index = numel(master.diga.daten.EISstart); end;
Vor_EIS_index = find(strcmp(Zustand(1:EIS_index),'CHA')|strcmp(Zustand(1:EIS_index),'DCH'),1,'last');
Start_Vor_EIS_index = find(strcmp(Zustand(1:Vor_EIS_index),'PAU')|strcmp(Zustand(1:Vor_EIS_index),'PAU'),1,'last')-5;
if (Zeit(EIS_index)-Zeit(Vor_EIS_index)) > 1e5
    Zeit = Zeit/1000;
end

relax_time = Zeit(Start_Vor_EIS_index:EIS_index)-Zeit(Start_Vor_EIS_index);
relax_spannung = Spannung(Start_Vor_EIS_index:EIS_index);
relax_strom = Strom(Start_Vor_EIS_index:EIS_index);

DRT_GUI.Messdaten.relax.zeit = relax_time;
DRT_GUI.Messdaten.relax.spannung = relax_spannung;
DRT_GUI.Messdaten.relax.strom = relax_strom;
eis_time = Zeit(EIS_index:nach_EIS_index)-Zeit(EIS_index);
eis_spannung = Spannung(EIS_index:nach_EIS_index);
eis_strom = Strom(EIS_index:nach_EIS_index);
DRT_GUI.Messdaten.eis.zeit = eis_time;
DRT_GUI.Messdaten.eis.spannung = eis_spannung;
DRT_GUI.Messdaten.eis.strom = eis_strom;
aktualisieren_Button_Callback(handles.aktualisieren_Button,eventdata,handles)


% --- Executes when entered data in editable cell(s) in ParamTable.
function ParamTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to ParamTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI

ColNames = get(hObject,'ColumnName');
if strcmp(ColNames(eventdata.Indices(2)),'Min')
    DRT_GUI.Fit.aktuell_Modell.ModellCell{1,5}{1,eventdata.Indices(1)} = eventdata.NewData;
elseif strcmp(ColNames(eventdata.Indices(2)),'Max')
    DRT_GUI.Fit.aktuell_Modell.ModellCell{1,6}{1,eventdata.Indices(1)} = eventdata.NewData;
end


% --------------------------------------------------------------------
function MenAlleErneutSpeichern_Callback(hObject, eventdata, handles)
% hObject    handle to MenAlleErneutSpeichern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('Dieses Script speichert den Fit bei allen SOCs und allen Temperaturen erneut. Fortfahren?', ...
    'Script', ...
    'Abbrechen','Alle Speichern','Abbrechen');
% Handle response
if isempty(choice), return,end
switch choice
    case 'Abbrechen'
        return
end
TList = get(handles.TemperaturPopup,'String');
for k = 2:numel(TList)
    set(handles.TemperaturPopup,'Value',k)
    TemperaturPopup_Callback(handles.TemperaturPopup,eventdata,handles)
    SOCList = get(handles.SOCPopup,'String');
    for i = 2:numel(SOCList)
        set(handles.SOCPopup,'Value',i)
        SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
        SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)
    end
end


% --------------------------------------------------------------------
function MenAlleExportieren_Callback(hObject, eventdata, handles)
% hObject    handle to MenAlleExportieren (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('Dieses Script exportiert den Fit bei allen SOCs und allen Temperaturen. Fortfahren?', ...
    'Script', ...
    'Abbrechen','Alle Exportieren','Abbrechen');
% Handle response
if isempty(choice), return,end
switch choice
    case 'Abbrechen'
        return
end
TList = get(handles.TemperaturPopup,'String');
for k = 2:numel(TList)
    set(handles.TemperaturPopup,'Value',k)
    TemperaturPopup_Callback(handles.TemperaturPopup,eventdata,handles)
    SOCList = get(handles.SOCPopup,'String');
    for i = 2:numel(SOCList)
        set(handles.SOCPopup,'Value',i)
        SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
        MenExportieren_Callback(handles.MenExportieren,eventdata,handles)
    end
end


% --- Executes on selection change in DCStromPopUp.
function DCStromPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to DCStromPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DCStromPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DCStromPopUp


% --- Executes during object creation, after setting all properties.
function DCStromPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DCStromPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DCCurrentTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to DCCurrentTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DCCurrentTextBox as text
%        str2double(get(hObject,'String')) returns contents of DCCurrentTextBox as a double


% --- Executes during object creation, after setting all properties.
function DCCurrentTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DCCurrentTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [outstring] = killHTMLtags(inputstring)
if iscell(inputstring)
    for i = 1:numel(inputstring)
        position1 = find(inputstring{i} == '<',1);
        position2 = find(inputstring{i} == '>',1);
        while ~(isempty(position1) || isempty(position2) || position1>position2)
            inputstring{i} = [ inputstring{i}(1:position1-1) inputstring{i}(position2+1:end)];
            position1 = find(inputstring{i} == '<',1);
            position2 = find(inputstring{i} == '>',1);
        end
    end
else
    position1 = find(inputstring == '<',1);
    position2 = find(inputstring == '>',1);
    while ~(isempty(position1) || isempty(position2) || position1>position2)
        inputstring = [ inputstring(1:position1-1) inputstring(position2+1:end)];
        position1 = find(inputstring == '<',1);
        position2 = find(inputstring == '>',1);
    end
end
outstring = inputstring;









% --- Executes on slider movement.
function ProzesseSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ProzesseSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global DRT_Config
DRT_Config.Prozesse = get(hObject,'Value');
set(handles.ProzesseEdit,'string',num2str(DRT_Config.Prozesse))
DRTButton_Callback(handles.DRTButton, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ProzesseSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProzesseSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

global DRT_Config
if isempty(DRT_Config)
    config
end
set(hObject,'value',DRT_Config.Prozesse)



function ProzesseEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ProzesseEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ProzesseEdit as text
%        str2double(get(hObject,'String')) returns contents of ProzesseEdit as a double
global DRT_Config
try
    Wert = round(str2num(get(hObject,'string')));
catch error_msg
    set(hObject,'string',num2str(DRT_Config.Prozesse))
    errordlg(error_msg)
end

if isempty(Wert)|| (Wert<get(handles.ProzesseSlider,'Min') || Wert>get(handles.ProzesseSlider,'Max'))
    set(hObject,'string',num2str(DRT_Config.Prozesse))
    errordlg('Ungültiger Wert')
else
    DRT_Config.Prozesse = Wert;
    set(handles.ProzesseSlider    ,'value',DRT_Config.Prozesse)
    DRTButton_Callback(handles.DRTButton, eventdata, handles)
    
end


% --- Executes during object creation, after setting all properties.
function ProzesseEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProzesseEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global DRT_Config
if isempty(DRT_Config)
    config
end

set(hObject,'string',num2str(DRT_Config.Prozesse))


% --- Executes on button press in DRT_Prozesse_use_button.
function DRT_Prozesse_use_button_Callback(hObject, eventdata, handles)
% hObject    handle to DRT_Prozesse_use_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;
global Cont_Process_Fit_Counter;

if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten')))
    return
end
TableCell = get(handles.ParamTable,'Data');
TableCell = cell2struct(TableCell',{'Name','Fix','Value','Min','Max','Lim'});

ColNames = get(handles.ProzesseTable,'ColumnName');
if strcmp(ColNames{1},'Val')
    ValCell = get(handles.ProzesseTable,'Data');
    ValCell(~cell2mat(ValCell(:,2)),:)=[];
    for i = 1:size(ValCell,1)
        parnummer = find(strcmp(ValCell{i,3},DRT_GUI.Fit.aktuell_Modell.P_Name(1,:)));
        if ~isempty(parnummer)
            TableCell(parnummer).Value = ValCell{i,1};
        end
    end
else
    TauCell = get(handles.ProzesseTable,'Data');
    TauCell = cell2struct(TauCell',{'tau','used','parname','r','phi'});

    %Schreibt die Tau1, Tau2 Werte aus der Tautabelle in die Daten_Fix_Tabelle
    for i = 1:numel(TauCell)
        parnummer = find(strcmp(TauCell(i).parname,DRT_GUI.Fit.aktuell_Modell.P_Name(1,:)));
        if ~isempty(parnummer)
            TableCell(parnummer).Value = TauCell(i).tau;
            TableCell(parnummer).Min = TauCell(i).tau / 1.5;
            TableCell(parnummer).Max = TauCell(i).tau * 1.5;
        end
        parnummer = find(strcmpi(strrep(lower(TauCell(i).parname),'tau','r'),DRT_GUI.Fit.aktuell_Modell.P_Name(1,:)));
        if isempty(parnummer)
            parnummer = find(strcmpi(strrep(strrep(lower(TauCell(i).parname),'tau','r'),'dl','ct'),DRT_GUI.Fit.aktuell_Modell.P_Name(1,:)));
        end
        if ~isempty(parnummer)
            TableCell(parnummer).Value = TauCell(i).r;
            %         TableCell(parnummer).Min = TauCell(i).r * 2;
            %         TableCell(parnummer).Max = TauCell(i).r * 0.5;
        end
    end
end
TableCell = struct2cell(TableCell)';
set(handles.ParamTable,'Data',TableCell)

PlotFittedParametersButton_Callback(handles.PlotFittedParametersButton, 'kein_plot', handles)

if get(handles.cont_process_checkbox,'value')
    
    FitButton_Callback(handles.FitButton, eventdata, handles)
   
end


% --- Executes on button press in Prozesse_fitten_button.
function Prozesse_fitten_button_Callback(hObject, eventdata, handles)
% hObject    handle to Prozesse_fitten_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;
global DRT_Config;
global Cont_Process_Fit_Counter;
global Cont_Process_Fit;
DRT_GUI.DRT.Config = DRT_Config;
if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'DRT'))) || isempty(DRT_GUI.DRT) || isempty(cell2mat(strfind(fieldnames(DRT_GUI.DRT),'EI_DRT'))) || isempty(DRT_GUI.DRT.EI_DRT)
    return
end
if DRT_Config.ZarcHN==5,
    DRT_GUI.DRT.Config.Prozesse=1;
    set(handles.ProzesseEdit,'string',1)
    ProzesseEdit_Callback(handles.ProzesseEdit, eventdata, handles)    
    set(handles.ProzessFittingChooseInitialValuesCheckbox,'value',0)
end
if get(handles.ProzessFittingChooseInitialValuesCheckbox,'Value') && (isempty(cell2mat(strfind(fieldnames(DRT_GUI.DRT),'UserTau'))) || numel(DRT_GUI.DRT.UserTau)<DRT_GUI.DRT.Config.Prozesse)
    set(handles.UserTauText,'Visible','On')
    if isempty(cell2mat(strfind(fieldnames(DRT_GUI.DRT),'UserTau')))
        DRT_GUI.DRT.UserTau=[];
    end
    return
end
if ~get(handles.ProzessFittingChooseInitialValuesCheckbox,'Value')
    if ~isempty(cell2mat(strfind(fieldnames(DRT_GUI.DRT),'UserTau')))
        DRT_GUI.DRT=rmfield(DRT_GUI.DRT,'UserTau');
    end
    set(handles.UserTauText,'Visible','Off')
    set(handles.UserTauList,'Visible','Off')
end
g_DRT = DRT_GUI.DRT.EI_DRT.g(DRT_GUI.DRT.EI_DRT.aktiv)';
x_DRT = DRT_GUI.DRT.EI_DRT.x(DRT_GUI.DRT.EI_DRT.aktiv)';
Rpol = trapz(x_DRT,g_DRT);
Tau_DRT = DRT_GUI.DRT.EI_DRT.tau(DRT_GUI.DRT.EI_DRT.aktiv);
OrigIndex = DRT_GUI.DRT.EI_DRT.OrigIndex;
g_orig = DRT_GUI.DRT.EI_DRT.g(OrigIndex)';
x_orig = DRT_GUI.DRT.EI_DRT.x(OrigIndex)';
Tau_orig = DRT_GUI.DRT.EI_DRT.tau(OrigIndex);
indices = find(g_orig>0);
g_orig = g_orig(indices);
x_orig = x_orig(indices);
Tau_orig = Tau_orig(indices);


p_init = ones(1,3*DRT_GUI.DRT.Config.Prozesse);
p_min =  zeros(1,3*DRT_GUI.DRT.Config.Prozesse);
p_max = ones(1,3*DRT_GUI.DRT.Config.Prozesse);
modelformel = '';
for i = 1:DRT_GUI.DRT.Config.Prozesse
    if DRT_Config.ZarcHN==1 %% Zarc-Elemente
        modelformel = [modelformel 'Calc_Zarc_DRT(p(' num2str((i-1)*3+1) ...
        '),p(' num2str((i-1)*3+2) ...
        '),p(' num2str((i-1)*3+3) ...
        '),tau)'];
        p_max((i-1)*3+2)=max(Tau_DRT);
        p_min((i-1)*3+2)=min(Tau_DRT);
        p_min((i-1)*3+3)=0.7;
        p_init((i-1)*3+3)=0.8;
    elseif DRT_Config.ZarcHN==2 %% HN-Elemente
        modelformel = [modelformel 'Calc_HN_DRT(p(' num2str((i-1)*3+1) ...
        '),p(' num2str((i-1)*3+2) ...
        '),p(' num2str((i-1)*3+3) ...
        '),tau)'];
        p_max((i-1)*3+2)=max(Tau_DRT);
        p_min((i-1)*3+2)=min(Tau_DRT);
        p_min((i-1)*3+3)=0.5;
        p_init((i-1)*3+3)=0.1;
    elseif DRT_Config.ZarcHN==3 %% RC-Glieder
        modelformel = [modelformel 'Calc_HN_DRT(p(' num2str((i-1)*3+1) ...
        '),p(' num2str((i-1)*3+2) ...
        '),p(' num2str((i-1)*3+3) ...
        '),tau)'];
        p_max((i-1)*3+2)=max(Tau_DRT);
        p_min((i-1)*3+2)=min(Tau_DRT);
        p_min((i-1)*3+3)=1;
        p_max((i-1)*3+3)=1;
        p_init((i-1)*3+3)=0.1;
    elseif DRT_Config.ZarcHN==4 %% Poröse Elektroden
        R_ct = ['p(' num2str((i-1)*3+1) ')'];
        Tau_dl = ['p(' num2str((i-1)*3+2) ')'];
        R_MP = ['p(' num2str((i-1)*3+3) ')'];
        modelformel = [modelformel 'Calc_PorEl_DRT(p(' num2str((i-1)*3+1) ...
        '),p(' num2str((i-1)*3+2) ...
        '),p(' num2str((i-1)*3+3) ...
        '),tau)'];
        p_max((i-1)*3+2)=max(Tau_DRT);
        p_min((i-1)*3+2)=min(Tau_DRT);
        p_min((i-1)*3+3)=0;
        p_max((i-1)*3+3)=1000;
        p_init((i-1)*3+3)=0.1;
    elseif DRT_Config.ZarcHN==5 %% MF-Model
        ModellElemente=DRT_GUI.Fit.aktuell_Modell.ModellCell{8}; 
        ParIndices = [];
        p_init=[];
        p_min=[];
        p_max=[];
        modelformel = '';
        EinzelFormeln={};
        for m_i = 1:numel(ModellElemente)
            if ~strcmp(ModellElemente{m_i}.Zfun_MF,'0')
                p_vorher = numel(ParIndices);
                Newindices = ModellElemente{m_i}.ParameterIndexes(~ismember(ModellElemente{m_i}.ParameterIndexes,ParIndices));
                delete_list =[];
                for s_i = 1:numel(Newindices) 
                    if isempty(strfind(ModellElemente{m_i}.Zfun_MF,DRT_GUI.Fit.aktuell_Modell.P_Name{1,Newindices(s_i)}))
                       delete_list = [delete_list s_i] ;
                    end
                end
                Newindices(delete_list)=[];
                ParIndices = [ParIndices Newindices];
                p_init = [p_init DRT_GUI.Fit.Parameter(Newindices)];
                p_min = [p_min DRT_GUI.Fit.Parameter_min(Newindices)];
                p_max = [p_max DRT_GUI.Fit.Parameter_max(Newindices)];
                for m_k = 1:numel(Newindices)
                    if DRT_GUI.Fit.ParFix(Newindices(m_k)) && isempty(strfind(lower(DRT_GUI.Fit.aktuell_Modell.P_Name{1,Newindices(m_k)}),'tau'))
                        p_min(p_vorher+m_k) =  p_init(p_vorher+m_k);
                        p_max(p_vorher+m_k) =  p_init(p_vorher+m_k);                        
                    end
                end
                ElementFormel = ModellElemente{m_i}.Zfun_MF;
                for m_k = 1:numel(ModellElemente{m_i}.ParameterIndexes)
                    ElementFormel=strrep(ElementFormel,...
                        DRT_GUI.Fit.aktuell_Modell.P_Name{1,ModellElemente{m_i}.ParameterIndexes(m_k)},...
                        ['p(' num2str(find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,ParIndices),DRT_GUI.Fit.aktuell_Modell.P_Name{1,ModellElemente{m_i}.ParameterIndexes(m_k)}))) ')']);
                end
                EinzelFormeln=[EinzelFormeln ; ElementFormel];
                modelformel = [modelformel '+Calc_Model_DRT(''' ElementFormel ''',p,tau)' ];
            end
            
        end
        if modelformel(1)=='+',modelformel=modelformel(2:end);end
    end
    if i < DRT_GUI.DRT.Config.Prozesse
        modelformel = [modelformel '+'];
    end
    %Widerstände sollen anfangs gleichverteilt sein
    %     if numel(FittingGUI.DRT.EI_DRT.ProzessFit.r)==FittingGUI.DRT.Config.Prozesse
    %         p_init((i-1)*3+1)= FittingGUI.DRT.EI_DRT.ProzessFit.r(i);
    %     else
    if ~DRT_Config.ZarcHN==5
        p_init((i-1)*3+1)=Rpol./DRT_GUI.DRT.Config.Prozesse;
        %     end
        p_max((i-1)*3+1)=sum(g_DRT);
        %Taus auch

        if sum(strcmp(fieldnames(DRT_GUI.DRT.EI_DRT),'ProzessFit')) && numel(DRT_GUI.DRT.EI_DRT.ProzessFit.tau)==DRT_GUI.DRT.Config.Prozesse
            p_init((i-1)*3+2)= DRT_GUI.DRT.EI_DRT.ProzessFit.tau(i);
        else
            p_init((i-1)*3+2)=10.^((log10(max(Tau_DRT))-log10(min(Tau_DRT)))/(DRT_GUI.DRT.Config.Prozesse+1)*i+log10(min(Tau_DRT)));
        end
    end

    
end
if get(handles.ProzessFittingChooseInitialValuesCheckbox,'Value')
    p_init(((1:DRT_GUI.DRT.Config.Prozesse)-1)*3+2) =  DRT_GUI.DRT.UserTau';
    
end

%nur weil function_model_all_types2 ein 'w' erwartet
modelformel = strrep(modelformel,'tau','w');

options = optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-4,'TolFun',1e-4);
[p,fval,exitflag,output]=function_fit_easyfit2(Tau_orig,[g_orig, zeros(size(g_orig))],p_init,@function_model_all_types2,p_min, p_max ,options, modelformel);

if sum(ismember(fieldnames(DRT_GUI),'DRT')) && ~isempty(DRT_GUI.DRT) && ...
        sum(ismember(fieldnames(DRT_GUI.DRT),'EI_DRT')) && ...
        ~isempty(DRT_GUI.DRT.EI_DRT) && ...
        sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT),'ProzessFit')) ...
        && ~isempty(DRT_GUI.DRT.EI_DRT.ProzessFit)
    old_peaks = DRT_GUI.DRT.EI_DRT.ProzessFit;
else
    old_peaks.used = 0;
end

if DRT_Config.ZarcHN==5 % MF-Model
    DRT_GUI.DRT.EI_DRT.ProzessFit.val = p';
    DRT_GUI.DRT.EI_DRT.ProzessFit.ParIndices = ParIndices';
    DRT_GUI.DRT.EI_DRT.ProzessFit.r =  [];
    DRT_GUI.DRT.EI_DRT.ProzessFit.tau =  [];
    DRT_GUI.DRT.EI_DRT.ProzessFit.phi= [];
    DRT_GUI.DRT.EI_DRT.ProzessFit.used = ones(size(DRT_GUI.DRT.EI_DRT.ProzessFit.val));
    DRT_GUI.DRT.EI_DRT.ProzessFit.used_parname =DRT_GUI.Fit.aktuell_Modell.P_Name(1,ParIndices)' ;
    DRT_GUI.DRT.EI_DRT.ProzessFit.ElementFormeln = EinzelFormeln;
    
else
    DRT_GUI.DRT.EI_DRT.ProzessFit.val = [];
    DRT_GUI.DRT.EI_DRT.ProzessFit.ParIndices = [];
    DRT_GUI.DRT.EI_DRT.ProzessFit.ElementFormeln = [];
    DRT_GUI.DRT.EI_DRT.ProzessFit.r =  p(((1:DRT_GUI.DRT.Config.Prozesse)-1)*3+1)';
    DRT_GUI.DRT.EI_DRT.ProzessFit.tau = p(((1:DRT_GUI.DRT.Config.Prozesse)-1)*3+2)';
    DRT_GUI.DRT.EI_DRT.ProzessFit.phi= p(((1:DRT_GUI.DRT.Config.Prozesse)-1)*3+3)';

    [DRT_GUI.DRT.EI_DRT.ProzessFit.tau , IX] = sort(DRT_GUI.DRT.EI_DRT.ProzessFit.tau);
    DRT_GUI.DRT.EI_DRT.ProzessFit.phi = DRT_GUI.DRT.EI_DRT.ProzessFit.phi(IX);
    DRT_GUI.DRT.EI_DRT.ProzessFit.r = DRT_GUI.DRT.EI_DRT.ProzessFit.r(IX);

    DRT_GUI.DRT.EI_DRT.ProzessFit.used = zeros(size(DRT_GUI.DRT.EI_DRT.ProzessFit.tau));
    DRT_GUI.DRT.EI_DRT.ProzessFit.used_parname = repmat({''},size(DRT_GUI.DRT.EI_DRT.ProzessFit.tau));

    if numel(old_peaks.used) == numel(old_peaks.tau)
    for i=find(old_peaks.used'==1)
        newpeak=find(abs(DRT_GUI.DRT.EI_DRT.ProzessFit.tau-old_peaks.tau(i)) == min(abs(DRT_GUI.DRT.EI_DRT.ProzessFit.tau-old_peaks.tau(i))),1,'first');
        if isempty(newpeak),continue,end
        oldfound = cell2mat(strfind(old_peaks.used_parname(1:i),DRT_GUI.DRT.EI_DRT.ProzessFit.used_parname{newpeak}));
        if isempty(oldfound)
            DRT_GUI.DRT.EI_DRT.ProzessFit.used(newpeak) = 1;
            DRT_GUI.DRT.EI_DRT.ProzessFit.used_parname(newpeak) = old_peaks.used_parname(i);
        else
            if abs(old_peaks.tau(oldfound)-DRT_GUI.DRT.EI_DRT.ProzessFit.tau(newpeak))>abs(old_peaks.tau(i)-DRT_GUI.DRT.EI_DRT.ProzessFit.tau(newpeak))
                DRT_GUI.DRT.EI_DRT.ProzessFit.used(newpeak) = 1;
                DRT_GUI.DRT.EI_DRT.ProzessFit.used_parname(newpeak) = old_peaks.used_parname(i);
            end
        end
    end
    end
end

if get(handles.ProzessFittingChooseInitialValuesCheckbox,'Value')
    DRT_GUI.DRT=rmfield(DRT_GUI.DRT,'UserTau');
    set(handles.UserTauText,'Visible','Off')
    set(handles.UserTauList,'Visible','Off')
    
end

Prozess_Taus_in_Tabelle(handles)
Typ = 'DRT';
if ~strcmp(eventdata,'kein_plot')
    
    axes(handles.axes3);
    plot_Auswaehl(DRT_GUI.Korrigiert,DRT_GUI.DRT.E_DRT,DRT_GUI.DRT.EI_DRT,[],Typ,handles)
end
if sum(DRT_GUI.DRT.EI_DRT.ProzessFit.r<1e-8)>0 , set(handles.ProzessFittingChooseInitialValuesCheckbox,'Value',0),end

if get(handles.cont_process_checkbox,'value')
    if Cont_Process_Fit_Counter < 15
        if Cont_Process_Fit_Counter == 0, Cont_Process_Fit = [];end
        Cont_Process_Fit_Counter = Cont_Process_Fit_Counter + 1;
        display(sprintf('Durchgang %d, rel. Standardabweichung %2.4e',Cont_Process_Fit_Counter,mean(std(Cont_Process_Fit,0,2)./mean(Cont_Process_Fit,2))));

        Cont_Process_Fit(:,Cont_Process_Fit_Counter) = [DRT_GUI.DRT.EI_DRT.ProzessFit.r ; DRT_GUI.DRT.EI_DRT.ProzessFit.tau;DRT_GUI.DRT.EI_DRT.ProzessFit.phi];
        
        
        if numel(find(old_peaks.used'==1)) > numel(find(DRT_GUI.DRT.EI_DRT.ProzessFit.used'==1))
            set(handles.cont_process_checkbox,'value',0)
            set(handles.GueltigeMessungCheck,'value',0)
            GueltigeMessungCheck_Callback(handles.GueltigeMessungCheck,eventdata,handles)
        elseif Cont_Process_Fit_Counter > 2 && mean(std(Cont_Process_Fit(:,end-2:end),0,2)./mean(Cont_Process_Fit(:,end-2:end),2)) < 0.02
            set(handles.cont_process_checkbox,'value',0)
            set(handles.GueltigeMessungCheck,'value',1)
            GueltigeMessungCheck_Callback(handles.GueltigeMessungCheck,eventdata,handles)
        else
            DRT_Prozesse_use_button_Callback(handles.DRT_Prozesse_use_button, eventdata, handles)
        end
    else
        set(handles.cont_process_checkbox,'value',0)
        set(handles.GueltigeMessungCheck,'value',0)
        GueltigeMessungCheck_Callback(handles.GueltigeMessungCheck,eventdata,handles)
    end

end

% --- Executes when entered data in editable cell(s) in ProzesseTable.
function ProzesseTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to ProzesseTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to TauTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
TauCell = get(handles.ProzesseTable,'Data');
TauCell = cell2struct(TauCell',{'Tau','Used','Parameter','R','Phi'});
Parameter_Taus = textscan(strrep(DRT_GUI.Fit.aktuell_Modell.ModellCell{1,3},' ',''),'%s','delimiter',',');
Parameter_Taus = Parameter_Taus{1,1}(~cellfun(@isempty,strfind(Parameter_Taus{1,1}','Tau')));
if eventdata.Indices(2) == 2 % used checkbox
    if eventdata.NewData
        used_nr = 0;
        for i = 1:eventdata.Indices(1)-1
            index = find( strcmp(TauCell(i).Parameter,Parameter_Taus),1,'first');
            if index > used_nr , used_nr = index; end
        end
        if used_nr == numel( Parameter_Taus)
            TauCell(eventdata.Indices(1)).Parameter = '';
            TauCell(eventdata.Indices(1)).Used = false;
        else
            TauCell(eventdata.Indices(1)).Parameter = Parameter_Taus{used_nr+1};
        end
    else
        TauCell(eventdata.Indices(1)).Parameter = '';
    end
end
if eventdata.Indices(2) == 2 || eventdata.Indices(2) == 3 % used checkbox or Parameter Dropdown-Box
    if TauCell(eventdata.Indices(1)).Used
        used_nr = 0;
        
        for i = 1:numel(TauCell)
            index = find( strcmp(TauCell(i).Parameter,Parameter_Taus),1,'first');
            if ~isempty(index) && index <= used_nr
                if used_nr == numel( Parameter_Taus)
                    TauCell(i).Parameter = '';
                    TauCell(i).Used = false;
                else
                    used_nr = used_nr + 1;
                    TauCell(i).Parameter = Parameter_Taus{used_nr};
                end
            elseif ~isempty(index) && index > used_nr
                used_nr = index;
            end
        end
    else
        TauCell(eventdata.Indices(1)).Parameter = '';
    end
end
TauCell = struct2cell(TauCell)';
set(handles.ProzesseTable,'Data',TauCell)
DRT_GUI.DRT.EI_DRT.ProzessFit.used = cell2mat(TauCell(:,2));
DRT_GUI.DRT.EI_DRT.ProzessFit.used_parname = TauCell(:,3);
axes(handles.axes3);
Typ = 'DRT';
plot_Auswaehl(DRT_GUI.Korrigiert,DRT_GUI.DRT.E_DRT,DRT_GUI.DRT.EI_DRT,[],Typ,handles)


% --- Executes when selected cell(s) is changed in TauTable.
function TauTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to TauTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function TauTable_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to TauTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ProzessFittingChooseInitialValuesCheckbox.
function ProzessFittingChooseInitialValuesCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to ProzessFittingChooseInitialValuesCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ProzessFittingChooseInitialValuesCheckbox



% --- Executes on selection change in UserTauList.
function UserTauList_Callback(hObject, eventdata, handles)
% hObject    handle to UserTauList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns UserTauList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from UserTauList


% --- Executes during object creation, after setting all properties.
function UserTauList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UserTauList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function plot_Auswaehl(plotDaten,Fdaten,Ddaten,Plot_Title,Typ,handles)
global DRT_GUI
FarbenLaden
switch Typ
    case 'Nyquist'
        hold off
        plot(plotDaten.Zreal,plotDaten.Zimg,'o-','DisplayName','Messung','color',RWTHBlau,'LineWidth',2);
        grid on;hold on; axis square; axis equal; set(gca,'ydir', 'reverse');
        if ~isempty(find(strcmp(fieldnames(plotDaten),'relax_fft'),1)) && ~isempty(plotDaten.relax_fft)
            plot(plotDaten.relax_fft.Zreal+plotDaten.relax_fft.Zreal_korrektur,plotDaten.relax_fft.Zimg,'o-','DisplayName','RelaxFFT','color',RWTHSchwarz,'LineWidth',1,'MarkerSize',7);
        end
        xlabel('$\Re\{\underline Z\}$ in $\Omega$','Interpreter','latex');ylabel('$\Im\{\underline Z\}$ in $\Omega$','Interpreter','latex'); %title(Plot_Title,'Interpreter','none');
        h1 = legend('show');
        set(h1,'Interpreter','none','Location','NorthWest');
        axis equal
    case 'Messung'
        hold off
        plot(plotDaten.Zreal(plotDaten.aktiv==1),plotDaten.Zimg(plotDaten.aktiv==1),'o','DisplayName','Messung','color',RWTHBlau,'LineWidth',1,'MarkerSize',7);hold on;
        plot(plotDaten.Zreal(plotDaten.aktiv==0),plotDaten.Zimg(plotDaten.aktiv==0),'o','DisplayName','ignoriert','color',RWTHMittelgrau,'LineWidth',1,'MarkerSize',7); % 'Marker', 'LineStyle','-'
        if ~isempty(find(strcmp(fieldnames(plotDaten),'relax_fft'),1)) && ~isempty(plotDaten.relax_fft)
            plot(plotDaten.relax_fft.Zreal(plotDaten.relax_fft.aktiv==1)+plotDaten.relax_fft.Zreal_korrektur,plotDaten.relax_fft.Zimg(plotDaten.relax_fft.aktiv==1),'o','DisplayName','RelaxFFT','color',RWTHSchwarz,'LineWidth',1,'MarkerSize',7);hold on;
            plot(plotDaten.relax_fft.Zreal(plotDaten.relax_fft.aktiv==0)+plotDaten.relax_fft.Zreal_korrektur,plotDaten.relax_fft.Zimg(plotDaten.relax_fft.aktiv==0),'o','DisplayName','ignoriert','color',RWTHDunkelgrau,'LineWidth',1,'MarkerSize',7); % 'Marker', 'LineStyle','-'
        end
        grid on; axis square; axis equal; set(gca,'ydir', 'reverse');
        xlabel('$\Re\{\underline Z\}$ in $\Omega$','Interpreter','latex');ylabel('$\Im\{\underline Z\}$ in $\Omega$','Interpreter','latex'); %title(Plot_Title,'Interpreter','none');
        h1 = legend('show');
        set(h1,'Interpreter','none','Location','NorthWest');
        axis equal
    case 'Hochpass'
        hold off
        plot(plotDaten.Zreal(plotDaten.HF_Ast==1),plotDaten.Zimg(plotDaten.HF_Ast==1),'o','DisplayName','Messung','color',RWTHBlau,'LineWidth',1,'MarkerSize',7);hold on;
        plot(plotDaten.Zreal(plotDaten.HF_Ast==0),plotDaten.Zimg(plotDaten.HF_Ast==0),'o','DisplayName','ignoriert','color',RWTHMittelgrau,'LineWidth',1,'MarkerSize',7); % 'Marker', 'LineStyle','-'
        grid on; axis square; axis equal; set(gca,'ydir', 'reverse');
        xlabel('$\Re\{\underline Z\}$ in $\Omega$','Interpreter','latex');ylabel('$\Im\{\underline Z\}$ in $\Omega$','Interpreter','latex'); %title(Plot_Title,'Interpreter','none');
        h1 = legend(Plot_Title,'Location','NorthWest');
        set(h1,'Interpreter','none');
        axis equal
    case 'Fit'
        hold off
        plot(plotDaten.Zreal(plotDaten.aktiv==1),plotDaten.Zimg(plotDaten.aktiv==1),'o','DisplayName','Messung','color',RWTHBlau,'LineWidth',1,'MarkerSize',7);hold on;
        plot(Fdaten.Zreal,Fdaten.Zimg,'x','DisplayName','Fit','color',RWTHRot,'LineWidth',1,'MarkerSize',7);
        plot(plotDaten.Zreal(plotDaten.aktiv==0),plotDaten.Zimg(plotDaten.aktiv==0),'o','DisplayName','ignoriert','color',RWTHMittelgrau,'LineWidth',1,'MarkerSize',7); % 'Marker', 'LineStyle','-'
        if ~isempty(find(strcmp(fieldnames(plotDaten),'relax_fft'),1)) && ~isempty(plotDaten.relax_fft)
            plot(plotDaten.relax_fft.Zreal(plotDaten.relax_fft.aktiv==1)+plotDaten.relax_fft.Zreal_korrektur,plotDaten.relax_fft.Zimg(plotDaten.relax_fft.aktiv==1),'o','DisplayName','RelaxFFT','color',RWTHSchwarz,'LineWidth',1,'MarkerSize',7);hold on;
            plot(plotDaten.relax_fft.Zreal(plotDaten.relax_fft.aktiv==0)+plotDaten.relax_fft.Zreal_korrektur,plotDaten.relax_fft.Zimg(plotDaten.relax_fft.aktiv==0),'o','DisplayName','ignoriert','color',RWTHDunkelgrau,'LineWidth',1,'MarkerSize',7); % 'Marker', 'LineStyle','-'
        end
        grid on; axis square; axis equal; set(gca,'ydir', 'reverse');
        xlabel('$\Re\{\underline Z\}$ in $\Omega$','Interpreter','latex');ylabel('$\Im\{\underline Z\}$ in $\Omega$','Interpreter','latex'); %title(Plot_Title,'Interpreter','none');
        
        h1 = legend('Messung','Fit','Location','NorthWest');
        set(h1,'Interpreter','none');
        axis equal
        
        p = Fdaten.Parameter;
        w = plotDaten.omega;
        for TauNr = find(~cellfun(@isempty,regexp(Fdaten.aktuell_Modell.P_Name(1,:),'Tau\d')))
            ZarcNr = str2mat(strrep(Fdaten.aktuell_Modell.P_Name{1,TauNr},'Tau',''));
            RNr=find(strcmp(Fdaten.aktuell_Modell.P_Name(1,:)',['R' num2str(ZarcNr)]));
            if ~isempty(ZarcNr) && ~isempty(RNr)
                PhiNr=find(strcmp(Fdaten.aktuell_Modell.P_Name(1,:)',['Phi' num2str(ZarcNr)]));
                if ~isempty(PhiNr)
                    schonen = [TauNr RNr PhiNr];
                else
                    schonen = [TauNr RNr];
                end
                formel_temp = strrep(strrep(Fdaten.aktuell_Modell.Rechnen_Modell,' ',''),'.','');
                for Alle_R = find(~cellfun(@isempty,regexp(Fdaten.aktuell_Modell.P_Name(1,:),'R*')))
                    if sum(schonen==Alle_R)==0
                        formel_temp = strrep(formel_temp,Fdaten.aktuell_Modell.P_Name{2,Alle_R},'0');
                    end
                end
                for Alle_C = find(~cellfun(@isempty,regexp(Fdaten.aktuell_Modell.P_Name(1,:),'C*')))
                    if sum(schonen==Alle_C)==0
                        formel_temp = strrep(formel_temp,['1/(1i*w*' Fdaten.aktuell_Modell.P_Name{2,Alle_C} ')'],'0');
                        formel_temp = strrep(formel_temp,['1/(i*w*' Fdaten.aktuell_Modell.P_Name{2,Alle_C} ')'],'0');
                    end
                end
                for Alle_L = find(~cellfun(@isempty,regexp(Fdaten.aktuell_Modell.P_Name(1,:),'L*')))
                    if sum(schonen==Alle_L)==0
                        formel_temp = strrep(formel_temp,['1i*w*' Fdaten.aktuell_Modell.P_Name{2,Alle_L}],'0');
                        formel_temp = strrep(formel_temp,['i*w*' Fdaten.aktuell_Modell.P_Name{2,Alle_L} ],'0');
                    end
                end
                formel_temp = strrep(strrep(strrep(formel_temp,'*','.*'),'/','./'),'^','.^');
                
                w = 1./p(TauNr);
                
                real_offset = real(eval(Fdaten.aktuell_Modell.Rechnen_Modell)) - ...
                    p(RNr)/2;
                w = plotDaten.omega;
                if isempty(real_offset) || isnan(real_offset), real_offset =0;end
                temp_real = real(eval(formel_temp))+real_offset;
                temp_img = imag(eval(formel_temp));
                %                 plot(temp_real,temp_img,'k')
                
            end
        end
    case 'HF_Fit'
        hold off
        plot(plotDaten.Zreal(plotDaten.HF_Ast==1),plotDaten.Zimg(plotDaten.HF_Ast==1),'o','DisplayName','Messung','color',RWTHBlau,'LineWidth',1,'MarkerSize',7);hold on;
        plot(Fdaten.Zreal,Fdaten.Zimg,'x','DisplayName','Fit','color',RWTHRot,'LineWidth',1,'MarkerSize',7);
        plot(plotDaten.Zreal(plotDaten.HF_Ast==0),plotDaten.Zimg(plotDaten.HF_Ast==0),'o','DisplayName','ignoriert','color',RWTHMittelgrau,'LineWidth',1,'MarkerSize',7); % 'Marker', 'LineStyle','-'
        if ~isempty(find(strcmp(fieldnames(plotDaten),'relax_fft'),1)) && ~isempty(plotDaten.relax_fft)
            plot(plotDaten.relax_fft.Zreal(plotDaten.relax_fft.aktiv==1)+plotDaten.relax_fft.Zreal_korrektur,plotDaten.relax_fft.Zimg(plotDaten.relax_fft.aktiv==1),'o','DisplayName','RelaxFFT','color',RWTHSchwarz,'LineWidth',1,'MarkerSize',7);hold on;
            plot(plotDaten.relax_fft.Zreal(plotDaten.relax_fft.aktiv==0)+plotDaten.relax_fft.Zreal_korrektur,plotDaten.relax_fft.Zimg(plotDaten.relax_fft.aktiv==0),'o','DisplayName','ignoriert','color',RWTHDunkelgrau,'LineWidth',1,'MarkerSize',7); % 'Marker', 'LineStyle','-'
        end
        grid on; axis square; axis equal; set(gca,'ydir', 'reverse');
        xlabel('$\Re\{\underline Z\}$ in $\Omega$','Interpreter','latex');ylabel('$\Im\{\underline Z\}$ in $\Omega$','Interpreter','latex'); %title(Plot_Title,'Interpreter','none');
        %xlim([min(Fdaten.Zreal) max(Fdaten.Zreal)]);
        ylim([min(Fdaten.Zimg) max(Fdaten.Zimg)]);
        h1 = legend('Messung','Fit','Location','NorthWest');
        set(h1,'Interpreter','none');
        axis equal
    case 'korrigiert'
        hold off
        plot(plotDaten.Zreal(plotDaten.aktiv==1),plotDaten.Zimg(plotDaten.aktiv==1),'o','DisplayName','Messung','color',RWTHBlau,'LineWidth',1,'MarkerSize',7);hold on;
        plot(plotDaten.Zreal(plotDaten.aktiv==0),plotDaten.Zimg(plotDaten.aktiv==0),'o','DisplayName','ignoriert','color',RWTHMittelgrau,'LineWidth',1,'MarkerSize',7); % 'Marker', 'LineStyle','-'
        grid on; axis square; axis equal; set(gca,'ydir', 'reverse');
        xlabel('$\Re\{\underline Z\}$ in $\Omega$','Interpreter','latex');ylabel('$\Im\{\underline Z\}$ in $\Omega$','Interpreter','latex'); %title(Plot_Title,'Interpreter','none');
        %h1 = legend(Plot_Title,'Location','NorthWest');
        %        set(h1,'Interpreter','none');
        axis equal
    case 'Korrigiert_Fit'
        hold off
        plot(plotDaten.Zreal(plotDaten.aktiv==1),plotDaten.Zimg(plotDaten.aktiv==1),'o','DisplayName','Messung','color',RWTHBlau,'LineWidth',1,'MarkerSize',7);hold on;
        plot(Fdaten.korrigiert.Zreal,Fdaten.korrigiert.Zimg,'xr');
        plot(plotDaten.Zreal(plotDaten.aktiv==0),plotDaten.Zimg(plotDaten.aktiv==0),'o','DisplayName','ignoriert','color',RWTHMittelgrau,'LineWidth',1,'MarkerSize',7); % 'Marker', 'LineStyle','-'
        grid on; axis square; axis equal; set(gca,'ydir', 'reverse');
        xlabel('$\Re\{\underline Z\}$ in $\Omega$','Interpreter','latex');ylabel('$\Im\{\underline Z\}$ in $\Omega$','Interpreter','latex'); %title(Plot_Title,'Interpreter','none');
        if ~isempty(find(strcmp(fieldnames(plotDaten),'spaps'),1)) && ~isempty(plotDaten.spaps)
            plot(plotDaten.spaps.Zreal,plotDaten.spaps.Zimg,'-','DisplayName','ignoriert','color',RWTHBlau,'LineWidth',2,'MarkerSize',7)
            h1 = legend('MF-Messung','MF-Fit','Location','South');
        else
            h1 = legend('MF-Messung','MF-Fit','Location','South');
        end
        
        set(h1,'Interpreter','none');
        axis equal
        p = Fdaten.Parameter;
        w = plotDaten.omega;
        if isempty(Fdaten.aktuell_Modell.ModellCell{8})
            for TauNr = find(~cellfun(@isempty,regexp(Fdaten.aktuell_Modell.P_Name(1,:),'Tau\d')))
                ZarcNr = str2mat(strrep(Fdaten.aktuell_Modell.P_Name{1,TauNr},'Tau',''));
                RNr=find(strcmp(Fdaten.aktuell_Modell.P_Name(1,:)',['R' num2str(ZarcNr)]));
                if ~isempty(ZarcNr) && ~isempty(RNr)
                    PhiNr=find(strcmp(Fdaten.aktuell_Modell.P_Name(1,:)',['Phi' num2str(ZarcNr)]));
                    if ~isempty(PhiNr)
                        schonen = [TauNr RNr PhiNr];
                    else
                        schonen = [TauNr RNr];
                    end
                    formel_temp = Fdaten.aktuell_Modell.Rechnen_Modell_komp;
                    for Alle_R = find(~cellfun(@isempty,regexp(Fdaten.aktuell_Modell.P_Name(1,:),'R*')))
                        if sum(schonen==Alle_R)==0
                            formel_temp = strrep(formel_temp,Fdaten.aktuell_Modell.P_Name{2,Alle_R},'0');
                        end
                    end
                    w = 1./p(TauNr);

                    real_offset = real(eval(Fdaten.aktuell_Modell.Rechnen_Modell_komp)) - ...
                        p(RNr)/2;
                    w = plotDaten.omega;
                    if isempty(real_offset) , real_offset =0;end
                    temp_real = real(eval(formel_temp))+real_offset;
                    temp_img = imag(eval(formel_temp));
                    if sum(abs(temp_img))>0
                        plot(temp_real,temp_img,'k')
                    end

                end
            end
        end
        
    case 'DRT'
        if get(handles.cont_process_checkbox,'value') == 0
            hold off;
            %cla(handles.axes4)
        else
            hold on;
            linien = get(gca,'Children');
            for i = 1:numel(linien),
                set(linien(i),'linewidth',0.5)
                set(linien(i),'color',[0.5 0.5 0.5])
                
            end
            %copyobj(linien,handles.axes4)
        end
        [AX, H1, H2 ]=plotyy(Ddaten.tau(Ddaten.aktiv),Ddaten.g(Ddaten.aktiv),plotDaten.tau(plotDaten.aktiv),plotDaten.Zimg(plotDaten.aktiv),@semilogx);
        set(H1,'color',RWTHBlau,'linewidth',2,'DisplayName','DRT')
        set(AX(1),'YColor',RWTHBlau)
        set(H2,'color',RWTHOrange,'linewidth',2,'DisplayName','Imaginärteil')
        set(AX(2),'YColor',RWTHOrange)
        
        set(gca,'ButtonDownFcn',{@ClickInDRT,handles});
        for ch_i = get(gca,'Children')
            set(ch_i,'HitTest','off');
        end
        grid on; hold on
        %semilogx(Fdaten.tau(Fdaten.aktiv),Fdaten.g(Fdaten.aktiv),'-k');
        grid on; hold on
        %         tau_diff = Ddaten.tau(1:end-1); g_diff = diff(Ddaten.g);
        %         index = find(Ddaten.aktiv(1:end-1) & abs([0 diff(g_diff)])<(mean(diff(g_diff))+5*std(diff(g_diff)))) ;
        %         g_diff = g_diff(index);tau_diff = tau_diff(index);
        %         tau_diff2 = Ddaten.tau(1:end-2); g_diff2 = diff(diff(Ddaten.g));
        %         index = find(Ddaten.aktiv(1:end-2) & abs([0 diff(g_diff2)])<(mean(diff(g_diff2))+5*std(diff(g_diff2)))) ;
        %         g_diff2 = g_diff2(index);tau_diff2 = tau_diff2(index);
        %         tau_diff3 = Ddaten.tau(1:end-2); g_diff3 = diff(diff(diff(Ddaten.g)));
        %         index = find(Ddaten.aktiv(1:end-3) & abs([0 diff(g_diff3)])<(mean(diff(g_diff3))+5*std(diff(g_diff3)))) ;
        %         g_diff3 = g_diff3(index);tau_diff3 = tau_diff3(index);
        %         semilogx(tau_diff,max(Ddaten.g(Ddaten.aktiv))/max(g_diff)*abs(g_diff),'-r');
        %         %semilogx(tau_diff2,max(Ddaten.g(Ddaten.aktiv))/max(g_diff2)*g_diff2,'-r');
        %         semilogx(tau_diff3,max(Ddaten.g(Ddaten.aktiv))/max(g_diff3)*g_diff3,'-g');
        xlabel('$\tau$ in s','interpreter','latex')
        semilogx(Ddaten.peaks.tau,Ddaten.peaks.g,'o','DisplayName','Peaks','color',RWTHSchwarz,'LineWidth',1,'MarkerSize',7)
        
        
        if sum(ismember(fieldnames(Ddaten.peaks),'used')) && sum(Ddaten.peaks.used)>0
            semilogx(Ddaten.peaks.tau(logical(Ddaten.peaks.used)),Ddaten.peaks.g(logical(Ddaten.peaks.used)),'o','DisplayName','benutzte Peaks','color',RWTHRot,'LineWidth',1,'MarkerSize',7)
            used_ParNr = [];
            for ip = find(Ddaten.peaks.used)'
                used_ParNr = [used_ParNr ; find(strcmp(Ddaten.peaks.used_parname(ip),DRT_GUI.Fit.aktuell_Modell.P_Name(1,:))) ];
            end
            semilogx(Ddaten.peaks.tau(logical(Ddaten.peaks.used)),Ddaten.peaks.g(logical(Ddaten.peaks.used)),'o','DisplayName','benutzte Peaks','color',RWTHRot,'LineWidth',1,'MarkerSize',7)
            if numel(used_ParNr)==numel(find(Ddaten.peaks.used))
                semilogx(DRT_GUI.Fit.Parameter(used_ParNr),Ddaten.peaks.g(logical(Ddaten.peaks.used)),'x','DisplayName','Fit','color',RWTHBlau,'LineWidth',1,'MarkerSize',7)
            end
        end
        
        
        if sum(ismember(fieldnames(DRT_GUI),'DRT')) && ~isempty(DRT_GUI.DRT) && ...
                sum(ismember(fieldnames(DRT_GUI.DRT),'EI_DRT')) && ...
                ~isempty(DRT_GUI.DRT.EI_DRT) && ...
                sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT),'ProzessFit')) ...
                && ~isempty(DRT_GUI.DRT.EI_DRT.ProzessFit) && ...
                sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT.ProzessFit),'tau')) ...
                && (~isempty(DRT_GUI.DRT.EI_DRT.ProzessFit.tau) || ( ...
                sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT.ProzessFit),'val')) && ...
                ~isempty(DRT_GUI.DRT.EI_DRT.ProzessFit.val)...
                ))
            DRT_Summe=zeros(size(Ddaten.tau));
            for iP = 1:numel(DRT_GUI.DRT.EI_DRT.ProzessFit.tau)
                
                if ~ismember('ZarcHN',fieldnames(DRT_GUI.DRT.Config))
                    DRT_GUI.DRT.Config.ZarcHN=1;
                end
                if DRT_GUI.DRT.Config.ZarcHN==1
                    DRT_einzeln = Calc_Zarc_DRT(DRT_GUI.DRT.EI_DRT.ProzessFit.r(iP),...
                        DRT_GUI.DRT.EI_DRT.ProzessFit.tau(iP),...
                        DRT_GUI.DRT.EI_DRT.ProzessFit.phi(iP),...
                        Ddaten.tau);
                elseif DRT_GUI.DRT.Config.ZarcHN==2 || DRT_GUI.DRT.Config.ZarcHN==3
                    DRT_einzeln = Calc_HN_DRT(DRT_GUI.DRT.EI_DRT.ProzessFit.r(iP),...
                        DRT_GUI.DRT.EI_DRT.ProzessFit.tau(iP),...
                        DRT_GUI.DRT.EI_DRT.ProzessFit.phi(iP),...
                        Ddaten.tau);
                elseif DRT_GUI.DRT.Config.ZarcHN==4 % PorEl
                    DRT_einzeln = Calc_PorEl_DRT(DRT_GUI.DRT.EI_DRT.ProzessFit.r(iP),...
                        DRT_GUI.DRT.EI_DRT.ProzessFit.tau(iP),...
                        DRT_GUI.DRT.EI_DRT.ProzessFit.phi(iP),...
                        Ddaten.tau);
                elseif DRT_GUI.DRT.Config.ZarcHN==5 % MF-Model
                    break;
                end
                if DRT_GUI.DRT.EI_DRT.ProzessFit.used(iP)
                    semilogx(Ddaten.tau(Ddaten.aktiv),DRT_einzeln(Ddaten.aktiv),'--','color',RWTHRot,'LineWidth',2)
                else
                    semilogx(Ddaten.tau(Ddaten.aktiv),DRT_einzeln(Ddaten.aktiv),'--','color',RWTHSchwarz,'LineWidth',2)
                end
                
                DRT_Summe = DRT_Summe+DRT_einzeln;
            end
            if DRT_GUI.DRT.Config.ZarcHN==5 && sum(ismember(fieldnames(DRT_GUI.DRT.EI_DRT.ProzessFit),'ElementFormeln')) && numel(DRT_GUI.DRT.EI_DRT.ProzessFit.ElementFormeln)>0
                for iP = 1:numel(DRT_GUI.DRT.EI_DRT.ProzessFit.ElementFormeln)
                    DRT_einzeln = Calc_Model_DRT( DRT_GUI.DRT.EI_DRT.ProzessFit.ElementFormeln{iP},DRT_GUI.DRT.EI_DRT.ProzessFit.val',Ddaten.tau);
                    if DRT_GUI.DRT.EI_DRT.ProzessFit.used(iP)
                        semilogx(Ddaten.tau(Ddaten.aktiv),DRT_einzeln(Ddaten.aktiv),'--','color',RWTHRot,'LineWidth',2)
                    else
                        semilogx(Ddaten.tau(Ddaten.aktiv),DRT_einzeln(Ddaten.aktiv),'--','color',RWTHSchwarz,'LineWidth',2)
                    end
                    DRT_Summe = DRT_Summe+DRT_einzeln;
                end
            end
            if ismember('OrigIndex',fieldnames(Ddaten))
                semilogx(Ddaten.tau(Ddaten.OrigIndex),DRT_Summe(Ddaten.OrigIndex),'x','color',RWTHRot,'LineWidth',2)
            end

        end
        %h1 = legend('EI-DRT','E-DRT','Location','NorthWest');
        ylabel(AX(2),'$\Im\{\underline Z\}$ in $\Omega$','Interpreter','latex')
        set(AX(2),'ydir', 'reverse');
        set(get(AX(1),'Ylabel'),'String','DRT$(\underline Z)$','Interpreter','latex')
        
        %set(h1,'Interpreter','none');
        
    case 'All_Fit'
        hold off
        plot(plotDaten.Zreal,plotDaten.Zimg,'o','DisplayName','Messung','color',RWTHBlau,'LineWidth',1,'MarkerSize',7);hold on;
        plot(Fdaten.Zreal+plotDaten.Zreal-Ddaten.Zreal,Fdaten.Zimg+plotDaten.Zimg-Ddaten.Zimg,'x','DisplayName','Fit','color',RWTHRot,'LineWidth',1,'MarkerSize',7);
        grid on; axis square; axis equal; set(gca,'ydir', 'reverse');
        xlabel('$\Re\{\underline Z\}$ in $\Omega$','Interpreter','latex');ylabel('$\Im\{\underline Z\}$ in $\Omega$','Interpreter','latex'); %title(Plot_Title,'Interpreter','none');
        
        h1 = legend('Messung','Fit','Location','NorthWest');
        set(h1,'Interpreter','none');
        axis equal
    otherwise
        return
end


function ClickInDRT(hObject, eventdata, handles)
global DRT_GUI;
pt = get(hObject,'CurrentPoint');
if isempty(DRT_GUI) || ...
        isempty(cell2mat(strfind(fieldnames(DRT_GUI),'DRT'))) || ...
        isempty(DRT_GUI.DRT) || ...
        isempty(cell2mat(strfind(fieldnames(DRT_GUI.DRT),'EI_DRT'))) || ...
        isempty(DRT_GUI.DRT.EI_DRT) || ...
        isempty(cell2mat(strfind(fieldnames(DRT_GUI.DRT),'UserTau'))) || ...
        numel(DRT_GUI.DRT.UserTau)==DRT_GUI.DRT.Config.Prozesse
    return
end
if numel(DRT_GUI.DRT.UserTau)<DRT_GUI.DRT.Config.Prozesse
    DRT_GUI.DRT.UserTau=[DRT_GUI.DRT.UserTau;pt(2,1)];
    set(handles.UserTauList,'String',num2str(DRT_GUI.DRT.UserTau));
    set(handles.UserTauList,'Visible','On')
end
if numel(DRT_GUI.DRT.UserTau)==DRT_GUI.DRT.Config.Prozesse
    Prozesse_fitten_button_Callback(handles.Prozesse_fitten_button, eventdata, handles)
end


% --- Executes on button press in Relax_FFT_Button.
function Relax_FFT_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Relax_FFT_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;

erase_index = diff(DRT_GUI.Messdaten.relax.zeit) == 0;
DRT_GUI.Messdaten.relax.strom(erase_index) = [];
DRT_GUI.Messdaten.relax.spannung(erase_index) = [];
DRT_GUI.Messdaten.relax.zeit(erase_index) = [];


extrapolationfactor = 1;
sampleTime = 10;

strom = squeeze([DRT_GUI.Messdaten.relax.strom, 0]);
span  = squeeze([DRT_GUI.Messdaten.relax.spannung, DRT_GUI.Messdaten.relax.spannung(end) ]);
zeit  = squeeze([DRT_GUI.Messdaten.relax.zeit, DRT_GUI.Messdaten.relax.zeit(end)*extrapolationfactor + 0.001]) ;
AhStep  = squeeze(trapz(zeit,strom));
xDaten = zeit;
zeit = zeit(1):0.01:zeit(end); % x-Interpolationswerte
strom = interp1(xDaten,strom,zeit,'linear');
span= interp1(xDaten,span,zeit,'linear');


%figure; plot(FittingGUI.Messdaten.relax.zeit,FittingGUI.Messdaten.relax.strom);grid on



[f, fft_imp, Cap, CompensatedVoltage, U_ges] = CreateTDM(zeit(1:end), strom(1:end), span(1:end), 1,1);

Pulsdauer = DRT_GUI.Messdaten.relax.zeit(find(abs(DRT_GUI.Messdaten.relax.strom)>1e-3,1,'last'))-DRT_GUI.Messdaten.relax.zeit(find(abs(DRT_GUI.Messdaten.relax.strom)>1e-3,1,'first'));
strom_fft = fft( strom );
strom_fft = strom_fft(1:numel(f));
[peakheight , peakindex ] = findpeaks(mag2db(abs(strom_fft)));
peaks = zeros(size(f));
peaks(peakindex)=1;
index = find(f ~= 0 & ( mag2db(abs(strom_fft))>0.98*max( mag2db(abs(strom_fft))) | peaks) & f < 1./sampleTime);
DRT_GUI.Messdaten.relax_fft.frequenz = flipdim(f(index),2)';
DRT_GUI.Messdaten.relax_fft.omega = flipdim(2*pi*f(index),2)';
DRT_GUI.Messdaten.relax_fft.tau = flipdim(1./(2*pi*f(index)),2)';
DRT_GUI.Messdaten.relax_fft.Z = transpose(flipdim(real( fft_imp(index) )+ 1i* (imag( fft_imp(index))- 1 ./ (2.*pi.*f(index) * Cap)),2));
DRT_GUI.Messdaten.relax_fft.Zreal = flipdim(real( fft_imp(index) ),2)';
DRT_GUI.Messdaten.relax_fft.Zimg = flipdim(imag( fft_imp(index))- 1 ./ (2.*pi.*f(index) * Cap),2)';
DRT_GUI.Messdaten.relax_fft.fitted_Cap = Cap;
DRT_GUI.Messdaten.relax_fft.aktiv = ones(size(DRT_GUI.Messdaten.relax_fft.frequenz));


DRT_GUI.Messdaten.relax_fft.Zreal_korrektur = 0;
if isempty(strfind(DRT_GUI.Testparameter.Zustand,'_RelaxFFT'))
    DRT_GUI.Testparameter.Zustand = [DRT_GUI.Testparameter.Zustand '_RelaxFFT'];
end

Alles_Laden(handles,eventdata)


%         figure;semilogx(f,mag2db(abs(strom_fft)));grid on
%         hold on
%         semilogx(f(index),mag2db(abs(strom_fft(index))),'r')
%         semilogx(f(peakindex),mag2db(abs(strom_fft(peakindex))),'or')
%
%
%         figure;plot(zeit,strom)


%index = find(f < 1./sampleTime, 1, 'last');
% figure;
% semilogx(f(index), imag( fft_imp(index))- 1 ./ (2.*pi.*f(index) * Cap), 'bo') % - 1 ./ (2.*pi.*f(index) * Cap), 'ro')
% hold on;
% grid on;
% semilogx(FittingGUI.Messdaten.frequenz,FittingGUI.Messdaten.Zimg,'rx')


% semilogx(f(index), real( fft_imp(index) )+FittingGUI.Messdaten.relax_fft.Zreal_korrektur, 'bo')
% semilogx(FittingGUI.Messdaten.frequenz,FittingGUI.Messdaten.Zreal,'rx')

%
%         figure;
%         plot(real( fft_imp(index)),imag( fft_imp(index)) - 1 ./ (2.*pi.*f(index) * Cap),'o-b');
%         grid on;hold on; axis square; axis equal; set(gca,'ydir', 'reverse');
%         plot(FittingGUI.Messdaten.Zreal,FittingGUI.Messdaten.Zimg,'xr')
%         xlabel('$\Re\{\underline Z\}$ in $\Omega$','Interpreter','latex');ylabel('$\Im\{\underline Z\}$ in $\Omega$','Interpreter','latex'); %title(Plot_Title,'Interpreter','none');
% %         h1 = legend(Plot_Title,'Location','NorthWest');
% %         set(h1,'Interpreter','none');
%         axis equal


    SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)



function RelaxFFT_PunkteWegnehmenTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to RelaxFFT_PunkteWegnehmenTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RelaxFFT_PunkteWegnehmenTextBox as text
%        str2double(get(hObject,'String')) returns contents of RelaxFFT_PunkteWegnehmenTextBox as a double


% --- Executes during object creation, after setting all properties.
function RelaxFFT_PunkteWegnehmenTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RelaxFFT_PunkteWegnehmenTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RelaxFFT_PunkteWegnehmenButton.
function RelaxFFT_PunkteWegnehmenButton_Callback(hObject, eventdata, handles)
% hObject    handle to RelaxFFT_PunkteWegnehmenButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;

if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten'))) || isempty(DRT_GUI.Messdaten) || isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) || isempty(DRT_GUI.Messdaten.relax_fft)
    return
end

Typ = 'Nyquist';
if ~strcmp(eventdata,'kein_plot')
    axes(handles.axes1); hold off;
    plot_Auswaehl(DRT_GUI.Messdaten,[],[],DRT_GUI.Testparameter.Batterie,Typ);
else
end


LP_str = get(handles.RelaxFFT_PunkteWegnehmenTextBox,'string');

DRT_GUI.Messdaten.relax_fft.aktiv = ones(size(DRT_GUI.Messdaten.relax_fft.Z));
if ~isempty(get(handles.RelaxFFT_PunkteWegnehmenTextBox,'string'))
    eval(['DRT_GUI.Messdaten.relax_fft.aktiv([' LP_str ']) = 0;']);
end
DRT_GUI.Messdaten.relax_fft.low_Punkte_Weg = LP_str;
Typ = 'Messung';

% neu plot
if ~strcmp(eventdata, 'kein_plot')
    axes(handles.axes1); hold off;
    plot_Auswaehl(DRT_GUI.Messdaten,[],[],DRT_GUI.Testparameter.Batterie,Typ);
else
end

function Relax_Visible(handles,on_off_string)
set(handles.AutoCorrectZrealButton,'visible',on_off_string)
set(handles.Zreal_korrektur_textbox,'visible',on_off_string)
set(handles.RelaxFFT_PunkteWegnehmenTextBox,'visible',on_off_string)
set(handles.RelaxFFT_PunkteWegnehmenButton,'visible',on_off_string)

function Zreal_korrektur_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to Zreal_korrektur_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Zreal_korrektur_textbox as text
%        str2double(get(hObject,'String')) returns contents of Zreal_korrektur_textbox as a double
global DRT_GUI;

if  isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten'))) || isempty(DRT_GUI.Messdaten)|| isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) || isempty(DRT_GUI.Messdaten.relax_fft)
    set(hObject,'string','0.00');
    Relax_Visible(handles,'off')
end
try
    Wert = str2num(get(hObject,'string'));
    if isempty(Wert),Wert=0;end
    DRT_GUI.Messdaten.relax_fft.Zreal_korrektur = Wert;
    set(hObject,'string',num2str(DRT_GUI.Messdaten.relax_fft.Zreal_korrektur,'%8.4e'))
    
catch error_msg
    set(hObject,'string',num2str(DRT_GUI.Messdaten.relax_fft.Zreal_korrektur,'%8.4e'))
    errordlg(error_msg)
end



% --- Executes during object creation, after setting all properties.
function Zreal_korrektur_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zreal_korrektur_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AutoCorrectZrealButton.
function AutoCorrectZrealButton_Callback(hObject, eventdata, handles)
% hObject    handle to AutoCorrectZrealButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
[f_sorted ,order ] = sort(DRT_GUI.Messdaten.frequenz);
Zreal_sorted = DRT_GUI.Messdaten.Zreal(order);
indices = 1:ceil(numel(DRT_GUI.Messdaten.relax_fft.frequenz)*0.2);
DRT_GUI.Messdaten.relax_fft.Zreal_korrektur = mean(spline(log(f_sorted),Zreal_sorted,log(DRT_GUI.Messdaten.relax_fft.frequenz(indices))) - DRT_GUI.Messdaten.relax_fft.Zreal(indices));
Alles_Laden(handles,eventdata);


% --- Executes on button press in cont_process_checkbox.
function cont_process_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to cont_process_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cont_process_checkbox
global Cont_Process_Fit_Counter
if get(hObject,'Value')
   Cont_Process_Fit_Counter = 0;
end


% --------------------------------------------------------------------
function MenAlleZustaendeDRTPlot_Callback(hObject, eventdata, handles)
% hObject    handle to MenAlleZustaendeDRTPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;

% figure;
% firstline = semilogx(1,1);
% new_ax = gca;
Zustaende = get(handles.ZustandPopup ,'String');
% delete(firstline);


Zustandaliases=[];
Batteriename = get(handles.BatterieNamePopup,'string');
Batteriename = Batteriename{get(handles.BatterieNamePopup,'value')};
if ~isempty(dir(['output/' Batteriename '/Zustandaliases.mat'])) 
    Zustandaliases = load(['output/' Batteriename '/Zustandaliases.mat']);
    Zustandaliases = Zustandaliases.Zustandaliases;
elseif ~isempty(dir(['output/' Batteriename '/Zustandaliases.xlsx'])) 
    [Zustandndata Zustandtext ZustandXLS] = xlsread(['output/' Batteriename '/Zustandaliases.xlsx']);
    for i = 2:size(ZustandXLS,2)
        Zustandaliases{1,i-1}.name=Zustandtext{1,i};
        Zustandaliases{1,i-1}.unit=Zustandtext{2,i};
        Zustandaliases{1,i-1}.value=cell2mat(ZustandXLS(3:end,i));
        Zustandaliases{1,i-1}.Zustands_name=ZustandXLS(3:end,1);
    end
elseif ~isempty(dir(['output/' Batteriename '/Zustandaliases.xls'])) 
    [Zustandndata Zustandtext ZustandXLS] = xlsread(['output/' Batteriename '/Zustandaliases.xlsx']);
    for i = 2:size(ZustandXLS,2)
        Zustandaliases{1,i-1}.name=Zustandtext{1,i};
        Zustandaliases{1,i-1}.unit=Zustandtext{2,i};
        Zustandaliases{1,i-1}.value=cell2mat(ZustandXLS(3:end,i));
        Zustandaliases{1,i-1}.Zustands_name=ZustandXLS(3:end,1);
    end
end

    Zustandsurf.tau=[];
    Zustandsurf.g=[];
    Zustandsurf.p={};
    Zustandsurf.aliases={};

    for i_Z = 1:numel(Zustaende)

        if isempty(Zustaende{i_Z}) || ~isempty(strfind(Zustaende{i_Z},'gray'))
            continue
        end
        axes(handles.axes3);
        %     [a,b,c,legende] = legend;
        %     legendPosition = get(a,'Location');
        x_label =  get(get(gca,'xlabel'),'string');
        y_label =  get(get(gca,'ylabel'),'string');
        set(handles.ZustandPopup,'Value',i_Z)
        ZustandPopup_Callback(handles.ZustandPopup,'kein_plot',handles)
        xlimits = xlim;
        ylimits = ylim;
        
        if ~isempty(Zustandaliases)
            ZAlias = nan(numel(Zustandaliases),1);
                
            for i_a = 1:numel(Zustandaliases)
                Zustandsurf.AliasName{i_a}=Zustandaliases{i_a}.name;
                Zustandsurf.AliasUnit{i_a}=Zustandaliases{i_a}.unit;
                
                Z_index = find(strcmp(DRT_GUI.Testparameter.Zustand,Zustandaliases{i_a}.Zustands_name));
                if ~isempty(Z_index),
                    ZAlias(i_a) = Zustandaliases{i_a}.value(Z_index);
                end
                if numel(Zustandsurf.aliases)<i_a
                    Zustandsurf.aliases{i_a}=[];
                end

                Zustandsurf.aliases{i_a} = [Zustandsurf.aliases{i_a}; repmat(ZAlias(i_a),numel(DRT_GUI.DRT.EI_DRT.tau(DRT_GUI.DRT.EI_DRT.aktiv)),1)];
            end
                

            
            

            Zustandsurf.tau = [Zustandsurf.tau ; DRT_GUI.DRT.EI_DRT.tau(DRT_GUI.DRT.EI_DRT.aktiv)];
            Zustandsurf.g = [Zustandsurf.g ; DRT_GUI.DRT.EI_DRT.g(DRT_GUI.DRT.EI_DRT.aktiv)'];
            for i_p = 1:numel(DRT_GUI.DRT.EI_DRT.ProzessFit.r)
                if numel(Zustandsurf.p)<i_p
                    Zustandsurf.p{i_p}=[];
                end
                Zustandsurf.p{i_p} = [Zustandsurf.p{i_p} ; Calc_Zarc_DRT(DRT_GUI.DRT.EI_DRT.ProzessFit.r(i_p),DRT_GUI.DRT.EI_DRT.ProzessFit.tau(i_p),DRT_GUI.DRT.EI_DRT.ProzessFit.phi(i_p),DRT_GUI.DRT.EI_DRT.tau(DRT_GUI.DRT.EI_DRT.aktiv))];
            end
            
 
        end
    

        Zustandstring = DRT_GUI.Testparameter.Zustand;
    
    
%     Lines = get(handles.axes3,'Children');
%     for i=1:numel(Lines)-2
%         newlines = copyobj(Lines(i),new_ax);
%         set(newlines(end),'DisplayName',[Zustandstring ' Prozess ' char('A'+(numel(Lines)-1-i)-1)]);
%     end
%     axes(new_ax)
%     xlabel(x_label);ylabel(y_label);
%     new_xlim = xlim;
%     new_ylim = ylim;
%     if new_xlim(1)< xlimits(1),xlimits(1) = new_xlim(1);end
%     if new_xlim(2)> xlimits(2),xlimits(2) = new_xlim(2);end
%     
%     if new_ylim(1)< ylimits(1),ylimits(1) = new_ylim(1);end
%     if new_ylim(2)> ylimits(2),ylimits(2) = new_ylim(2);end
%     if ylimits(1)<0,ylimits(1)=0;end
%     
    %xlim(xlimits)
    %ylim(ylimits)
    
end
% grid on;
% axes(handles.axes3);
% legend(legende,'Location',legendPosition);
% axes(new_ax);
if isempty(dir('export'))
    mkdir('export')
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie])
end
achsen = get(gcf,'Children');
% achsen = achsen(isgraphics(achsen,'axes'));
% for j = 1:numel(achsen)
%     set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
%     set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
%     set(achsen(j),'Fontname','Arial','Fontsize',16)
%     linien = get(achsen(j),'Children');
%     linien = linien(isgraphics(linien,'line'));
%     for i = 1:numel(linien),
%        if isgraphics(linien(i),'line') 
%            set(linien(i),'linewidth',2)
%        end
%     end
% end
% title('')
% print(gcf,['export' '/' FittingGUI.Testparameter.Batterie '/' FittingGUI.Testparameter.Batterie ' ' num2str(FittingGUI.Testparameter.Temperatur) '°C ' num2str(round(FittingGUI.Testparameter.SOC/5)*5) '% SOC DRTProzesse2D.png'], '-dpng', '-r900');
% title([FittingGUI.Testparameter.Batterie ' ' num2str(FittingGUI.Testparameter.Temperatur) '°C ' num2str(round(FittingGUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
% saveas(gcf,['export' '/' FittingGUI.Testparameter.Batterie '/' FittingGUI.Testparameter.Batterie ' ' num2str(FittingGUI.Testparameter.Temperatur) '°C ' num2str(round(FittingGUI.Testparameter.SOC/5)*5) '% SOC DRTProzesse2D.fig'])

for i = 1:numel(Zustandaliases)
    index = find(~isnan(Zustandsurf.aliases{i}));
    F_g = scatteredInterpolant(log10(Zustandsurf.tau(index)),Zustandsurf.aliases{i}(index),Zustandsurf.g(index));
    F_p={};
    [logtaugrid ,zgrid] = meshgrid(log10(min(Zustandsurf.tau(index))):0.1:log10(max(Zustandsurf.tau(index))),unique(Zustandsurf.aliases{i}(index)));
    gsurf = F_g(logtaugrid,zgrid);
    figure;
    surf(10.^logtaugrid,zgrid,gsurf,'LineStyle',':'); set(gca,'xscale','log')
    xlabel('Tau in s')
    if ~isempty(Zustandsurf.AliasUnit{i})
        ylabel([Zustandsurf.AliasName{i} ' in ' Zustandsurf.AliasUnit{i}])
    else
        ylabel(Zustandsurf.AliasName{i})
    end
    zlabel('DRT(Z)')
    set(gca,'xscale','log')
    hold on; grid on
    achsen = get(gcf,'Children');
    achsen = achsen(isgraphics(achsen,'axes'));
    for j = 1:numel(achsen)
        set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'zlabel'),'Fontname','arial','fontsize',15);
        set(achsen(j),'Fontname','Arial','Fontsize',16)
        linien = get(achsen(j),'Children');
        linien = linien(isgraphics(linien,'line'));
        for li = 1:numel(linien),
           if isgraphics(linien(li),'line') 
               set(linien(li),'linewidth',2)
           end
        end
    end
    title('')
    print(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i}  ' DRTSurf.png'], '-dpng', '-r900');
    title([DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
    saveas(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' DRTSurf.fig'])
    
    
    for p_i = 1:numel(Zustandsurf.p)
        F_p{p_i} = scatteredInterpolant(log10(Zustandsurf.tau(index)),Zustandsurf.aliases{i}(index),Zustandsurf.p{p_i}(index));
        psurf{p_i} = F_p{p_i}(logtaugrid,zgrid);
        figure;
        surf(10.^logtaugrid,zgrid,psurf{p_i},'LineStyle',':'); set(gca,'xscale','log')
        xlabel('Tau in s')
        if ~isempty(Zustandsurf.AliasUnit{i})
            ylabel([Zustandsurf.AliasName{i} ' in ' Zustandsurf.AliasUnit{i}])
        else
            ylabel(Zustandsurf.AliasName{i})
        end
        zlabel('DRT(Z)')
        set(gca,'xscale','log')
        hold on; grid on
        achsen = get(gcf,'Children');
        achsen = achsen(isgraphics(achsen,'axes'));
        for j = 1:numel(achsen)
            set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
            set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
            set(get(achsen(j),'zlabel'),'Fontname','arial','fontsize',15);
            set(achsen(j),'Fontname','Arial','Fontsize',16)
            linien = get(achsen(j),'Children');
            linien = linien(isgraphics(linien,'line'));
            for li = 1:numel(linien),
               if isgraphics(linien(li),'line') 
                   set(linien(li),'linewidth',2)
               end
            end
        end
        title('')
        print(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' P' num2str(p_i) 'Surf.png'], '-dpng', '-r900');
        title([DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
        saveas(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' P' num2str(p_i) 'Surf.fig'])
        
    end
    
    z_values=unique(Zustandsurf.aliases{i}(index));
    cmap=hot(ceil(numel(z_values)*1.8));
    figure;
     set(gcf,'renderer','opengl');
    surf(logtaugrid,zgrid,gsurf,'LineStyle','none','FaceAlpha',0.4); 
    hold on
    for z_index = 1:numel(z_values) 
        indices = find(Zustandsurf.aliases{i}==z_values(z_index));
        plot3(log10(Zustandsurf.tau(indices)),repmat(z_values(z_index),size(Zustandsurf.tau(indices))),Zustandsurf.g(indices),'color',cmap(z_index,:),'Displayname',[num2str(z_values(z_index)) ' ' Zustandsurf.AliasUnit{i} ' ' Zustandsurf.AliasName{i}],'LineWidth',3)
        hold on ;grid on
        xlabel('log_{10}(Tau in s)')
        if ~isempty(Zustandsurf.AliasUnit{i})
            ylabel([Zustandsurf.AliasName{i} ' in ' Zustandsurf.AliasUnit{i}])
        else
            ylabel(Zustandsurf.AliasName{i})
        end
        zlabel('DRT(Z)')

    end
    achsen = get(gcf,'Children');
    achsen = achsen(isgraphics(achsen,'axes'));
    for j = 1:numel(achsen)
        set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'zlabel'),'Fontname','arial','fontsize',15);
        set(achsen(j),'Fontname','Arial','Fontsize',16)
        linien = get(achsen(j),'Children');
        linien = linien(isgraphics(linien,'line'));
        for li = 1:numel(linien),
           if isgraphics(linien(li),'line') 
               set(linien(li),'linewidth',2)
           end
        end
    end
    title('')
    print(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' DRTPlot3Transp.png'], '-dpng', '-r900');
    title([DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
    saveas(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' DRTPlot3Transp.fig'])
    
    figure;
    for z_index = 1:numel(z_values) 
        indices = find(Zustandsurf.aliases{i}==z_values(z_index));
        plot3(Zustandsurf.tau(indices),repmat(z_values(z_index),size(Zustandsurf.tau(indices))),Zustandsurf.g(indices),'color',cmap(z_index,:),'Displayname',[num2str(z_values(z_index)) ' ' Zustandsurf.AliasUnit{i} ' ' Zustandsurf.AliasName{i}],'LineWidth',3)
        hold on ; grid on
        xlabel('Tau in s')
        if ~isempty(Zustandsurf.AliasUnit{i})
            ylabel([Zustandsurf.AliasName{i} ' in ' Zustandsurf.AliasUnit{i}])
        else
            ylabel(Zustandsurf.AliasName{i})
        end
        zlabel('DRT(Z)')
        set(gca,'xscale','log')
    end
    achsen = get(gcf,'Children');
    achsen = achsen(isgraphics(achsen,'axes'));
    for j = 1:numel(achsen)
        set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'zlabel'),'Fontname','arial','fontsize',15);
        set(achsen(j),'Fontname','Arial','Fontsize',16)
        linien = get(achsen(j),'Children');
        linien = linien(isgraphics(linien,'line'));
        for li = 1:numel(linien),
           if isgraphics(linien(li),'line') 
               set(linien(li),'linewidth',2)
           end
        end
    end
    title('')
    print(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' DRTPlot3.png'], '-dpng', '-r900');
    title([DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
    saveas(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' DRTPlot3.fig'])
    
    
    figure;
    for z_index = 1:numel(z_values) 
        indices = find(Zustandsurf.aliases{i}==z_values(z_index));
        semilogx(Zustandsurf.tau(indices),Zustandsurf.g(indices),'color',cmap(z_index,:),'Displayname',[num2str(z_values(z_index)) ' ' Zustandsurf.AliasUnit{i} ' ' Zustandsurf.AliasName{i}],'LineWidth',3)
        hold on ; grid on
        xlabel('Tau in s')
        ylabel('DRT(Z)')
        
    end
    achsen = get(gcf,'Children');
    achsen = achsen(isgraphics(achsen,'axes'));
    for j = 1:numel(achsen)
        set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
        set(achsen(j),'Fontname','Arial','Fontsize',16)
        linien = get(achsen(j),'Children');
        linien = linien(isgraphics(linien,'line'));
        for li = 1:numel(linien),
           if isgraphics(linien(li),'line') 
               set(linien(li),'linewidth',2)
           end
        end
    end
    lhandle=legend('show','Location','NorthWest');
    LEG = findobj(lhandle,'type','text');
    set(LEG,'FontSize',9)
    title('')
    print(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' DRTPlot2D.png'], '-dpng', '-r900');
    title([DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
    saveas(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' DRTPlot2D.fig'])
    
    
    
    for p_i = 1:numel(Zustandsurf.p)
        figure;
        for z_index = 1:numel(z_values) 
            indices = find(Zustandsurf.aliases{i}==z_values(z_index));
            plot3(Zustandsurf.tau(indices),repmat(z_values(z_index),size(Zustandsurf.tau(indices))),Zustandsurf.p{p_i}(indices),'color',cmap(z_index,:),'Displayname',['P' num2str(p_i) ' ' num2str(z_values(z_index)) ' ' Zustandsurf.AliasUnit{i} ' ' Zustandsurf.AliasName{i}],'LineWidth',3)
            set(gca,'xscale','log')
            hold on; grid on
        end
        xlabel('Tau in s')
        if ~isempty(Zustandsurf.AliasUnit{i})
            ylabel([Zustandsurf.AliasName{i} ' in ' Zustandsurf.AliasUnit{i}])
        else
            ylabel(Zustandsurf.AliasName{i})
        end
        zlabel('DRT(Z)')
        achsen = get(gcf,'Children');
        achsen = achsen(isgraphics(achsen,'axes'));
        for j = 1:numel(achsen)
            set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
            set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
            set(get(achsen(j),'zlabel'),'Fontname','arial','fontsize',15);
            set(achsen(j),'Fontname','Arial','Fontsize',16)
            linien = get(achsen(j),'Children');
            linien = linien(isgraphics(linien,'line'));
            for li = 1:numel(linien),
               if isgraphics(linien(li),'line') 
                   set(linien(li),'linewidth',2)
               end
            end
        end
        title('')
        print(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' P' num2str(p_i) 'Plot3.png'], '-dpng', '-r900');
        title([DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
        saveas(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' P' num2str(p_i) 'Plot3.fig'])

        figure;
        for z_index = 1:numel(z_values) 
            indices = find(Zustandsurf.aliases{i}==z_values(z_index));
            semilogx(Zustandsurf.tau(indices),Zustandsurf.p{p_i}(indices),'color',cmap(z_index,:),'Displayname',['P' num2str(p_i) ' ' num2str(z_values(z_index)) ' ' Zustandsurf.AliasUnit{i} ' ' Zustandsurf.AliasName{i}],'LineWidth',3)
            hold on; grid on
        end
        xlabel('Tau in s')
        ylabel('DRT(Z)')
        achsen = get(gcf,'Children');
        achsen = achsen(isgraphics(achsen,'axes'));
        for j = 1:numel(achsen)
            set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
            set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
            set(achsen(j),'Fontname','Arial','Fontsize',16)
            linien = get(achsen(j),'Children');
            linien = linien(isgraphics(linien,'line'));
            for li = 1:numel(linien),
               if isgraphics(linien(li),'line') 
                   set(linien(li),'linewidth',2)
               end
            end
        end
        lhandle=legend('show','Location','NorthWest');
        LEG = findobj(lhandle,'type','text');
        set(LEG,'FontSize',9)
        title('')
        print(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' P' num2str(p_i) 'Plot2D.png'], '-dpng', '-r900');
        title([DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
        saveas(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' P' num2str(p_i) 'Plot2D.fig'])

        
        figure;
        set(gcf,'renderer','opengl')
        surf(logtaugrid,zgrid,psurf{p_i},'LineStyle','none','FaceAlpha',0.4); 
        hold on;
        for z_index = 1:numel(z_values) 
            indices = find(Zustandsurf.aliases{i}==z_values(z_index));
            plot3(log10(Zustandsurf.tau(indices)),repmat(z_values(z_index),size(Zustandsurf.tau(indices))),Zustandsurf.p{p_i}(indices),'color',cmap(z_index,:),'Displayname',['P' num2str(p_i) ' ' num2str(z_values(z_index)) ' ' Zustandsurf.AliasUnit{i} ' ' Zustandsurf.AliasName{i}],'LineWidth',3)
            hold on; grid on
        end
        xlabel('log_{10}(Tau in s)')
        if ~isempty(Zustandsurf.AliasUnit{i})
            ylabel([Zustandsurf.AliasName{i} ' in ' Zustandsurf.AliasUnit{i}])
        else
            ylabel(Zustandsurf.AliasName{i})
        end
        zlabel('DRT(Z)')
        achsen = get(gcf,'Children');
        achsen = achsen(isgraphics(achsen,'axes'));
        for j = 1:numel(achsen)
            set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
            set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
            set(get(achsen(j),'zlabel'),'Fontname','arial','fontsize',15);
            set(achsen(j),'Fontname','Arial','Fontsize',16)
            linien = get(achsen(j),'Children');
            linien = linien(isgraphics(linien,'line'));
            for li = 1:numel(linien),
               if isgraphics(linien(li),'line') 
                   set(linien(li),'linewidth',2)
               end
            end
        end
        title('')
        print(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' P' num2str(p_i) 'Plot3Transp.png'], '-dpng', '-r900');
        title([DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
        saveas(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' P' num2str(p_i) 'Plot3Transp.fig'])

    end
    
end

% --------------------------------------------------------------------
function MenAlleDRTExportieren_Callback(hObject, eventdata, handles)
% hObject    handle to MenAlleDRTExportieren (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
choice = questdlg('Dieses Script exportiert die DRT-Berechnung alle SOCs und aller Temperaturen. Fortfahren?', ...
    'Script', ...
    'Abbrechen','Alle Exportieren','Abbrechen');
% Handle response
if isempty(choice), return,end
switch choice
    case 'Abbrechen'
        return
end
Zustaende = get(handles.ZustandPopup ,'String');
Testparameter = [];
Messdaten=[];
DRT=[];
Prozesse=[];
for i_Z = 1:numel(Zustaende)
    
    if isempty(Zustaende{i_Z})
        continue
    end
    set(handles.ZustandPopup,'Value',i_Z)
    
    ZustandPopup_Callback(handles.ZustandPopup,eventdata,handles)
    TList = get(handles.TemperaturPopup,'String');
    for k = 2:numel(TList)
        set(handles.TemperaturPopup,'Value',k)
        TemperaturPopup_Callback(handles.TemperaturPopup,eventdata,handles)
        SOCList = get(handles.SOCPopup,'String');
        for i = 2:numel(SOCList)
            set(handles.SOCPopup,'Value',i)
            SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
            MenDRTExportieren_Callback(handles.MenDRTExportieren,eventdata,handles)
            TempData = load(['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad/' ...
                DRT_GUI.Testparameter.Batterie '_' DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_' [strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m')] 'SOC_DRT.mat']);
            if isempty(Testparameter);
                Testparameter = TempData.Data.Testparameter;
                Messdaten = TempData.Data.Messdaten;
                DRT = TempData.Data.DRT;
                Prozesse = TempData.Data.Prozesse;
            else
                Testparameter(end+1) = Testparameter(end);
                felder = fieldnames(TempData.Data.Testparameter);
                for fi = 1:numel(felder)
                    Testparameter(end).(felder{fi}) = TempData.Data.Testparameter.(felder{fi});
                end
                
                Messdaten(end+1) = TempData.Data.Messdaten;
                DRT(end+1) = TempData.Data.DRT;
                Prozesse(end+1) = TempData.Data.Prozesse;
            end
        end
    end
    try
        SOC = cell2mat({Testparameter.SOC});
        [x xi] = sort( SOC);
        Testparameter = Testparameter(xi);
        Messdaten = Messdaten(xi);
        Prozesse = Prozesse(xi);
        DRT = DRT(xi);catch
    end
    
    save(['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie '_DRT.mat'],'Testparameter','Messdaten','DRT','Prozesse');
end
% --------------------------------------------------------------------
function MenDRTExportieren_Callback(hObject, eventdata, handles)
% hObject    handle to MenDRTExportieren (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
Data = DRT_GUI;
Data2 = load(['output' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad/' ...
    DRT_GUI.Testparameter.Batterie '_' DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_' [strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m')] 'SOC_Modell.mat']);
Data.Testparameter = rmfield(Data.Testparameter,{'fileName'});


Data.Messdaten = rmfield(Data.Messdaten,{'aktiv','low_Punkte_Weg'});
Data.DRT = Data.DRT.EI_DRT;
Data.DRT.peaks = rmfield(Data.DRT.peaks,{'used','used_parname'});
Data.Prozesse = rmfield(Data.DRT.ProzessFit,{'used','used_parname'});
Data.Prozesse.r = Data.Prozesse.r ./ Data.DRT.Rpol .* Data.DRT.Rpol_EIS;
Data.DRT = rmfield(Data.DRT,{'aktiv','Rpol','Rpol_EIS','ProzessFit','peaks'});


Data = rmfield(Data,{'Fit','Korrigiert'});

if isempty(dir('export'))
    mkdir('export')
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie])
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand])
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad']))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad'])
end
save(['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Zustand '/' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad/' ...
    DRT_GUI.Testparameter.Batterie '_' DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_' [strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m')] 'SOC_DRT.mat'],'Data');


% --------------------------------------------------------------------
function MenAlleSOCDRTPlot_Callback(hObject, eventdata, handles)
% hObject    handle to MenAlleSOCDRTPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DRT_GUI;

figure;
firstline = semilogx(1,1);
new_ax = gca;
SOCs = get(handles.SOCPopup ,'String');
delete(firstline);
for i_Z = 1:numel(SOCs)
    
    if isempty(SOCs{i_Z}) || ~isempty(strfind(SOCs{i_Z},'gray')) || strcmp(SOCs{i_Z},' ')
        continue
    end
    axes(handles.axes3);
    %     [a,b,c,legende] = legend;
    %     legendPosition = get(a,'Location');
    x_label =  get(get(gca,'xlabel'),'string');
    y_label =  get(get(gca,'ylabel'),'string');
    set(handles.SOCPopup,'Value',i_Z)
    SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
    xlimits = xlim;
    ylimits = ylim;
    
    Zustandstring = DRT_GUI.Testparameter.Zustand;
   
    Lines = get(handles.axes3,'Children');
    for i=1:numel(Lines)-2
        newlines = copyobj(Lines(i),new_ax);
        set(newlines(end),'DisplayName',[sprintf('%0.2f%% SOC ',DRT_GUI.Testparameter.SOC) Zustandstring ' Prozess ' char('A'+(numel(Lines)-1-i)-1)]);
    end
    axes(new_ax)
    xlabel(x_label);ylabel(y_label);
    new_xlim = xlim;
    new_ylim = ylim;
    if new_xlim(1)< xlimits(1),xlimits(1) = new_xlim(1);end
    if new_xlim(2)> xlimits(2),xlimits(2) = new_xlim(2);end
    
    if new_ylim(1)< ylimits(1),ylimits(1) = new_ylim(1);end
    if new_ylim(2)> ylimits(2),ylimits(2) = new_ylim(2);end
    if ylimits(1)<0,ylimits(1)=0;end
    
    %xlim(xlimits)
    %ylim(ylimits)
    
end
grid on;
axes(handles.axes3);
% legend(legende,'Location',legendPosition);
axes(new_ax);


% --------------------------------------------------------------------
function MenAlleSOCEisPlot_Callback(hObject, eventdata, handles)
% hObject    handle to MenAlleSOCEisPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DRT_GUI;

cmap=colormap(jet(100));

figure;

firstline = plot(1,1);
grid on;axis square; axis equal; set(gca,'ydir', 'reverse');

new_ax = gca;
SOCs = get(handles.SOCPopup ,'String');
set(handles.SOCPopup,'Value',2)
SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
min_SOC = DRT_GUI.Testparameter.SOC;
set(handles.SOCPopup,'Value',numel(SOCs))
SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
max_SOC = DRT_GUI.Testparameter.SOC;
delete(firstline);
for i_Z = 1:numel(SOCs)
    
    if isempty(SOCs{i_Z}) || ~isempty(strfind(SOCs{i_Z},'gray')) || strcmp(SOCs{i_Z},' ')
        continue
    end
    axes(handles.axes1);
    %     [a,b,c,legende] = legend;
    %     legendPosition = get(a,'Location');
    x_label =  get(get(gca,'xlabel'),'string');
    y_label =  get(get(gca,'ylabel'),'string');
    set(handles.SOCPopup,'Value',i_Z)
    SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
    xlimits = xlim;
    ylimits = ylim;
   
        Zustandstring = DRT_GUI.Testparameter.Zustand;
    
    Lines = get(handles.axes1,'Children');
    newlines = copyobj(Lines(2),new_ax);
    FarbenIndex=round((DRT_GUI.Testparameter.SOC-min_SOC)*99/(max_SOC-min_SOC))+1;
    counter = 0;
    while FarbenIndex == -Inf && counter < 100000
        counter = counter +1;
        FarbenIndex=round((DRT_GUI.Testparameter.SOC-min_SOC)*99/(max_SOC-min_SOC))+1;
    end
    
    set(newlines(end),'DisplayName',[sprintf('%0.2f%% SOC %0.2f°C ',DRT_GUI.Testparameter.SOC,DRT_GUI.Testparameter.Temperatur) Zustandstring ],'Color',cmap(FarbenIndex,:),'LineStyle','-','Marker','none');
    
    axes(new_ax)
    xlabel(x_label);ylabel(y_label);
    new_xlim = xlim;
    new_ylim = ylim;
    if new_xlim(1)< xlimits(1),xlimits(1) = new_xlim(1);end
    if new_xlim(2)> xlimits(2),xlimits(2) = new_xlim(2);end
    
    if new_ylim(1)< ylimits(1),ylimits(1) = new_ylim(1);end
    if new_ylim(2)> ylimits(2),ylimits(2) = new_ylim(2);end
    if ylimits(1)<0,ylimits(1)=0;end
    
    %xlim(xlimits)
    %ylim(ylimits)
    
end
grid on;
colorbar
caxis([min_SOC,max_SOC*1.001]);

axes(handles.axes1);
% legend(legende,'Location',legendPosition);
axes(new_ax);


% --------------------------------------------------------------------
function MenAlleZustaendeFitten_Callback(hObject, eventdata, handles)
% hObject    handle to MenAlleZustaendeFitten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;

choice = questdlg('Vorwärts oder Rückwärts?', ...
	'Dessert Menu', ...
	'Vorwärts','Rückwärts','No thank you','Vorwärts');
if isempty(choice),return;end
HFchoice = questdlg('Jedes Mal HF-Fit vorher machen?', ...
	'Dessert Menu', ...
	'HF-Fit','No-HF-Fit','HF-Fit');
if isempty(HFchoice),return;end
ContChoice = questdlg('Mit Continuous Process Fitting?', ...
	'Dessert Menu', ...
	'Cont. Proc.','No Cont. Proc.','Cont. Proc.');
if isempty(ContChoice),return,end
CopyButton_Callback(handles.CopyButton,eventdata,handles)
Zustaende = get(handles.ZustandPopup ,'String');
switch choice
    case 'Vorwärts'
        Zustandsliste = get(handles.ZustandPopup,'Value')+1:numel(Zustaende);
    case 'Rückwärts'
        Zustandsliste = get(handles.ZustandPopup,'Value')-1:-1:2;
end
for i_Z = Zustandsliste
    
    if isempty(Zustaende{i_Z}) || ~isempty(strfind(Zustaende{i_Z},'gray'))
        continue
    end
    set(handles.ZustandPopup,'Value',i_Z)
    ZustandPopup_Callback(handles.ZustandPopup,eventdata,handles)
    PasteButton_Callback(handles.PasteButton,eventdata,handles)
% % % % % %     set(handles.cont_process_checkbox,'value',0)
% % % % % %     cont_process_checkbox_Callback(handles.cont_process_checkbox,eventdata,handles)
% % % % % %     if strcmp(HFchoice,'HF-Fit')
% % % % % %         InitHF_FittButton_Callback(handles.InitHF_FittButton,eventdata,handles)
% % % % % %     else
% % % % % %         FitButton_Callback(handles.FitButton,eventdata,handles)
% % % % % %     end
% % % % % %     set(handles.cont_process_checkbox,'value',1)
% % % % % %     cont_process_checkbox_Callback(handles.cont_process_checkbox,eventdata,handles)
% % % % % %     DRTButton_Callback(handles.DRTButton,eventdata,handles)
% % % % % %     SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)
% % % % % %     if get(handles.GueltigeMessungCheck,'value')
% % % % % %         CopyButton_Callback(handles.CopyButton,eventdata,handles)
% % % % % %     end
% % % % % %     set(handles.cont_process_checkbox,'value',0)
% % % % % %     
            cont_process_checkbox_Callback(handles.cont_process_checkbox,eventdata,handles)
            DRTButton_Callback(handles.DRTButton,eventdata,handles)
            Prozesse_fitten_button_Callback(handles.Prozesse_fitten_button,eventdata,handles)
            if strcmp(HFchoice,'HF-Fit')
               InitHF_FittButton_Callback(handles.InitHF_FittButton,eventdata,handles)
            else
               FitButton_Callback(handles.FitButton,eventdata,handles)
            end
            DRT_Prozesse_use_button_Callback(handles.DRT_Prozesse_use_button,eventdata,handles)
            DRTButton_Callback(handles.DRTButton,eventdata,handles)
            Prozesse_fitten_button_Callback(handles.Prozesse_fitten_button,eventdata,handles)
            DRT_Prozesse_use_button_Callback(handles.DRT_Prozesse_use_button,eventdata,handles)
            FitButton_Callback(handles.FitButton,eventdata,handles)
            if strcmp(ContChoice,'Cont. Proc.')
                set(handles.cont_process_checkbox,'value',1)
                cont_process_checkbox_Callback(handles.cont_process_checkbox,eventdata,handles)
                DRTButton_Callback(handles.DRTButton,eventdata,handles)
            else
               DRTButton_Callback(handles.DRTButton,eventdata,handles)
                Prozesse_fitten_button_Callback(handles.Prozesse_fitten_button,eventdata,handles)
                DRT_Prozesse_use_button_Callback(handles.DRT_Prozesse_use_button,eventdata,handles)
                FitButton_Callback(handles.FitButton,eventdata,handles)
               set(handles.GueltigeMessungCheck,'value',1)
               GueltigeMessungCheck_Callback(handles.GueltigeMessungCheck,eventdata,handles)
            end
            SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)
            if get(handles.GueltigeMessungCheck,'value') | ~strcmp(ContChoice,'Cont. Proc.')
                CopyButton_Callback(handles.CopyButton,eventdata,handles)
            end
    
    
end


% --------------------------------------------------------------------
function MenAlleSOCDRTFitten_Callback(hObject, eventdata, handles)
% hObject    handle to MenAlleSOCDRTFitten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;



CopyButton_Callback(handles.CopyButton,eventdata,handles)
SOCs = get(handles.SOCPopup ,'String');
% Construct a questdlg with three options
choice = questdlg('Vorwärts oder Rückwärts?', ...
	'Dessert Menu', ...
	'Vorwärts','Rückwärts','No thank you','Vorwärts');
ContChoice = questdlg('Mit Continuous Process Fitting?', ...
	'Dessert Menu', ...
	'Cont. Proc.','No Cont. Proc.','Cont. Proc.');
HFchoice = questdlg('Jedes Mal HF-Fit vorher machen?', ...
	'Dessert Menu', ...
	'HF-Fit','No-HF-Fit','HF-Fit');
% Handle response
switch choice
    case 'Vorwärts'
        for i_SOC = get(handles.SOCPopup,'Value')+1:numel(SOCs)

            if isempty(SOCs{i_SOC}) || ~isempty(strfind(SOCs{i_SOC},'gray'))
                continue
            end
            set(handles.SOCPopup,'Value',i_SOC)
            SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
            PasteButton_Callback(handles.PasteButton,eventdata,handles)
            set(handles.cont_process_checkbox,'value',0)
            cont_process_checkbox_Callback(handles.cont_process_checkbox,eventdata,handles)
            DRTButton_Callback(handles.DRTButton,eventdata,handles)
            Prozesse_fitten_button_Callback(handles.Prozesse_fitten_button,eventdata,handles)
            if strcmp(HFchoice,'HF-Fit')
               InitHF_FittButton_Callback(handles.InitHF_FittButton,eventdata,handles)
            else
               FitButton_Callback(handles.FitButton,eventdata,handles)
            end
            DRT_Prozesse_use_button_Callback(handles.DRT_Prozesse_use_button,eventdata,handles)
            
            DRTButton_Callback(handles.DRTButton,eventdata,handles)
            Prozesse_fitten_button_Callback(handles.Prozesse_fitten_button,eventdata,handles)
            DRT_Prozesse_use_button_Callback(handles.DRT_Prozesse_use_button,eventdata,handles)
            FitButton_Callback(handles.FitButton,eventdata,handles)
            if strcmp(ContChoice,'Cont. Proc.')
                set(handles.cont_process_checkbox,'value',1)
                cont_process_checkbox_Callback(handles.cont_process_checkbox,eventdata,handles)
                DRTButton_Callback(handles.DRTButton,eventdata,handles)
            else
               DRTButton_Callback(handles.DRTButton,eventdata,handles)
                Prozesse_fitten_button_Callback(handles.Prozesse_fitten_button,eventdata,handles)
                DRT_Prozesse_use_button_Callback(handles.DRT_Prozesse_use_button,eventdata,handles)
                FitButton_Callback(handles.FitButton,eventdata,handles)
               set(handles.GueltigeMessungCheck,'value',1)
               GueltigeMessungCheck_Callback(handles.GueltigeMessungCheck,eventdata,handles)
            end
            SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)
            if get(handles.GueltigeMessungCheck,'value') | ~strcmp(ContChoice,'Cont. Proc.')
                CopyButton_Callback(handles.CopyButton,eventdata,handles)
            end



        end
    case 'Rückwärts'
        for i_SOC = get(handles.SOCPopup,'Value')+-1:-1:2

            if isempty(SOCs{i_SOC}) || ~isempty(strfind(SOCs{i_SOC},'gray'))
                continue
            end
            set(handles.SOCPopup,'Value',i_SOC)
            SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
            PasteButton_Callback(handles.PasteButton,eventdata,handles)
            set(handles.cont_process_checkbox,'value',0)
            cont_process_checkbox_Callback(handles.cont_process_checkbox,eventdata,handles)
            DRTButton_Callback(handles.DRTButton,eventdata,handles)
            Prozesse_fitten_button_Callback(handles.Prozesse_fitten_button,eventdata,handles)
            if strcmp(HFchoice,'HF-Fit')
                InitHF_FittButton_Callback(handles.InitHF_FittButton,eventdata,handles)
            else
                FitButton_Callback(handles.FitButton,eventdata,handles)
            end
            DRT_Prozesse_use_button_Callback(handles.DRT_Prozesse_use_button,eventdata,handles)
            if strcmp(ContChoice,'Cont. Proc.')
                set(handles.cont_process_checkbox,'value',1)
                cont_process_checkbox_Callback(handles.cont_process_checkbox,eventdata,handles)
                DRTButton_Callback(handles.DRTButton,eventdata,handles)
            else
               DRTButton_Callback(handles.DRTButton,eventdata,handles)
                Prozesse_fitten_button_Callback(handles.Prozesse_fitten_button,eventdata,handles)
                DRT_Prozesse_use_button_Callback(handles.DRT_Prozesse_use_button,eventdata,handles)
                FitButton_Callback(handles.FitButton,eventdata,handles)
               set(handles.GueltigeMessungCheck,'value',1)
               GueltigeMessungCheck_Callback(handles.GueltigeMessungCheck,eventdata,handles)
            end
            
            SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)
            if get(handles.GueltigeMessungCheck,'value')| ~strcmp(ContChoice,'Cont. Proc.')
                CopyButton_Callback(handles.CopyButton,eventdata,handles)
            end



        end
    case 'No thank you'
        disp('I''ll bring you your check.')
        dessert = 0;

end





% --------------------------------------------------------------------
function MenAlleSOCFitten_Callback(hObject, eventdata, handles)
% hObject    handle to MenAlleSOCDRTFitten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;



CopyButton_Callback(handles.CopyButton,eventdata,handles)
SOCs = get(handles.SOCPopup ,'String');
% Construct a questdlg with three options
choice = questdlg('Vorwärts oder Rückwärts?', ...
	'Dessert Menu', ...
	'Vorwärts','Rückwärts','No thank you','Vorwärts');
HFchoice = questdlg('Jedes Mal HF-Fit vorher machen?', ...
	'Dessert Menu', ...
	'HF-Fit','No-HF-Fit','HF-Fit');
% Handle response
switch choice
    case 'Vorwärts'
        for i_SOC = get(handles.SOCPopup,'Value')+1:numel(SOCs)

            if isempty(SOCs{i_SOC}) || ~isempty(strfind(SOCs{i_SOC},'gray'))
                continue
            end
            set(handles.SOCPopup,'Value',i_SOC)
            SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
            PasteButton_Callback(handles.PasteButton,eventdata,handles)
            set(handles.cont_process_checkbox,'value',0)
            cont_process_checkbox_Callback(handles.cont_process_checkbox,eventdata,handles)
            if strcmp(HFchoice,'HF-Fit')
               InitHF_FittButton_Callback(handles.InitHF_FittButton,eventdata,handles)
            else
                                FitButton_Callback(handles.FitButton,eventdata,handles)

            end
            FitButton_Callback(handles.FitButton,eventdata,handles)
            FitButton_Callback(handles.FitButton,eventdata,handles)
            FitButton_Callback(handles.FitButton,eventdata,handles)


            
            DRTButton_Callback(handles.DRTButton,eventdata,handles)
            Prozesse_fitten_button_Callback(handles.Prozesse_fitten_button, eventdata, handles)

            
            SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)
            if get(handles.GueltigeMessungCheck,'value')
                CopyButton_Callback(handles.CopyButton,eventdata,handles)
            end



        end
    case 'Rückwärts'
        for i_SOC = get(handles.SOCPopup,'Value')+-1:-1:2

            if isempty(SOCs{i_SOC}) || ~isempty(strfind(SOCs{i_SOC},'gray'))
                continue
            end
            set(handles.SOCPopup,'Value',i_SOC)
            SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
            PasteButton_Callback(handles.PasteButton,eventdata,handles)
            set(handles.cont_process_checkbox,'value',0)
            cont_process_checkbox_Callback(handles.cont_process_checkbox,eventdata,handles)
            if strcmp(HFchoice,'HF-Fit')
                InitHF_FittButton_Callback(handles.InitHF_FittButton,eventdata,handles)
            else
                FitButton_Callback(handles.FitButton,eventdata,handles)
            end
            
            FitButton_Callback(handles.FitButton,eventdata,handles)
            
            DRTButton_Callback(handles.DRTButton,eventdata,handles)
            Prozesse_fitten_button_Callback(handles.Prozesse_fitten_button, eventdata, handles)

            
            
            SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)
            if get(handles.GueltigeMessungCheck,'value')
                CopyButton_Callback(handles.CopyButton,eventdata,handles)
            end



        end
    case 'No thank you'
        disp('I''ll bring you your check.')
        dessert = 0;

end

% --------------------------------------------------------------------
function MenAlleZustaendeEISPlot_Callback(hObject, eventdata, handles)
% hObject    handle to MenAlleZustaendeEISPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;

% figure;
% firstline = plot(1,1);
% new_ax = gca;
Zustaende = get(handles.ZustandPopup ,'String');
% delete(firstline);
cmap = colormap(hot(ceil(numel(Zustaende)*1.8)));

Batteriename = get(handles.BatterieNamePopup,'string');
Batteriename = Batteriename{get(handles.BatterieNamePopup,'value')};
if ~isempty(dir(['output/' Batteriename '/Zustandaliases.mat'])) 
    Zustandaliases = load(['output/' Batteriename '/Zustandaliases.mat']);
    Zustandaliases = Zustandaliases.Zustandaliases;
elseif ~isempty(dir(['output/' Batteriename '/Zustandaliases.xlsx'])) 
    [Zustandndata Zustandtext ZustandXLS] = xlsread(['output/' Batteriename '/Zustandaliases.xlsx']);
    for i = 2:size(ZustandXLS,2)
        Zustandaliases{1,i-1}.name=Zustandtext{1,i};
        Zustandaliases{1,i-1}.unit=Zustandtext{2,i};
        Zustandaliases{1,i-1}.value=cell2mat(ZustandXLS(3:end,i));
        Zustandaliases{1,i-1}.Zustands_name=ZustandXLS(3:end,1);
    end
elseif ~isempty(dir(['output/' Batteriename '/Zustandaliases.xls'])) 
    [Zustandndata Zustandtext ZustandXLS] = xlsread(['output/' Batteriename '/Zustandaliases.xlsx']);
    for i = 2:size(ZustandXLS,2)
        Zustandaliases{1,i-1}.name=Zustandtext{1,i};
        Zustandaliases{1,i-1}.unit=Zustandtext{2,i};
        Zustandaliases{1,i-1}.value=cell2mat(ZustandXLS(3:end,i));
        Zustandaliases{1,i-1}.Zustands_name=ZustandXLS(3:end,1);
    end
end

    Zustandsurf.frequenz=[];
    Zustandsurf.Zreal=[];
    Zustandsurf.Zimg=[];
    Zustandsurf.ZrealMF=[];
    Zustandsurf.ZimgMF=[];
    Zustandsurf.aliases={};    
    Zustandsurf.aliasesMF={};    
    
for i_Z = 1:numel(Zustaende)
    
    if isempty(Zustaende{i_Z}) || ~isempty(strfind(Zustaende{i_Z},'gray'))
        continue
    end
    axes(handles.axes1);
    %     [a,b,c,legende] = legend;
    %     legendPosition = get(a,'Location');
    x_label =  get(get(gca,'xlabel'),'string');
    y_label =  get(get(gca,'ylabel'),'string');
    set(handles.ZustandPopup,'Value',i_Z)
    ZustandPopup_Callback(handles.ZustandPopup,'kein_plot',handles)
    xlimits = xlim;
    ylimits = ylim;
    
    if ~isempty(Zustandaliases)
            ZAlias = nan(numel(Zustandaliases),1);
            for i_a = 1:numel(Zustandaliases)
                Zustandsurf.AliasName{i_a}=Zustandaliases{i_a}.name;
                Zustandsurf.AliasUnit{i_a}=Zustandaliases{i_a}.unit;
                
                Z_index = find(strcmp(DRT_GUI.Testparameter.Zustand,Zustandaliases{i_a}.Zustands_name));
                if ~isempty(Z_index),
                    ZAlias(i_a) = Zustandaliases{i_a}.value(Z_index);

                end
                if numel(Zustandsurf.aliases)<i_a
                    Zustandsurf.aliases{i_a}=[];
                end
                Zustandsurf.aliases{i_a} = [Zustandsurf.aliases{i_a}; repmat(ZAlias(i_a),numel(DRT_GUI.Messdaten.frequenz),1)];
                if numel(Zustandsurf.aliasesMF)<i_a
                    Zustandsurf.aliasesMF{i_a}=[];
                end
                Zustandsurf.aliasesMF{i_a} = [Zustandsurf.aliasesMF{i_a}; repmat(ZAlias(i_a),numel(DRT_GUI.Messdaten.frequenz(DRT_GUI.Messdaten.aktiv==1)),1)];
            end
            Zustandsurf.frequenz = [Zustandsurf.frequenz ; reshape(DRT_GUI.Messdaten.frequenz,numel(DRT_GUI.Messdaten.frequenz),1)];
            Zustandsurf.Zreal = [Zustandsurf.Zreal ; reshape(DRT_GUI.Messdaten.Zreal,numel(DRT_GUI.Messdaten.frequenz),1)];
            Zustandsurf.Zimg = [Zustandsurf.Zimg ; reshape(DRT_GUI.Messdaten.Zimg,numel(DRT_GUI.Messdaten.frequenz),1)];
            Zustandsurf.frequenzMF = [Zustandsurf.frequenz ; reshape(DRT_GUI.Messdaten.frequenz(DRT_GUI.Messdaten.aktiv==1),numel(DRT_GUI.Messdaten.frequenz(DRT_GUI.Messdaten.aktiv==1)),1)];
            Zustandsurf.ZrealMF = [Zustandsurf.ZrealMF ; reshape(DRT_GUI.Fit.korrigiert.Zreal,numel(DRT_GUI.Messdaten.frequenz(DRT_GUI.Messdaten.aktiv==1)),1)];
            Zustandsurf.ZimgMF = [Zustandsurf.ZimgMF ; reshape(DRT_GUI.Fit.korrigiert.Zimg,numel(DRT_GUI.Messdaten.frequenz(DRT_GUI.Messdaten.aktiv==1)),1)];
    end
    
    
    
        Zustandstring = DRT_GUI.Testparameter.Zustand;
    
    
%     Lines = get(handles.axes1,'Children');
%         newlines = copyobj(Lines(1),new_ax);
%     set(newlines(end),'DisplayName',[Zustandstring],'linestyle','-','marker','none','color',cmap(i_Z,:),'linewidth',2);
%     axes(new_ax)
%     
%     set(gca,'Fontname','Arial','Fontsize',16)
%     ylabel('Re\{Z\} in \Omega','Fontname','arial','fontsize',15)
%     xlabel('Im\{Z\} in \Omega','Fontname','arial','fontsize',15)
%     new_xlim = xlim;
%     new_ylim = ylim;
%     if new_xlim(1)< xlimits(1),xlimits(1) = new_xlim(1);end
%     if new_xlim(2)> xlimits(2),xlimits(2) = new_xlim(2);end
%     
%     if new_ylim(1)< ylimits(1),ylimits(1) = new_ylim(1);end
%     if new_ylim(2)> ylimits(2),ylimits(2) = new_ylim(2);end
%     if ylimits(1)<0,ylimits(1)=0;end
    
    %xlim(xlimits)
    %ylim(ylimits)
    
end
%             set(gca,'Fontname','Arial','Fontsize',16)
%             ylabel('Re\{Z\} in \Omega','Fontname','arial','fontsize',15)
%             xlabel('Im\{Z\} in \Omega','Fontname','arial','fontsize',15)
%             set(gca,'ydir', 'reverse'); %axis square;
%             axis equal;
%             grid on;
%             
% grid on;
% axes(handles.axes3);
% % legend(legende,'Location',legendPosition);
% axes(new_ax);
if isempty(dir('export'))
    mkdir('export')
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie])
end
%     achsen = get(gcf,'Children');
%     achsen = achsen(isgraphics(achsen,'axes'));
%     for j = 1:numel(achsen)
%         set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
%         set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
%         set(get(achsen(j),'zlabel'),'Fontname','arial','fontsize',15);
%         set(achsen(j),'Fontname','Arial','Fontsize',16)
%         linien = get(achsen(j),'Children');
%         linien = linien(isgraphics(linien,'line'));
%         for li = 1:numel(linien),
%            if isgraphics(linien(li),'line') 
%                set(linien(li),'linewidth',2)
%            end
%         end
%     end
%     title('')
%     print(gcf,['export' '/' FittingGUI.Testparameter.Batterie '/' FittingGUI.Testparameter.Batterie ' ' num2str(FittingGUI.Testparameter.Temperatur) '°C ' num2str(round(FittingGUI.Testparameter.SOC/5)*5) '% SOC EISPlot2D.png'], '-dpng', '-r900');
%     title([FittingGUI.Testparameter.Batterie ' ' num2str(FittingGUI.Testparameter.Temperatur) '°C ' num2str(round(FittingGUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
%     saveas(gcf,['export' '/' FittingGUI.Testparameter.Batterie '/' FittingGUI.Testparameter.Batterie ' ' num2str(FittingGUI.Testparameter.Temperatur) '°C ' num2str(round(FittingGUI.Testparameter.SOC/5)*5) '% SOC EISPlot2D.fig'])
%     

for i = 1:numel(Zustandaliases)
    index = find(~isnan(Zustandsurf.aliases{i}));
    z_values=unique(Zustandsurf.aliases{i}(index));
    cmap=hot(ceil(numel(z_values)*1.8));
    figure;
    for z_index = 1:numel(z_values) 
        indices = find(Zustandsurf.aliases{i}==z_values(z_index));
        plot3(Zustandsurf.Zreal(indices),repmat(z_values(z_index),size(Zustandsurf.Zreal(indices))),Zustandsurf.Zimg(indices),'color',cmap(z_index,:),'Displayname',[num2str(z_values(z_index)) ' ' Zustandsurf.AliasUnit{i} ' ' Zustandsurf.AliasName{i}],'LineWidth',3)
        hold on
        xlabel('Zreal in \Omega')
        if ~isempty(Zustandsurf.AliasUnit{i})
            ylabel([Zustandsurf.AliasName{i} ' in ' Zustandsurf.AliasUnit{i}])
        else
            ylabel(Zustandsurf.AliasName{i})
        end
        zlabel('Zimg in \Omega')

    end
           set(gca,'Zdir','reverse')
    aspectratio = daspect;
    aspectratio([1 3]) = max(aspectratio([1 3]));
    daspect(gca,aspectratio);
    grid on
    achsen = get(gcf,'Children');
    achsen = achsen(isgraphics(achsen,'axes'));
    for j = 1:numel(achsen)
        set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'zlabel'),'Fontname','arial','fontsize',15);
        set(achsen(j),'Fontname','Arial','Fontsize',16)
        linien = get(achsen(j),'Children');
        linien = linien(isgraphics(linien,'line'));
        for li = 1:numel(linien),
           if isgraphics(linien(li),'line') 
               set(linien(li),'linewidth',2)
           end
        end
    end
    title('')
    print(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' EISPlot3.png'], '-dpng', '-r900');
    title([DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
    saveas(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' EISPlot3.fig'])
    
    figure;
    for z_index = 1:numel(z_values) 
        indices = find(Zustandsurf.aliases{i}==z_values(z_index));
        plot(Zustandsurf.Zreal(indices),Zustandsurf.Zimg(indices),'color',cmap(z_index,:),'Displayname',[num2str(z_values(z_index)) ' ' Zustandsurf.AliasUnit{i} ' ' Zustandsurf.AliasName{i}],'LineWidth',3)
        hold on
        xlabel('Zreal in \Omega')
        ylabel('Zimg in \Omega')

    end
           set(gca,'Ydir','reverse')
    aspectratio = daspect;
    aspectratio([1 2]) = max(aspectratio([1 2]));
    daspect(gca,aspectratio);
    grid on
    achsen = get(gcf,'Children');
    achsen = achsen(isgraphics(achsen,'axes'));
    for j = 1:numel(achsen)
        set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
        set(achsen(j),'Fontname','Arial','Fontsize',16)
        linien = get(achsen(j),'Children');
        linien = linien(isgraphics(linien,'line'));
        for li = 1:numel(linien),
           if isgraphics(linien(li),'line') 
               set(linien(li),'linewidth',2)
           end
        end
    end
    lhandle=legend('show','Location','SouthEast');
    LEG = findobj(lhandle,'type','text');
    set(LEG,'FontSize',9)
    title('')
    print(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' EISPlot2D.png'], '-dpng', '-r900');
    title([DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
    saveas(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' EISPlot2D.fig'])
    
     
    figure;
    for z_index = 1:numel(z_values) 
        indices = find(Zustandsurf.aliasesMF{i}==z_values(z_index));
        plot3(Zustandsurf.ZrealMF(indices),repmat(z_values(z_index),size(Zustandsurf.ZrealMF(indices))),Zustandsurf.ZimgMF(indices),'color',cmap(z_index,:),'Displayname',[num2str(z_values(z_index)) ' ' Zustandsurf.AliasUnit{i} ' ' Zustandsurf.AliasName{i}],'LineWidth',3)
        hold on
        xlabel('ZrealMF in \Omega')
        if ~isempty(Zustandsurf.AliasUnit{i})
            ylabel([Zustandsurf.AliasName{i} ' in ' Zustandsurf.AliasUnit{i}])
        else
            ylabel(Zustandsurf.AliasName{i})
        end
        zlabel('ZimgMF in \Omega')

    end
           set(gca,'Zdir','reverse')
    aspectratio = daspect;
    aspectratio([1 3]) = max(aspectratio([1 3]));
    daspect(gca,aspectratio);
         grid on
     achsen = get(gcf,'Children');
    achsen = achsen(isgraphics(achsen,'axes'));
    for j = 1:numel(achsen)
        set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'zlabel'),'Fontname','arial','fontsize',15);
        set(achsen(j),'Fontname','Arial','Fontsize',16)
        linien = get(achsen(j),'Children');
        linien = linien(isgraphics(linien,'line'));
        for li = 1:numel(linien),
           if isgraphics(linien(li),'line') 
               set(linien(li),'linewidth',2)
           end
        end
    end
    title('')
    print(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' EISPlot3MF.png'], '-dpng', '-r900');
    title([DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
    saveas(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' EISPlot3MF.fig'])
        
    figure;
    for z_index = 1:numel(z_values) 
        indices = find(Zustandsurf.aliasesMF{i}==z_values(z_index));
        plot(Zustandsurf.ZrealMF(indices),Zustandsurf.ZimgMF(indices),'color',cmap(z_index,:),'Displayname',[num2str(z_values(z_index)) ' ' Zustandsurf.AliasUnit{i} ' ' Zustandsurf.AliasName{i}],'LineWidth',3)
        hold on
        xlabel('ZrealMF in \Omega')
        ylabel('ZimgMF in \Omega')

    end
           set(gca,'Ydir','reverse')
    aspectratio = daspect;
    aspectratio([1 2]) = max(aspectratio([1 2]));
    daspect(gca,aspectratio);
         grid on
     achsen = get(gcf,'Children');
    achsen = achsen(isgraphics(achsen,'axes'));
    for j = 1:numel(achsen)
        set(get(achsen(j),'xlabel'),'Fontname','arial','fontsize',15);
        set(get(achsen(j),'ylabel'),'Fontname','arial','fontsize',15);
        set(achsen(j),'Fontname','Arial','Fontsize',16)
        linien = get(achsen(j),'Children');
        linien = linien(isgraphics(linien,'line'));
        for li = 1:numel(linien),
           if isgraphics(linien(li),'line') 
               set(linien(li),'linewidth',2)
           end
        end
    end
    lhandle=legend('show','Location','BestOutside');
    LEG = findobj(lhandle,'type','text');
    set(LEG,'FontSize',9)
    title('')
    print(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' EISPlot2DMF.png'], '-dpng', '-r900');
    title([DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC'],'Interpreter','none')
    saveas(gcf,['export' '/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie ' ' num2str(DRT_GUI.Testparameter.Temperatur) '°C ' num2str(round(DRT_GUI.Testparameter.SOC/5)*5) '% SOC ' Zustandsurf.AliasName{i} ' EISPlot2DMF.fig'])
    

end

% --- Executes on button press in PlotElementsCheckbox.
function PlotElementsCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PlotElementsCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PlotElementsCheckbox


% --- Executes on button press in HF_Fit_Button.
function HF_Fit_Button_Callback(hObject, eventdata, handles)
% hObject    handle to HF_Fit_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;

if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Messdaten')))
    return
end



formula = DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell;
formula_HF = DRT_GUI.Fit.aktuell_Modell.Rechnen_Modell_HF;
if  isempty(cell2mat(strfind(fieldnames(DRT_GUI.Messdaten),'relax_fft'))) || isempty(DRT_GUI.Messdaten.relax_fft)
    m_w = DRT_GUI.Messdaten.omega(DRT_GUI.Messdaten.aktiv==1) ;
    m_real = DRT_GUI.Messdaten.Zreal(DRT_GUI.Messdaten.aktiv==1);
    m_imag = DRT_GUI.Messdaten.Zimg(DRT_GUI.Messdaten.aktiv==1);
else
    m_w = [DRT_GUI.Messdaten.omega(DRT_GUI.Messdaten.aktiv==1) ; DRT_GUI.Messdaten.relax_fft.omega(DRT_GUI.Messdaten.relax_fft.aktiv==1)] ;
    m_real = [DRT_GUI.Messdaten.Zreal(DRT_GUI.Messdaten.aktiv==1); DRT_GUI.Messdaten.relax_fft.Zreal(DRT_GUI.Messdaten.relax_fft.aktiv==1)+DRT_GUI.Messdaten.relax_fft.Zreal_korrektur];
    m_imag = [DRT_GUI.Messdaten.Zimg(DRT_GUI.Messdaten.aktiv==1); DRT_GUI.Messdaten.relax_fft.Zimg(DRT_GUI.Messdaten.relax_fft.aktiv==1)];
end
TableCell = get(handles.ParamTable,'Data');
TableCell = cell2struct(TableCell',{'Name','Fix','Value','Min','Max','Lim'});


% die initialisierte Werte aus Feld bekommen
DRT_GUI.Fit.ParFix = zeros(size(DRT_GUI.Fit.Parameter));
for Par_init_i = 1:length(DRT_GUI.Fit.Parameter)
    
    
    if ~isempty(TableCell(Par_init_i).Value)
        DRT_GUI.Fit.Parameter(Par_init_i) = TableCell(Par_init_i).Value;
    else
        DRT_GUI.Fit.Parameter(Par_init_i) = 0;
        TableCell(Par_init_i).Value = 0;
    end
    
    if ~isempty(TableCell(Par_init_i).Min) && ~TableCell(Par_init_i).Fix
        p_min(Par_init_i)= TableCell(Par_init_i).Min;
    elseif TableCell(Par_init_i).Fix
        DRT_GUI.Fit.ParFix(Par_init_i) = 1 ;
        p_min(Par_init_i) = TableCell(Par_init_i).Value;
    else
        p_min(Par_init_i) = 0;
        TableCell(Par_init_i).Min = 0 ;
    end
    if ~isempty(TableCell(Par_init_i).Min)
        DRT_GUI.Fit.Parameter_min(Par_init_i) = TableCell(Par_init_i).Min;
    else
        DRT_GUI.Fit.Parameter_min(Par_init_i) = 0;
    end
    if ~isempty(TableCell(Par_init_i).Max) && ~TableCell(Par_init_i).Fix
        p_max(Par_init_i)= TableCell(Par_init_i).Max;
    elseif TableCell(Par_init_i).Fix
        p_max(Par_init_i) = TableCell(Par_init_i).Value;
    else
        p_max(Par_init_i) = inf;
        TableCell(Par_init_i).Max = Inf;
    end
    if ~isempty(TableCell(Par_init_i).Max)
        DRT_GUI.Fit.Parameter_max(Par_init_i) = TableCell(Par_init_i).Max;
    else
        DRT_GUI.Fit.Parameter_max(Par_init_i) = inf;
    end
end

p_init = DRT_GUI.Fit.Parameter;
if strcmp(get(handles.MetaFitButton,'String'),'Stop') || get(handles.cont_process_checkbox,'Value')
    options = optimset('MaxIter',5000,'MaxFunEvals',10000,'TolX',1e-8,'TolFun',1e-8);
else
    options = optimset('MaxIter',20000,'MaxFunEvals',20000,'TolX',1e-8,'TolFun',1e-8);
end
p_min_model = cell2mat(DRT_GUI.Fit.aktuell_Modell.ModellCell{5});
p_max_model = cell2mat(DRT_GUI.Fit.aktuell_Modell.ModellCell{6});
set(handles.ParamTable,'Data',struct2cell(TableCell)')
[p_best,fval,exitflag,output]=function_fit_easyfit2(m_w,[m_real, m_imag],p_init,@function_model_all_types2, p_min, p_max ,options, formula);
index_min = find((p_best<=p_min*1.001 & p_min~=p_max & p_min~=p_min_model & ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Rser') & ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'C')& ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Cser')& ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Kskin')& ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Lser')));
index_max = find((p_best>=p_max*0.999 & p_min~=p_max & p_max~=p_max_model & ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Rser') & ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'C')& ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Cser')& ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Kskin')& ~strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),'Lser')));

DRT_GUI.Fit.Parameter = p_best;
DRT_GUI.Fit.Limit_Reached.index_min = index_min;
DRT_GUI.Fit.Limit_Reached.index_max = index_max;

% die Fittwerte(p-best) in Feld zeigen
for P_i = 1:length(p_best)
    
    TableCell(P_i).Value = p_best(P_i);
    if ~isempty(find([index_min index_max]==P_i,1,'first'))
        TableCell(P_i).Lim = true;
    else
        TableCell(P_i).Lim = false;
    end
end
TableCell = struct2cell(TableCell)';
set(handles.ParamTable,'Data',TableCell)


% --- Executes on button press in fig5_export_button.
function fig5_export_button_Callback(hObject, eventdata, handles)
% hObject    handle to fig5_export_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
axes(handles.axes5);
[a,b,c,legende] = legend;
legendPosition = get(a,'Location');
AltePosition = get(handles.axes5,'Position');
AltePosition(1:2)=5;
newfig=figure('UnitS','characters','Position',AltePosition+10);
neueAchse=copyobj([a,handles.axes5],newfig);
set(neueAchse(2),'Position',AltePosition)
if isempty(dir('export'))
    mkdir('export')
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie])
end
savefig(['export/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie '_Nyquist_HF_' ...
    DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_'...
    strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m') 'SOC'...
    '.fig'])


% --- Executes on button press in fig6_export_button.
function fig6_export_button_Callback(hObject, eventdata, handles)
% hObject    handle to fig6_export_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
axes(handles.axes6);
[a,b,c,legende] = legend;
legendPosition = get(a,'Location');
AltePosition = get(handles.axes6,'Position');
AltePosition(1:2)=5;
newfig=figure('UnitS','characters','Position',AltePosition+10);
neueAchse=copyobj([a,handles.axes6],newfig);
set(neueAchse(2),'Position',AltePosition)
if isempty(dir('export'))
    mkdir('export')
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie])
end
savefig(['export/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie '_Nyquist_LF_' ...
    DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_'...
    strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m') 'SOC'...
    '.fig'])


% --- Executes on selection change in ZarcHNPopup.
function ZarcHNPopup_Callback(hObject, eventdata, handles)
% hObject    handle to ZarcHNPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ZarcHNPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ZarcHNPopup
global DRT_Config
DRT_Config.ZarcHN = get(hObject,'Value');


% --- Executes during object creation, after setting all properties.
function ZarcHNPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZarcHNPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global DRT_Config
if isempty(DRT_Config)
    config
end
if ~sum(ismember(fieldnames(DRT_Config),'ZarcHN'))
    DRT_Config.ZarcHN=5;
end
set(hObject,'value',DRT_Config.ZarcHN)



function [ DRT_out ] = Calc_HN_DRT( r0,tau0,phi0,Tau_out )
global DRT_GUI;
global DRT_Config;
Schwingfaktor = DRT_Config.Schwingfaktor; % ist hoffentlich immer 1
InterpolationsFaktor = 3;
FilterFaktor_ext = DRT_Config.FilterFaktor_ext;
FilterFaktor_int = FilterFaktor_ext / InterpolationsFaktor * Schwingfaktor;
 %   w_DRT = 10.^(-15:0.1:15)/tau0; 
    w_DRT = 10.^(log10(min(DRT_GUI.DRT.EI_DRT.omega)):0.1:log10(max(DRT_GUI.DRT.EI_DRT.omega))); 
    [freq_int,HN_imag_int]=interpolate_signal(InterpolationsFaktor,imag(r0./((1+1i*w_DRT'*tau0).^phi0)),w_DRT'/2/pi);
    [x_int,DRT_HN]=makeDRT(HN_imag_int',freq_int',true,FilterFaktor_int);
%     [x_int,DRT_HN]=makeDRT(imag(r0./((1+1i*FittingGUI.DRT.EI_DRT.omega'*tau0).^phi0)),FittingGUI.DRT.EI_DRT.frequenz',true,FilterFaktor_int);
    DRT_HN=real(DRT_HN)/Schwingfaktor;


% [C,ia,ib]=intersect(FittingGUI.DRT.EI_DRT.tau,Tau_out);
% DRT_HN=DRT_HN(ia);
DRT_out=interp1(log(freq_int),DRT_HN,log(1./Tau_out/(2*pi)));
% DRT_HN=DRT_HN(FittingGUI.DRT.EI_DRT.aktiv');

function [ DRT_out ] = Calc_PorEl_DRT( r0,tau0,rmp0_durch_r0,Tau_out )
global DRT_GUI;
global DRT_Config;
Schwingfaktor = DRT_Config.Schwingfaktor; % ist hoffentlich immer 1
InterpolationsFaktor = 3;
FilterFaktor_ext = DRT_Config.FilterFaktor_ext;
FilterFaktor_int = FilterFaktor_ext / InterpolationsFaktor * Schwingfaktor;
rmp0 = rmp0_durch_r0 *r0;
    w_DRT = 10.^(log10(min(DRT_GUI.DRT.EI_DRT.omega)):0.1:log10(max(DRT_GUI.DRT.EI_DRT.omega))); 
    [freq_int,HN_imag_int]=interpolate_signal(InterpolationsFaktor,imag((rmp0.*(r0./(1+1i.*w_DRT.*tau0))).^0.5...
    .*coth((rmp0./(r0./(1+1i.*w_DRT.*tau0))).^0.5)),w_DRT'/2/pi);
    [~,DRT_PorEl]=makeDRT(HN_imag_int',freq_int',true,FilterFaktor_int);
    DRT_PorEl=real(DRT_PorEl)/Schwingfaktor;
DRT_out=interp1(log(freq_int),DRT_PorEl,log(1./Tau_out/(2*pi)));

function [DRT_out] = Calc_Zarc_DRT(r0,tau0,phi0,tau)
DRT_out = r0./(2.*pi).*(sin((1-phi0).*pi))./(cosh(phi0.*log(tau./tau0))-cos((1-phi0).*pi));

function [ DRT_out ] = Calc_Model_DRT( z_model,p,Tau_out )
global DRT_GUI;
global DRT_Config;
Schwingfaktor = DRT_Config.Schwingfaktor; % ist hoffentlich immer 1
InterpolationsFaktor = 3;
FilterFaktor_ext = DRT_Config.FilterFaktor_ext;
FilterFaktor_int = FilterFaktor_ext / InterpolationsFaktor * Schwingfaktor;
    w_DRT = 10.^(log10(min(DRT_GUI.DRT.EI_DRT.omega)):0.1:log10(max(DRT_GUI.DRT.EI_DRT.omega))); 
    w = w_DRT; 
    [freq_int,model_imag_int]=interpolate_signal(InterpolationsFaktor,imag(eval(z_model)),w_DRT'/2/pi);
    [~,DRT_Model]=makeDRT(model_imag_int',freq_int',true,FilterFaktor_int);
    DRT_Model=real(DRT_Model)/Schwingfaktor;
DRT_out=interp1(log(freq_int),DRT_Model,log(1./Tau_out/(2*pi)));


function z=function_model_all_types2(p,w,formula)
z_comp = eval(formula);
z=[real(z_comp),imag(z_comp)];
% --------------------------------------------------------------------
function MenRelaxFFTbeiAllenEntfernen_Callback(hObject, eventdata, handles)
% hObject    handle to MenRelaxFFTbeiAllenEntfernen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.PunkteWegnehmenTextBox,'string','')

choice = questdlg('Dieses Script entfernt die berechnete RelaxFFT bei allen SOCs und allen Temperaturen. Fortfahren?', ...
    'Script', ...
    'Abbrechen','Alle Speichern','Abbrechen');
% Handle response
if isempty(choice), return,end
switch choice
    case 'Abbrechen'
        return
end
TList = get(handles.TemperaturPopup,'String');
for k = 2:numel(TList)
    set(handles.TemperaturPopup,'Value',k)
    TemperaturPopup_Callback(handles.TemperaturPopup,eventdata,handles)
    SOCList = get(handles.SOCPopup,'String');
    for i = 2:numel(SOCList)
        set(handles.SOCPopup,'Value',i)
        SOCPopup_Callback(handles.SOCPopup,eventdata,handles)
        MenRelaxFFTentfernen_Callback(hObject, eventdata, handles)
        SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)
    end
end


% --------------------------------------------------------------------
function MenRelaxFFT_Callback(hObject, eventdata, handles)
% hObject    handle to MenRelaxFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MenRelaxFFTentfernen_Callback(hObject, eventdata, handles)
% hObject    handle to MenRelaxFFTentfernen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI

if ismember('relax_fft',fieldnames(DRT_GUI.Messdaten))
    DRT_GUI.Messdaten = rmfield(DRT_GUI.Messdaten,'relax_fft');
    Alles_Laden(handles,eventdata)
    set(handles.PunkteWegnehmenTextBox,'string','')
    PunkteWegnehmenButton_Callback(handles.PunkteWegnehmenButton, eventdata, handles)
end


% --------------------------------------------------------------------
function menFitFit_Callback(hObject, eventdata, handles)
% hObject    handle to menFitFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~ , FitFitHandles] = FitFitGUI;
FitFitGUI('LoadDataButton_Callback',FitFitHandles.LoadDataButton, eventdata, FitFitHandles)

% --------------------------------------------------------------------
function menFittingResults_Callback(hObject, eventdata, handles)
% hObject    handle to menFittingResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
model_explorer_button_Callback(handles.model_explorer_button, eventdata, handles)


% --------------------------------------------------------------------
function menDatenEinlesen_Callback(hObject, eventdata, handles)
% hObject    handle to menDatenEinlesen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EinleseButton_Callback(handles.EinleseButton, eventdata, handles)

% --- Executes on button press in ZeitbereichsFittingButton.
function ZeitbereichsFittingButton_Callback(hObject, eventdata, handles)
% hObject    handle to ZeitbereichsFittingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Fit')))
    return
end
if ~sum(ismember(fieldnames(DRT_GUI.Fit),'Implementierung')) || isempty(DRT_GUI.Fit.Implementierung) || ~sum(ismember(fieldnames(DRT_GUI.Fit.Implementierung),'Table')) || isempty(DRT_GUI.Fit.Implementierung.Table) || size(DRT_GUI.Fit.Implementierung.Table,1)==1
    Implementierung_Neu_Laden
else
    Mismatch=0;
    for i = 1:size(DRT_GUI.Fit.Implementierung.Table,1)-1
        for j = 5:size(DRT_GUI.Fit.Implementierung.Table,2)
            if ~isempty(DRT_GUI.Fit.Implementierung.Table{i,j}) && isempty(find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:) ,  DRT_GUI.Fit.Implementierung.Table{i,j}),1))
                Implementierung_Neu_Laden
                Mismatch = 1;
                break
            end
        end
        if Mismatch , break, end
    end
end

if ~sum(strcmp(fieldnames(DRT_GUI.Fit),'Implementierung')) , DRT_GUI.Fit.Implementierung=[];end

oldData = DRT_GUI.Fit.Implementierung;
Implementierung;


% --------------------------------------------------------------------
function MenAlleTemperaturenEisPlot_Callback(hObject, eventdata, handles)
% hObject    handle to MenAlleTemperaturenEisPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;
FarbenLaden

figure;

firstline = plot(1,1);
grid on;axis square; axis equal; set(gca,'ydir', 'reverse');

new_ax = gca;
TempStrings = get(handles.TemperaturPopup ,'String');
Temps = cellfun(@str2num,strrep(strrep(TempStrings(2:end),'grad',''),'m','-'));
min_T = min(Temps);
max_T = max(Temps);
delete(firstline);
for i_Z = 2:(numel(Temps)+1)
    
    if isempty(TempStrings{i_Z}) || ~isempty(strfind(TempStrings{i_Z},'gray')) || strcmp(TempStrings{i_Z},' ')
        continue
    end
    axes(handles.axes1);
    %     [a,b,c,legende] = legend;
    %     legendPosition = get(a,'Location');
    x_label =  get(get(gca,'xlabel'),'string');
    y_label =  get(get(gca,'ylabel'),'string');
    set(handles.TemperaturPopup,'Value',i_Z)
    TemperaturPopup_Callback(handles.TemperaturPopup,eventdata,handles)
    xlimits = xlim;
    ylimits = ylim;
   
        Zustandstring = DRT_GUI.Testparameter.Zustand;
    
    Lines = get(handles.axes1,'Children');
    newlines = copyobj(Lines,new_ax);
    FarbenIndex=round((DRT_GUI.Testparameter.SOC-min_T)*99/(max_T-min_T))+1;
    counter = 0;
    while FarbenIndex == -Inf && counter < 100000
        counter = counter +1;
        FarbenIndex=round((DRT_GUI.Testparameter.SOC-min_T)*99/(max_T-min_T))+1;
    end
    for i = 1:numel(newlines)
        set(newlines(i),'DisplayName',[get(newlines(i),'Displayname') ' ' sprintf('%0.2f%% SOC %0.2f°C ',DRT_GUI.Testparameter.SOC,DRT_GUI.Testparameter.Temperatur) Zustandstring ],'Color',PlotFarben(i_Z-1,:,:));
    end
    axes(new_ax)
    xlabel(x_label);ylabel(y_label);
    new_xlim = xlim;
    new_ylim = ylim;
    if new_xlim(1)< xlimits(1),xlimits(1) = new_xlim(1);end
    if new_xlim(2)> xlimits(2),xlimits(2) = new_xlim(2);end
    
    if new_ylim(1)< ylimits(1),ylimits(1) = new_ylim(1);end
    if new_ylim(2)> ylimits(2),ylimits(2) = new_ylim(2);end
    if ylimits(1)<0,ylimits(1)=0;end
    
    %xlim(xlimits)
    %ylim(ylimits)
    
end
grid on;
 colorbar
 caxis([min_T,max_T*1.001]);

axes(handles.axes1);
% legend(legende,'Location',legendPosition);
axes(new_ax);


% --------------------------------------------------------------------
function MenAlleTemperaturenMFEisPlot_Callback(hObject, eventdata, handles)
% hObject    handle to MenAlleTemperaturenMFEisPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DRT_GUI;
FarbenLaden

figure;

firstline = plot(1,1);
grid on;axis square; axis equal; set(gca,'ydir', 'reverse');

new_ax = gca;
TempStrings = get(handles.TemperaturPopup ,'String');
Temps = cellfun(@str2num,strrep(strrep(TempStrings(2:end),'grad',''),'m','-'));
min_T = min(Temps);
max_T = max(Temps);
delete(firstline);
for i_Z = 2:(numel(Temps)+1)
    
    if isempty(TempStrings{i_Z}) || ~isempty(strfind(TempStrings{i_Z},'gray')) || strcmp(TempStrings{i_Z},' ')
        continue
    end
    axes(handles.axes1);
    %     [a,b,c,legende] = legend;
    %     legendPosition = get(a,'Location');
    x_label =  get(get(gca,'xlabel'),'string');
    y_label =  get(get(gca,'ylabel'),'string');
    set(handles.TemperaturPopup,'Value',i_Z)
    TemperaturPopup_Callback(handles.TemperaturPopup,eventdata,handles)
    xlimits = xlim;
    ylimits = ylim;
   
        Zustandstring = DRT_GUI.Testparameter.Zustand;
    
    Lines = get(handles.axes2,'Children');
    newlines = copyobj(Lines,new_ax);
    FarbenIndex=round((DRT_GUI.Testparameter.SOC-min_T)*99/(max_T-min_T))+1;
    counter = 0;
    while FarbenIndex == -Inf && counter < 100000
        counter = counter +1;
        FarbenIndex=round((DRT_GUI.Testparameter.SOC-min_T)*99/(max_T-min_T))+1;
    end
    for i = 1:numel(newlines)
        set(newlines(i),'DisplayName',[get(newlines(i),'Displayname') ' ' sprintf('%0.2f%% SOC %0.2f°C ',DRT_GUI.Testparameter.SOC,DRT_GUI.Testparameter.Temperatur) Zustandstring ],'Color',PlotFarben(i_Z-1,:,:));
    end
    axes(new_ax)
    xlabel(x_label);ylabel(y_label);
    new_xlim = xlim;
    new_ylim = ylim;
    if new_xlim(1)< xlimits(1),xlimits(1) = new_xlim(1);end
    if new_xlim(2)> xlimits(2),xlimits(2) = new_xlim(2);end
    
    if new_ylim(1)< ylimits(1),ylimits(1) = new_ylim(1);end
    if new_ylim(2)> ylimits(2),ylimits(2) = new_ylim(2);end
    if ylimits(1)<0,ylimits(1)=0;end
    
    %xlim(xlimits)
    %ylim(ylimits)
    
end
grid on;
 colorbar
 caxis([min_T,max_T*1.001]);

axes(handles.axes1);
% legend(legende,'Location',legendPosition);
axes(new_ax);


% --------------------------------------------------------------------
function menAlleOCVFittingsZuruecksetzen_Callback(hObject, eventdata, handles)
% hObject    handle to menAlleOCVFittingsZuruecksetzen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;



SOCs = get(handles.SOCPopup ,'String');

for i_SOC = 2:numel(SOCs)

    if isempty(SOCs{i_SOC}) || ~isempty(strfind(SOCs{i_SOC},'gray'))
        continue
    end
    set(handles.SOCPopup,'Value',i_SOC)
    SOCPopup_Callback(handles.SOCPopup,eventdata,handles)

    ZeitbereichsFittingButton_Callback(handles.ZeitbereichsFittingButton,eventdata,handles)
    
    [~ , ImplementierungHandles] = Implementierung;
    eventdataneu.info='save';
Implementierung('ResetOCVFitButton_Callback',ImplementierungHandles.ResetOCVFitButton, eventdataneu, ImplementierungHandles)
    SpeichernButton_Callback(handles.SpeichernButton,eventdata,handles)


end
