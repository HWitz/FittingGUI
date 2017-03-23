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


function varargout = Implementierung(varargin)
% IMPLEMENTIERUNG MATLAB code for Implementierung.fig
%      IMPLEMENTIERUNG by itself, creates a new IMPLEMENTIERUNG or raises the
%      existing singleton*.
%
%      H = IMPLEMENTIERUNG returns the handle to a new IMPLEMENTIERUNG or the handle to
%      the existing singleton*.
%
%      IMPLEMENTIERUNG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMPLEMENTIERUNG.M with the given input arguments.
%
%      IMPLEMENTIERUNG('Property','Value',...) creates a new IMPLEMENTIERUNG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Implementierung_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Implementierung_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Implementierung

% Last Modified by GUIDE v2.5 10-Dec-2016 13:43:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Implementierung_OpeningFcn, ...
    'gui_OutputFcn',  @Implementierung_OutputFcn, ...
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

% --- Executes just before Implementierung is made visible.
function Implementierung_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Implementierung (see VARARGIN)

% Choose default command line output for Implementierung
% handles.output = 'Yes';

% Update handles structure
handles.output = hObject;
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
            case 'title'
                set(hObject, 'Name', varargin{index+1});
            case 'string'
                set(handles.text1, 'String', varargin{index+1});
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);
    
    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
        (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
load dialogicons.mat

IconData=questIconData;
questIconMap(256,:) = get(handles.figure1, 'Color');
IconCMap=questIconMap;

% Img=image(IconData, 'Parent', handles.axes1);
% set(handles.figure1, 'Colormap', IconCMap);
%
% set(handles.axes1, ...
%     'Visible', 'off', ...
%     'YDir'   , 'reverse'       , ...
%     'XLim'   , get(Img,'XData'), ...
%     'YLim'   , get(Img,'YData')  ...
%     );

% Make the GUI modal
%set(handles.figure1,'WindowStyle','modal')
global Modellliste
global DRT_GUI
if isempty(DRT_GUI) || isempty(cell2mat(strfind(fieldnames(DRT_GUI),'Fit')))
    uiresume(handles.figure1)
end
ColFormat = get(handles.ImplementierungsTable,'ColumnFormat');
ColFormat(1,1) = {[  ' '  ;fieldnames(Modellliste.Implementierung)]'};
ColFormat(1,5:end) = {''};
set(handles.ImplementierungsTable,'ColumnFormat',ColFormat);
if sum(strcmp(fieldnames(DRT_GUI.Fit),'Implementierung')) && ~isempty(DRT_GUI.Fit.Implementierung)
    handles.Implementierung = DRT_GUI.Fit.Implementierung;
    set(handles.ImplementierungsTable,'Data',handles.Implementierung.Table);
    ImplementierungsTable_CellEditCallback(handles.ImplementierungsTable, [], handles)
    
end

if ~sum(strcmp(fieldnames(DRT_GUI.Fit),'Implementierung')) || isempty(DRT_GUI.Fit.Implementierung)...
        || ~sum(strcmp(fieldnames(DRT_GUI.Fit.Implementierung),'OCV')) || isempty(handles.Implementierung.OCV)
    RelaxCell = {};
    %     RelaxCell = [ RelaxCell;{'COCV',false,3.8,0,5;'ROCV',false,3.7,0,5;'ROCV1',false,1e2,0,1e10;}];
    %     RelaxCell = [ RelaxCell;{'UStart2',false,1.1,0,5;  'UEnde2',false,1,0,5;  'ROCV2',false,1e2,0,1e10;}];
    set(handles.RelaxTable,'Data',RelaxCell)
else
    if size(handles.Implementierung.OCV,2) == 2 % altes Format
        handles.Implementierung.OCV(:,3) = {false};
        handles.Implementierung.OCV(:,4) = {-inf};
        handles.Implementierung.OCV(:,5) = {inf};
    end
    set(handles.RelaxTable,'Data', handles.Implementierung.OCV);
    % KettenleiterAnzahl noch in die EditBox reinschreiben
    set(handles.KettenleiterGliederEdit,'String',num2str(sum(cell2mat(regexp(handles.Implementierung.OCV(:,1),'OCV_RL\d')))));
    if ~isfinite(handles.Implementierung.OCV{1,2}),
        set(handles.ParallelOCVcheckbox,'value',0)
    else
        set(handles.ParallelOCVcheckbox,'value',1)
    end
    
end
if ~sum(strcmp(fieldnames(handles),'Implementierung')) || ~sum(strcmp(fieldnames(handles.Implementierung),'Config')) || isempty(handles.Implementierung.Config)
    handles.Implementierung.Config.PauseDchRatio = 100;
end

set(handles.PauseDchRatioTextbox,'string',num2str(handles.Implementierung.Config.PauseDchRatio))
axes(handles.axes2)
distinct_index = [1 1+find(abs(diff(DRT_GUI.Messdaten.relax.zeit))>0)];
DRT_GUI.Messdaten.relax.zeit = DRT_GUI.Messdaten.relax.zeit(distinct_index);
DRT_GUI.Messdaten.relax.spannung = DRT_GUI.Messdaten.relax.spannung(distinct_index);
DRT_GUI.Messdaten.relax.strom = DRT_GUI.Messdaten.relax.strom(distinct_index);
FarbenLaden
plot(DRT_GUI.Messdaten.relax.zeit,DRT_GUI.Messdaten.relax.spannung ,'color',RWTHBlau,'DisplayName','Messung','LineWidth',2)
grid on
if sum(strcmp(fieldnames(handles),'Implementierung')) && ~isempty(handles.Implementierung) && sum(strcmp(fieldnames(handles.Implementierung),'Sim')) && ~isempty(handles.Implementierung.Sim)
    hold on
    plot(handles.Implementierung.Sim.zeit,handles.Implementierung.Sim.spannung,'--','color',RWTHRot,'DisplayName','Simulation','LineWidth',2)
    
end
legend('off')
h1=legend('show');
set(h1,'Location','SouthEast','Interpreter','latex')
set(gca,'Ticklabelinterpreter','latex')
xlabel('Zeit in s','Interpreter','latex')
ylabel('Spannung in V','Interpreter','latex')
eventdata1.Indices=[1 1 ];
ImplementierungsTable_CellSelectionCallback(handles.ImplementierungsTable, eventdata1, handles)

guidata(hObject,handles)

% UIWAIT makes Implementierung wait for user response (see UIRESUME)
%uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Implementierung_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles;
% The figure can be deleted now
%delete(handles.figure1);

% --- Executes on button press in SpeichernButton.
function SpeichernButton_Callback(hObject, eventdata, handles)
% hObject    handle to SpeichernButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
% handles.output = get(hObject,'String');
if sum(strcmp(fieldnames(handles),'Implementierung')) && ~isempty(handles.Implementierung)
    DRT_GUI.Fit.Implementierung = handles.Implementierung;
end
% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.

run_DRT_GUI_save
delete(handles.figure1);
% uiresume(handles.figure1);

% --- Executes on button press in AbbrechenButton.
function AbbrechenButton_Callback(hObject, eventdata, handles)
% hObject    handle to AbbrechenButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
% uiresume(handles.figure1);
delete(handles.figure1);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if isequal(get(hObject, 'waitstatus'), 'waiting')
%     % The GUI is still in UIWAIT, us UIRESUME
%     uiresume(hObject);
% else
% The GUI is no longer waiting, just close it
delete(hObject);
% end


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % Check for "enter" or "escape"
% if isequal(get(hObject,'CurrentKey'),'escape')
%     % User said no by hitting escape
%     handles.output = 'No';
%
%     % Update handles structure
%     guidata(hObject, handles);
%
%     uiresume(handles.figure1);
% end
%
% if isequal(get(hObject,'CurrentKey'),'return')
%     uiresume(handles.figure1);
% end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

guidata(hObject,handles)




% --- Executes when selected cell(s) is changed in ImplementierungsTable.
function ImplementierungsTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to ImplementierungsTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

global Modellliste
global DRT_GUI
if isempty(eventdata) || ~isstruct(eventdata) || ~sum(strcmp(fieldnames(eventdata),'Indices')) || isempty(eventdata.Indices), return,end
ImplCell = struct2cell(Modellliste.Implementierung);
TableCell = get(handles.ImplementierungsTable,'Data');
ImpNr = 1;
ColNames = get(handles.ImplementierungsTable,'ColumnName');
ColNames=reshape(ColNames,1,numel(ColNames));
ColFormat = get(handles.ImplementierungsTable,'ColumnFormat');
if strcmp(TableCell{eventdata.Indices(1),1},' ') || isempty(TableCell{eventdata.Indices(1),1})
    ColAnz = 0;
else
    ImpNr = find(strcmp(fieldnames(Modellliste.Implementierung),TableCell{eventdata.Indices(1),1}));
    ColAnz = numel(ImplCell{ImpNr}.inputs);
    ColFormat(1,5:ColAnz+4) = {DRT_GUI.Fit.aktuell_Modell.P_Name(1,:)};
    if ~isempty(ImplCell{ImpNr}.inputs)
        ColNames(1,5:ColAnz+4) = ImplCell{ImpNr}.inputs;
    end
end

ColFormat(1,5+ColAnz:end) = {''};
set(handles.ImplementierungsTable,'ColumnFormat',ColFormat);
ColNames(1,5+ColAnz:end) = {''};

set(handles.ImplementierungsTable,'ColumnName',ColNames');
set(handles.ImplementierungsTable,'ColumnEditable',[true(1,2) false(1,2) true(1,ColAnz)  false(1,numel(ColNames)-ColAnz-2)]);
if sum(strcmp(fieldnames(handles),'Implementierung')) && ~isempty(handles.Implementierung) ...
        && sum(strcmp(fieldnames(handles.Implementierung),'Table'))...
        && size(handles.Implementierung.Table,2)< numel(ColNames)
    handles.Implementierung.Table(:,end+(numel(ColNames)-size(handles.Implementierung.Table,2))) = {''};
    set(handles.ImplementierungsTable,'Data',handles.Implementierung.Table);
end


% --- Executes when entered data in editable cell(s) in ImplementierungsTable.
function ImplementierungsTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to ImplementierungsTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global Modellliste
global DRT_GUI
handles.Implementierung.Table = get(handles.ImplementierungsTable,'Data');
ImplementierungsTable_CellSelectionCallback(hObject,eventdata, handles)
if ~isempty(eventdata) && isstruct(eventdata) && sum(strcmp(fieldnames(eventdata),'Indices')) && ~isempty(eventdata.Indices) ...
        && eventdata.Indices(2)==1
    handles.Implementierung.Table(eventdata.Indices(1),2:end) = {''};
end

handles.Implementierung.Table(find(strcmp(handles.Implementierung.Table(:,1),'')),:) = [];
handles.Implementierung.Table(find(strcmp(handles.Implementierung.Table(:,1),' ')),:) = [];
handles.Implementierung.Table(end+1,:)={''};
handles.Implementierung.Info = cell(size(handles.Implementierung.Table,1),1);
set(handles.ImplementierungsTable,'Data',handles.Implementierung.Table)
for i = 1:size(handles.Implementierung.Table,1)
    if sum(find(strcmp(handles.Implementierung.Table{i,1},fieldnames(Modellliste.Implementierung))))
        handles.Implementierung.Info{i} = Modellliste.Implementierung.(handles.Implementierung.Table{i,1});
    end
end
for i = 1:numel(handles.Implementierung.Info)-1
    if isempty(handles.Implementierung.Info{i}),continue;end
    args = cell(1,numel(handles.Implementierung.Info{i}.inputs));
    argliste = '';
    if size(handles.Implementierung.Table,2)<(4+numel(handles.Implementierung.Info{i}.inputs)) || sum(find(strcmp('',handles.Implementierung.Table(i,4+(1:numel(handles.Implementierung.Info{i}.inputs)))))) || ...
            sum(find(strcmp(' ',handles.Implementierung.Table(i,4+(1:numel(handles.Implementierung.Info{i}.inputs))))))
        continue
    end
    for k = 1:numel(handles.Implementierung.Info{i}.inputs)
        ParNr = find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),handles.Implementierung.Table{i,k+4}));
        if isempty(ParNr)
            warning('Konnte Parameter aus Implementierung nicht finden. Implementierungsinfos werden reseted!')
            set(handles.ImplementierungsTable,'Data',handles.Implementierung.Table)
            guidata(hObject,handles)
            return
        end
        args{k} = DRT_GUI.Fit.Parameter(ParNr);
        argliste = [argliste 'args{' num2str(k) '},' ];
    end
    argliste = argliste(1:end-1);
    if strcmp(handles.Implementierung.Table{i,1},'OCV_source')
        
        DeltaU = DRT_GUI.Messdaten.relax.spannung(end)-DRT_GUI.Messdaten.relax.spannung(1);
        Ladung = [0 cumsum(DRT_GUI.Messdaten.relax.strom(1:end-1) .* diff(DRT_GUI.Messdaten.relax.zeit))];
        C_OCV = Ladung(end) / DeltaU;
        
        if ismember('Funktionsname',fieldnames(handles.Implementierung.Info{i}))
            Z = CalculateESBeImpedance(handles.Implementierung.Info{i},DRT_GUI.Fit.omega,C_OCV);
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(handles.Implementierung.Info{i}.Funktionsname,C_OCV);
        elseif ismember('f',fieldnames(handles.Implementierung.Info{i}))
            Z = handles.Implementierung.Info{i}.Z(C_OCV,DRT_GUI.Fit.omega);
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = handles.Implementierung.Info{i}.f(C_OCV);
        end
    elseif isempty(argliste)
        if ismember('Funktionsname',fieldnames(handles.Implementierung.Info{i}))
            Z = CalculateESBeImpedance(handles.Implementierung.Info{i},DRT_GUI.Fit.omega);
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(handles.Implementierung.Info{i}.Funktionsname);
        elseif ismember('f',fieldnames(handles.Implementierung.Info{i}))
            Z =handles.Implementierung.Info{i}.Z(DRT_GUI.Fit.omega);
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = handles.Implementierung.Info{i}.f;
        end
    else
        if ismember('Funktionsname',fieldnames(handles.Implementierung.Info{i}))
            Z = CalculateESBeImpedance(handles.Implementierung.Info{i},DRT_GUI.Fit.omega,args{:});
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(handles.Implementierung.Info{i}.Funktionsname,args{:});
        elseif ismember('f',fieldnames(handles.Implementierung.Info{i}))
            eval(['Z=handles.Implementierung.Info{i}.Z(' argliste ',DRT_GUI.Fit.omega);'])
            eval(['[R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = handles.Implementierung.Info{i}.f(' argliste ');'])
        end
    end
    %2 * Clim1^2 * Sigma.^2 / (n*pi).^2
    %     tau =
    tau = C_RC(find(R_RC==max(R_RC),1))*max(R_RC);
    handles.Implementierung.Table{i,3}=sum(R_RC)+sum(R_ser);
    handles.Implementierung.Table{i,4} = tau;
end
set(handles.ImplementierungsTable,'Data',handles.Implementierung.Table)
guidata(hObject,handles)

KettenleiterGliederEdit_Callback(handles.KettenleiterGliederEdit, eventdata, handles)







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
handles.Implementierung.OCV = get(handles.RelaxTable,'Data');
guidata(hObject,handles)


% --- Executes on button press in RelaxExportButton.
function RelaxExportButton_Callback(hObject, eventdata, handles)
% hObject    handle to RelaxExportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
savefig(['export/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie '_TDMFit_' ...
    DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_'...
    strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m') 'SOC'...
    '.fig'])




% --- Executes on button press in OCVFitButton.
function OCVFitButton_Callback(hObject, eventdata, handles)
% hObject    handle to OCVFitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI;
if sum(strcmp(fieldnames(handles),'Implementierung')) && ~isempty(handles.Implementierung)
    
    Voigt.R_RC = [];
    Voigt.C_RC = [];
    Voigt.R_ser = 0;
    Voigt.C_ser = [];
    
    OCV.R_RC = [];
    OCV.C_RC = [];
    OCV.R_ser = 0;
    OCV.C_ser = [];
    ReFit = [];
    for i = 1:numel(handles.Implementierung.Info)-1
        % Erzeuge für alle Implementierungselemente die entsprechenden
        % Voigt-Netzwerke, sowie Rser und Cser
        args = cell(1,numel(handles.Implementierung.Info{i}.inputs));
        argliste = '';
        for k = 1:numel(handles.Implementierung.Info{i}.inputs)
            ParNr = find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),handles.Implementierung.Table{i,k+4}));
            if isempty(ParNr)
                warning('Konnte Parameter aus Implementierung nicht finden. Implementierungsinfos werden reseted!')
                DRT_GUI.Fit=rmfield(DRT_GUI.Fit,'Implementierung');
                return
            end
            args{k} = DRT_GUI.Fit.Parameter(ParNr);
            argliste = [argliste 'args{' num2str(k) '},' ];
        end
        argliste = argliste(1:end-1);
        if strcmp(handles.Implementierung.Table{i,1},'OCV_source')
            DeltaU = DRT_GUI.Messdaten.relax.spannung(end)-DRT_GUI.Messdaten.relax.spannung(1);
            Ladung = [0 cumsum(DRT_GUI.Messdaten.relax.strom(1:end-1) .* diff(DRT_GUI.Messdaten.relax.zeit))];
            C_OCV = Ladung(end) / DeltaU;
            if ismember('Funktionsname',fieldnames(handles.Implementierung.Info{i}))
                [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(handles.Implementierung.Info{i}.Funktionsname,C_OCV);
            elseif ismember('f',fieldnames(handles.Implementierung.Info{i}))
                [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = handles.Implementierung.Info{i}.f(C_OCV);
            end
        elseif isempty(argliste)
            if ismember('Funktionsname',fieldnames(handles.Implementierung.Info{i}))
                [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(handles.Implementierung.Info{i}.Funktionsname);
            elseif ismember('f',fieldnames(handles.Implementierung.Info{i}))
                [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = handles.Implementierung.Info{i}.f;
            end
        else
            if ismember('Funktionsname',fieldnames(handles.Implementierung.Info{i}))
                [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(handles.Implementierung.Info{i}.Funktionsname,args{:});
            elseif ismember('f',fieldnames(handles.Implementierung.Info{i}))
                eval(['[R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = handles.Implementierung.Info{i}.f(' argliste ');'])
            end
        end
        
        if ~isempty(regexp(handles.Implementierung.Table{i,2},'OCV\d'))
            % Falls OCV beim Implementierungselement gewählt wurde,
            % bedeutet das, dass parallel zum Element eine OCV-Quelle
            % angeschlossen ist.
            OCV.R_RC = [OCV.R_RC ;R_RC'];
            OCV.C_RC = [OCV.C_RC ;C_RC'];
            if ~isempty(R_ser) , OCV.R_ser = OCV.R_ser + R_ser; end
            if ~isempty(C_ser) && abs(C_ser) < 1e16
                if isempty(OCV.C_ser) || abs(OCV.C_ser)>1e16
                    OCV.C_ser = C_ser;
                else
                    OCV.C_ser = (OCV.C_ser .* C_ser)./(OCV.C_ser + C_ser);
                end
            end
        elseif ~isempty(regexp(handles.Implementierung.Table{i,2},'Re-Fit'))
            % Falls Re-Fit beim Implementierungselement gewählt wurde,
            % bedeutet das, dass im Time-Domain-Fitting das Element neu gefittet wird.
            ReFit(numel(ReFit)+1).Info = handles.Implementierung.Info{i};
            ReFit(numel(ReFit)).ParNames = handles.Implementierung.Table(i,5:4+numel(args));
            ReFit(numel(ReFit)).args = args;
            for arg_i = 1:numel(args)
                
                FoundIndex = find(strcmp(handles.Implementierung.OCV(:,1),['ReFit_' ReFit(end).ParNames{arg_i}])  ,1);
                if ~isempty(FoundIndex)
                    ReFit(numel(ReFit)).args{arg_i} = handles.Implementierung.OCV{FoundIndex,2};
                    if ~handles.Implementierung.OCV{FoundIndex,3}
                        ReFit(numel(ReFit)).min{arg_i} = handles.Implementierung.OCV{FoundIndex,4};
                        ReFit(numel(ReFit)).max{arg_i} = handles.Implementierung.OCV{FoundIndex,5};
                    else
                        ReFit(numel(ReFit)).min{arg_i} = handles.Implementierung.OCV{FoundIndex,2};
                        ReFit(numel(ReFit)).max{arg_i} = handles.Implementierung.OCV{FoundIndex,2};
                    end
                end
            end
            
        else
            % Falls nicht, liegt es als reines Voigtnetzwerk mit Rser und Cser vor
            Voigt.R_RC = [Voigt.R_RC ;R_RC'];
            Voigt.C_RC = [Voigt.C_RC ;C_RC'];
            if ~isempty(R_ser) , Voigt.R_ser = Voigt.R_ser + R_ser; end
            if ~isempty(C_ser) && abs(C_ser) < 1e16
                if isempty(Voigt.C_ser) || abs(Voigt.C_ser)>1e16
                    Voigt.C_ser = C_ser;
                else
                    Voigt.C_ser = (Voigt.C_ser .* C_ser)./(Voigt.C_ser + C_ser);
                end
            end
        end
    end
    
    
    if isempty(OCV.R_RC) && (isempty(OCV.C_ser) || abs(OCV.C_ser)>1e16) && OCV.R_ser && isempty(ReFit)==0, return,end
    
    % stromindex findet die Stellen, an denen der Strom springt
    stromindex = [1 1+ find(abs(diff(DRT_GUI.Messdaten.relax.strom)./diff(DRT_GUI.Messdaten.relax.zeit))>0.2)];
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
    ModellSpannung = DRT_GUI.Messdaten.relax.strom .* Voigt.R_ser;
    if ~(isempty(Voigt.C_ser) ||  abs(Voigt.C_ser)>1e16)
        ModellSpannung =ModellSpannung +...
            [0 cumsum(diff(DRT_GUI.Messdaten.relax.zeit).*DRT_GUI.Messdaten.relax.strom(1:end-1)./Voigt.C_ser)];
    end
    U_RC = zeros(numel(DRT_GUI.Messdaten.relax.strom),numel(Voigt.R_RC));
    for i = 1:numel(stromindex)-1
        if stromindex(i)==1
            U0 = zeros(size(Voigt.R_RC));
        else
            U0 = U_RC(stromindex(i),:);
        end
        Umax = strom(i).*Voigt.R_RC;
        t = DRT_GUI.Messdaten.relax.zeit(stromindex(i)+1:stromindex(i+1))-DRT_GUI.Messdaten.relax.zeit(stromindex(i));
        for k = 1:numel(Voigt.R_RC)
            if abs(U0(k)-Umax(k))<=0.0001
                U_RC(stromindex(i)+1:stromindex(i+1),k) = Umax(k);
            else
                U_RC(stromindex(i)+1:stromindex(i+1),k) = U0(k)+(Umax(k)-U0(k)).*(1-exp(-t./(Voigt.R_RC(k).*Voigt.C_RC(k))));
            end
        end
    end
    ModellSpannung = ModellSpannung + sum(U_RC,2)';
    % ModellSpannung ist alles was nicht zum OCV-Schaltkreis gehört.
    
    % OCV_EIS_Spannung beschreibt das Verhalten der zur OCV zugehörigen
    % Elemente des Ersatzschaltbildes. Es werden zunächst nur die Werte der
    % EIS-Parametrierung verwendet.
    OCV_EIS_Spannung = zeros(size(ModellSpannung));
    OCV_EIS_Cser_Spannung = zeros(size(ModellSpannung));
    OCV_EIS_Cser_ges = [];
    if ~(isempty(OCV.R_RC) && (isempty(OCV.C_ser) || abs(OCV.C_ser)>1e16) && OCV.R_ser)
        OCV_EIS_Spannung = OCV_EIS_Spannung + DRT_GUI.Messdaten.relax.strom .* OCV.R_ser;
        % Falls unter den OCV-Elementen Serien-Kapazitäten sind, können
        % deren Spannungen direkt berechnet werden.
        if ~(isempty(OCV.C_ser)  || abs(OCV.C_ser)>1e16)
            OCV_EIS_Spannung =OCV_EIS_Spannung +...
                [0 cumsum(diff(DRT_GUI.Messdaten.relax.zeit).*DRT_GUI.Messdaten.relax.strom(1:end-1)./OCV.C_ser)];
            OCV_EIS_Cser_Spannung =OCV_EIS_Cser_Spannung +...
                [0 cumsum(diff(DRT_GUI.Messdaten.relax.zeit).*DRT_GUI.Messdaten.relax.strom(1:end-1)./OCV.C_ser)];
        end
        % Die Spannung des Voigt-Netzwerkes, die zur OCV-Quelle gehören
        % werden für jedes Zeit-Strom-Tupel exakt berechnet.
        U_RC = zeros(numel(DRT_GUI.Messdaten.relax.strom),numel(OCV.R_RC));
        for i = 1:numel(stromindex)-1
            if stromindex(i)==1
                U0 = zeros(size(OCV.R_RC));
            else
                U0 = U_RC(stromindex(i),:);
            end
            Umax = strom(i).*OCV.R_RC;
            t = DRT_GUI.Messdaten.relax.zeit(stromindex(i)+1:stromindex(i+1))-DRT_GUI.Messdaten.relax.zeit(stromindex(i));
            for k = 1:numel(OCV.R_RC)
                if abs(U0(k)-Umax(k))<=0.0001
                    U_RC(stromindex(i)+1:stromindex(i+1),k) = Umax(k);
                else
                    U_RC(stromindex(i)+1:stromindex(i+1),k) = U0(k)+(Umax(k)-U0(k)).*(1-exp(-t./(OCV.R_RC(k).*OCV.C_RC(k))));
                end
            end
        end
        OCV_EIS_Spannung = OCV_EIS_Spannung + sum(U_RC,2)';
    end
    Ladung = [0 cumsum(DRT_GUI.Messdaten.relax.strom(1:end-1) .* diff(DRT_GUI.Messdaten.relax.zeit))];
    % FitSpannung ist das, was übrig bleibt. Um nun einen Startwert für
    % das Fitting von R_OCV zu erhalten, wird als Ansatz ein weiteres
    % RC-Glied im Voigtnetzwerk definiert. Dessen Zeitkonstante und
    % damit dessen R wird gefittet. Dieses wird für den tatsächlichen
    % R_OCV-Fit als Startwert verwendet. Hier ist jedoch die OCV-Quelle
    % und der OCV-Widerstand R_OCV parallel zur Verschaltung der
    % EIS-OCV-Elemente (meist die beiden Warburg-Impedanzen) gewählt
    FitSpannung = DRT_GUI.Messdaten.relax.spannung-(ModellSpannung+OCV_EIS_Spannung-OCV_EIS_Cser_Spannung+DRT_GUI.Messdaten.relax.spannung(1));
    % C_OCV_ges ist keine tatsächliche Kapazität im Ersatzschaltbild. Es
    % dient lediglich der Berechnung der OCV-Spannungsquelle
    C_OCV_ges = Ladung(end) / FitSpannung(end);
    
    
    %figure; plot(DRT_GUI.Messdaten.relax.zeit,FitSpannung);grid on
    
    FitIndex = find(abs(DRT_GUI.Messdaten.relax.strom)>1e-4,1,'last'):numel(FitSpannung);
    FitIndex(1:floor(numel(FitIndex)/5))=[];
    FitZeit=DRT_GUI.Messdaten.relax.zeit(FitIndex)-DRT_GUI.Messdaten.relax.zeit(FitIndex(1));
    FitSpannung = FitSpannung(FitIndex);
    FitSpannung = abs(FitSpannung);
    
    p_init = [1000 FitSpannung(end) FitSpannung(1)-FitSpannung(end)];
    modelformel = 'p(2)+p(3).*exp(-w./p(1))';
    options = optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-12,'TolFun',1e-12);
    [p,fval,exitflag,output]=function_fit_easyfit2(FitZeit,[FitSpannung, zeros(size(FitSpannung))],p_init,@function_model_all_types2, [0 -inf -inf ], [inf,inf,inf] ,options, modelformel);
    %      w = FitZeit;
    %      gefittet = eval(modelformel);
    %     figure; plot(FitZeit,FitSpannung,FitZeit,gefittet);grid on
    %    figure; plot(DRT_GUI.Messdaten.relax.zeit,OCV_U);grid on
    if size(handles.Implementierung.OCV,1)== 4 && ~isempty(OCV.C_ser)
        ROCV = p(1)/OCV(1).C_ser;
        if ROCV > 10 , ROCV = 1 ; end
        if ROCV < 0 , ROCV = 1000 ; end
    else
        RelaxTable = get(handles.RelaxTable,'Data');
        if ~isempty(RelaxTable)
            ROCV = RelaxTable{1,2};
        else
            ROCV = 1;
        end
    end
    
    handles.Implementierung.OCV(1:4,:) = {'ROCV',ROCV,false,-inf,inf;'COCV',C_OCV_ges,false,-inf,inf;'UStart',DRT_GUI.Messdaten.relax.spannung(1),false,-inf,inf;'UEnde',DRT_GUI.Messdaten.relax.spannung(end),false,-inf,inf};
    set(handles.RelaxTable,'Data',handles.Implementierung.OCV)
    
    % OCV_U ist die Ruhespannung, die sich rein über eine lineare
    % Interpolation der Endspannung und Anfangsspannung über die
    % umgesetzte Ladung ergibt.
    % OCV_U = DRT_GUI.Messdaten.relax.spannung(1) + Ladung/Ladung(end) * (DRT_GUI.Messdaten.relax.spannung(end)-DRT_GUI.Messdaten.relax.spannung(1));
    
    
    % Erzeuge einen Vektor FitSpannung und FitZeit, mit äquidistanten
    % Zeitschritten für den Least-Square-Fit. Keine Stelle der Relaxation
    % ist wichtiger als die anderen.
    
    % todo: besser eine Schrittdauer vorgeben und dann dazwischen
    % interpolieren
    %FitZeit = 0:max([5 , min(diff(DRT_GUI.Messdaten.relax.zeit))]):DRT_GUI.Messdaten.relax.zeit(end);
    FitZeit = 0:1:DRT_GUI.Messdaten.relax.zeit(end);
    
    FitSpannung = interp1(DRT_GUI.Messdaten.relax.zeit,DRT_GUI.Messdaten.relax.spannung,FitZeit);
    FitModellSpannung = interp1(DRT_GUI.Messdaten.relax.zeit,ModellSpannung,FitZeit);
    fitstromindex = 1;
    fitstromindexorig = 1;
    fitstrom = [];
    for it = 2:numel(stromindex)-1
        fitstromindex(end+1)  = find(FitZeit>=DRT_GUI.Messdaten.relax.zeit(stromindex(it)),1,'first');
        if it>1 && fitstromindex(end) <= fitstromindex(end-1),
            fitstromindex(end) = [];
        else
            fitstromindexorig(end+1)  = find(DRT_GUI.Messdaten.relax.zeit>=FitZeit(fitstromindex(end)),1,'first');
            fitstrom(end+1) = sum(DRT_GUI.Messdaten.relax.strom(fitstromindexorig(end-1):fitstromindexorig(end)-1).*timediff(fitstromindexorig(end-1):fitstromindexorig(end)-1)./sum(timediff(fitstromindexorig(end-1):fitstromindexorig(end)-1)));
        end
    end
    fitstromindex(end+1) = numel(FitZeit);
    fitstrom(end+1) = 0;
    % Es wird nicht die gesammte Relaxation betrachtet, sondern lediglich
    % bis PauseDchRatio-mal soviel Zeit gewartet wurde, wie die Entladung
    % gedauert hat.
    fitstromindex(end) = fitstromindex(end-1)+fitstromindex(end-1)*handles.Implementierung.Config.PauseDchRatio;
    if fitstromindex(end)>numel(FitSpannung),fitstromindex(end)=numel(FitSpannung);end
    
    % hier noch R_Ladder_OCV C_Ladder_OCV einbauen
    if isempty(OCV.C_ser) , C_EIS = 0 ; else C_EIS = OCV.C_ser;end
    OCV.n_Ladder = sum(cell2mat(regexp(handles.Implementierung.OCV(:,1),'OCV_RL\d')));
    R_Ladder_OCV = zeros(1,OCV.n_Ladder);
    C_Ladder_OCV = zeros(1,OCV.n_Ladder);
    for i = 1:OCV.n_Ladder
        R_Ladder_OCV(1,i) = handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_RL' num2str(i)]),1),2};
        C_Ladder_OCV(1,i) = handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_CL' num2str(i)]),1),2};
        %         if handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_CL' num2str(i)]),1),2}
        %             min_R_Ladder_OCV = handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_CL' num2str(i)]),1),2};
        %             min_R_Ladder_OCV = handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_CL' num2str(i)]),1),2};
        %         else
        %             min_R_Ladder_OCV = handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_CL' num2str(i)]),1),4};
        %             min_R_Ladder_OCV = handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_CL' num2str(i)]),1),5};
        %         end
    end
    C_Ladder_OCV(C_Ladder_OCV==1) = (C_OCV_ges-C_EIS)/numel(C_Ladder_OCV);
    initwerte = [ROCV C_OCV_ges R_Ladder_OCV C_Ladder_OCV];
    minwerte = [1e-5 C_OCV_ges*0.8 ones(size(R_Ladder_OCV))*0 ones(size(R_Ladder_OCV))*0];
    maxwerte = [inf C_OCV_ges*1.2 ones(size(R_Ladder_OCV))*inf ones(size(R_Ladder_OCV))*(C_OCV_ges*1.2-C_EIS) ];
    
    if get(handles.Relaxation_complete_CheckBox,'value')
        minwerte(2) = C_OCV_ges;
        maxwerte(2) = C_OCV_ges;
    end
    if ~get(handles.ParallelOCVcheckbox,'value')
        initwerte(1) = [];
        minwerte(1) = [];
        maxwerte(1) = [];
    end
    
    for n_f = 1:numel(ReFit)
        initwerte = [initwerte cell2mat(ReFit(n_f).args)];
        minwerte  = [minwerte  cell2mat(ReFit(n_f).min)];
        maxwerte  = [maxwerte  cell2mat(ReFit(n_f).max)];
        
    end
    VergleichZeit = FitZeit(1:fitstromindex(end))';
    VergleichSpannung = FitSpannung(1:fitstromindex(end))';
    
    IndexOhneWertung=[];
    if get(handles.stromloseMesspunkteCheckbox,'value')
        for i2 = 1:numel(fitstrom)-1
            if abs(fitstrom(i2))>0.001
                IndexOhneWertung = [ IndexOhneWertung fitstromindex(i2)+1:fitstromindex(i2+1)-1];
            end
        end
    end
    options = optimset('MaxIter',1000,'MaxFunEvals',1000,'TolX',1e-3,'TolFun',1e-3);
    [p,fval,exitflag,output]=function_fit_easyfit2(VergleichZeit,[VergleichSpannung, zeros(numel(VergleichZeit),1)],initwerte,...
        @Fit_OCV_Spannung, minwerte,maxwerte,options, ...
        {OCV,ReFit,fitstrom,fitstromindex,FitModellSpannung(1:fitstromindex(end))',VergleichSpannung,handles,IndexOhneWertung});
    if ~get(handles.ParallelOCVcheckbox,'value')
        p = [inf p];
    end
    ROCV = p(1);
    C_OCV_ges = p(2);
    for i = 1:(OCV.n_Ladder)
        R_Ladder_OCV(1,i) = p(2+i);
        C_Ladder_OCV(1,i) = p(2+i+OCV.n_Ladder);
        handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_RL' num2str(i)]),1),2} = R_Ladder_OCV(1,i);
        handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_CL' num2str(i)]),1),2} = C_Ladder_OCV(1,i);
    end
    n_p = 3+2*OCV.n_Ladder;
    for i = 1:numel(ReFit)
        %  Results aus ReFit in OCV-Tabelle eintragen
        for k = 1:numel(ReFit(i).args)
            ReFit(i).args{k} = p(n_p);
            n_p = n_p+1;
            handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['ReFit_' ReFit(i).ParNames{k}]),1),2} = ReFit(i).args{k};
        end
    end
    UEnde = DRT_GUI.Messdaten.relax.spannung(1)+Ladung(end)/C_OCV_ges;
    handles.Implementierung.OCV(1:4,1:2) = {'ROCV',ROCV;'COCV',C_OCV_ges;'UStart',DRT_GUI.Messdaten.relax.spannung(1);'UEnde',UEnde};
    set(handles.RelaxTable,'Data',handles.Implementierung.OCV)
    
    guidata(hObject,handles);
    PlotOCVButton_Callback(handles.PlotOCVButton,eventdata,handles);
end

function [U] = Fit_OCV_Spannung(p,t,args)
% Achtung, COCV ist kein reales Element im Netzwerk. Es dient nur zur
% Berechnung der Spannung auf der OCV-Spannungsquelle.

tic
handles = args{7};
if ~get(handles.ParallelOCVcheckbox,'value')
    p = [inf p];
end

ROCV = p(1);
COCV = p(2);
OCV = args{1};
ReFit = args{2};
strom = args{3};
stromindex = args{4};
ModellSpannung = args{5};
U_Mess = args{6};
IndexOhneWertung=args{8};
R_Ladder_OCV = []; % Eingefügt von psa
C_Ladder_OCV = []; % Eingefügt von psa
if OCV.n_Ladder>0
    R_Ladder_OCV = p(3:2+OCV.n_Ladder);
    C_Ladder_OCV = p(3+OCV.n_Ladder:2+2*OCV.n_Ladder);
end
U = ModellSpannung+U_Mess(1) ;
if OCV.n_Ladder>0 || ( isfinite(ROCV) )
    U  = U + OCV_Spannung(ROCV,COCV,R_Ladder_OCV,C_Ladder_OCV,t,OCV,strom,stromindex);
end
ReFitSpannung = zeros(size(ModellSpannung));
if ~isempty(ReFit)
    n_p = 3+2*OCV.n_Ladder;
    Voigt.R_RC = [];
    Voigt.C_RC = [];
    Voigt.R_ser = 0;
    Voigt.C_ser = [];
    for i = 1:numel(ReFit)
        
        % Erzeuge für alle Implementierungselemente die entsprechenden
        % Voigt-Netzwerke, sowie Rser und Cser
        argliste = '';
        for k = 1:numel(ReFit(i).args)
            ReFit(i).args{k} = p(n_p);
            n_p = n_p+1;
            argliste = [argliste 'ReFit(i).args{' num2str(k) '},' ];
        end
        argliste = argliste(1:end-1);
        if ismember('Funktionsname',fieldnames(ReFit(i).Info))
            eval(['[R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(ReFit(i).Info.Funktionsname,' argliste ');'])
        elseif ismember('f',fieldnames(ReFit(i).Info))
            eval(['[R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = ReFit(i).Info.f(' argliste ');'])
        end        
        
        % Falls nicht, liegt es als reines Voigtnetzwerk mit Rser und Cser vor
        Voigt.R_RC = [Voigt.R_RC ;R_RC'];
        Voigt.C_RC = [Voigt.C_RC ;C_RC'];
        if ~isempty(R_ser) , Voigt.R_ser = Voigt.R_ser + R_ser; end
        if ~isempty(C_ser) && abs(C_ser) < 1e16
            if isempty(Voigt.C_ser) || abs(Voigt.C_ser)>1e16
                Voigt.C_ser = C_ser;
            else
                Voigt.C_ser = (Voigt.C_ser .* C_ser)./(Voigt.C_ser + C_ser);
            end
        end
        
    end
    
    U_RC = zeros(numel(ReFitSpannung),numel(Voigt.R_RC));
    AlleStrom = zeros(numel(ReFitSpannung),1);
    for i = 1:numel(stromindex)-1
        if stromindex(i)==1
            U0 = zeros(size(Voigt.R_RC));
        else
            U0 = U_RC(stromindex(i),:);
        end
        Umax = strom(i).*Voigt.R_RC;
        zeit = t(stromindex(i)+1:stromindex(i+1))-t(stromindex(i));
        AlleStrom(stromindex(i):stromindex(i+1)-1) =  strom(i);
        for k = 1:numel(Voigt.R_RC)
            if abs(U0(k)-Umax(k))<=0.0001
                U_RC(stromindex(i)+1:stromindex(i+1),k) = Umax(k);
            else
                U_RC(stromindex(i)+1:stromindex(i+1),k) = U0(k)+(Umax(k)-U0(k)).*(1-exp(-zeit./(Voigt.R_RC(k).*Voigt.C_RC(k))));
            end
        end
        ReFitSpannung(stromindex(i)+1:stromindex(i+1))=ReFitSpannung(stromindex(i)+1:stromindex(i+1))+...
            strom(i) .* Voigt.R_ser;
    end
    if ~(isempty(Voigt.C_ser) ||  abs(Voigt.C_ser)>1e16)
        CserSpannung=cumsum([ diff(t(stromindex(1):stromindex(end))) ; 0 ].*AlleStrom)./Voigt.C_ser;
    else
        CserSpannung = zeros(numel(ReFitSpannung),1);
    end
    ReFitSpannung = ReFitSpannung + sum(U_RC,2) + CserSpannung;
    U = U+ReFitSpannung;
end
U = [U zeros(size(U))];
%display(sprintf('Cserspannung: %f,   Cser: %f      As: %f', CserSpannung(end), Voigt.C_ser,sum([ diff(t(stromindex(1):stromindex(end))) ; 0 ].*AlleStrom)));

handles.Implementierung.OCV{1,2} = ROCV;
for i = 1:(OCV.n_Ladder)
    R_Ladder_OCV(1,i) = p(2+i);
    C_Ladder_OCV(1,i) = p(2+i+(OCV.n_Ladder));
    handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_RL' num2str(i)]),1),2} = R_Ladder_OCV(1,i);
    handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_CL' num2str(i)]),1),2} = C_Ladder_OCV(1,i);
end
n_p = 3+2*OCV.n_Ladder;
for i = 1:numel(ReFit)
    % Results aus ReFit in OCV-Tabelle eintragen
    for k = 1:numel(ReFit(i).args)
        ReFit(i).args{k} = p(n_p);
        n_p = n_p+1;
        handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['ReFit_' ReFit(i).ParNames{k}]),1),2} = ReFit(i).args{k};
    end
end



U(IndexOhneWertung,1) = U_Mess(IndexOhneWertung);

if get(handles.FitPlotZeichnenCheckbox,'value')
    set(handles.RelaxTable,'Data',handles.Implementierung.OCV)
    
    axes(handles.axes2)
    
    hold off
    plot(t,U(:,1),'ro','MarkerSize',1.5);
    grid on
    hold on
    plot(t,U_Mess,'bo','MarkerSize',1.5)
    %figure;plot(t,ReFitSpannung,'k');plot(t,U_Mess-U_Mess(1),'r');hold on;;plot(t,U(:,1)-ReFitSpannung-U_Mess(1),'b');
    legend('Messung',sprintf('Sim, R=%2.3e',ROCV))
    drawnow
    toc
end
guidata(handles.OCVFitButton,handles);


function [U] = OCV_Spannung(ROCV,COCV,R_Ladder_OCV,C_Ladder_OCV,t,OCV,strom,stromindex)
% Achtung, COCV ist kein reales Element im Netzwerk. Es dient nur zur
% Berechnung der Spannung auf der OCV-Spannungsquelle.

U = zeros(size(t));

fastind = find((OCV.R_RC.*OCV.C_RC)<0.3);
OCV.R_ser = OCV.R_ser + sum(OCV.R_RC(fastind));
OCV.R_RC(fastind)=[];
OCV.C_RC(fastind)=[];

U_0 = zeros(1+numel(OCV.R_RC)+numel(OCV.C_ser)+numel(C_Ladder_OCV),1);
options = odeset('RelTol',1e-4,'AbsTol',1e-5*ones(size(U_0)),'MaxStep',1);
for i = 1:numel(stromindex)-1
    [odetime , odespannung] = ode45(@dudt,[t(stromindex(i):stromindex(i+1))],...
        [U_0],options,strom(i),OCV,ROCV,COCV,R_Ladder_OCV,C_Ladder_OCV);
    if stromindex(i+1)-stromindex(i)==1 ,
        odespannung = odespannung([1 end],:);
        odetime = odetime([1 end],:);
    end
    U_0 = odespannung(end,:);
    U_COCV = odespannung(:,1);
    U_RC = odespannung(:,2:1+numel(OCV.R_RC));
    U_C = odespannung(:,(2+numel(OCV.R_RC)):(1+numel(OCV.R_RC)+numel(OCV.C_ser)));
    U_Ladder = odespannung(:,(2+numel(OCV.R_RC)+numel(OCV.C_ser)):(1+numel(OCV.R_RC)+numel(OCV.C_ser)+numel(R_Ladder_OCV)));
    if isempty(U_C), U_C=0;end
    if isempty(U_RC), U_RC=0;end
    if isempty(U_Ladder), U_Ladder=0;end
    % Masche über Parallelgeschaltete OCV-Quelle und Stromteiler
    % des Eingangsstroms
    
    
    if isempty(R_Ladder_OCV)
        I_COCV = (sum(U_RC,2)+U_C-U_COCV)./(ROCV+OCV.R_ser)+...
            strom(i).*(OCV.R_ser./(ROCV+OCV.R_ser));
        I_Voigt = strom(i)-I_COCV;
        
    else
        U_CL = odespannung(:,2+numel(OCV.R_RC)+numel(OCV.C_ser):1+numel(OCV.R_RC)+numel(OCV.C_ser)+numel(R_Ladder_OCV));
        GL1 = 1/R_Ladder_OCV(1);
        GRser = 1/OCV.R_ser;
        GOCV = 1/ROCV;
        
        if OCV.R_ser == 0
            % Stromteiler für Stromquelle I
            I_Voigt = strom(i); %
            % Strom aus OCV-Spannungsquelle
            I_aus_OCV = U_COCV / (ROCV + 1/(GRser+GL1));
            I_Voigt = I_Voigt + I_aus_OCV ;
            
        else
            % Stromteiler für Stromquelle I
            I_Voigt = strom(i)*(GRser/(GRser+GL1+GOCV)); %
            % Strom aus OCV-Spannungsquelle
            I_aus_OCV = U_COCV / (ROCV + 1/(GRser+GL1));
            I_Voigt = I_Voigt + I_aus_OCV * GRser/(GRser+GL1) ;
        end
        % Strom aus Voigt-Netzwerk + Cser
        I_Voigt = I_Voigt - (sum(U_RC,2)+sum(U_C,2)) / (OCV.R_ser + 1/(GOCV+GL1));
        % Strom aus Ladder-Netzwerk
        I_aus_UCL1_durch_RL1 = U_CL(:,1) / (R_Ladder_OCV(1) + 1/(GRser+GOCV));
        if OCV.R_ser >0
            I_Voigt = I_Voigt + I_aus_UCL1_durch_RL1 * GRser/(GOCV+GRser);
        else
            I_Voigt = I_Voigt + I_aus_UCL1_durch_RL1;
        end
    end
    U(stromindex(i):stromindex(i+1)-1)=U(stromindex(i):stromindex(i+1)-1)+...
        sum(odespannung(1:end-1,2:1+numel(OCV.R_RC)+numel(OCV.C_ser)),2)+I_Voigt(1:end-1).*OCV.R_ser;
end
U(end)=sum(odespannung(end,2:1+numel(OCV.R_RC)+numel(OCV.C_ser)),2)+I_Voigt(end).*OCV.R_ser;

% U = [ U  zeros(size(t))];

function [u_dot] = dudt(t,u,I,OCV,ROCV,COCV,R_Ladder_OCV,C_Ladder_OCV)
% Achtung, COCV ist kein reales Element im Netzwerk. Es dient nur zur
% Berechnung der Spannung auf der OCV-Spannungsquelle.
u_dot = zeros(size(u));
U_COCV = u(1);
U_RC = u(2:1+numel(OCV.R_RC));
U_C = u(2+numel(OCV.R_RC):1+numel(OCV.R_RC)+numel(OCV.C_ser));

% I_COCV ist der Strom, der parallel zu den Warburgimpedanzen in die
% OCV-Spannungsquelle fließt
if isempty(R_Ladder_OCV)
    I_COCV = (sum(U_RC)+sum(U_C)-U_COCV)/(ROCV+OCV.R_ser)+I*(OCV.R_ser/(ROCV+OCV.R_ser));
    u_dot(1) = I/COCV;
    if numel(OCV.R_RC)>0
        u_dot(2:1+numel(OCV.R_RC))   = ((I-I_COCV)-U_RC./OCV.R_RC)./OCV.C_RC;
    end
    if numel(OCV.C_ser)>0 && abs(OCV.C_ser)<1e16
        u_dot(2+numel(OCV.R_RC):1+numel(OCV.R_RC)+numel(OCV.C_ser)) =  (I-I_COCV)./OCV.C_ser;
    end
else
    % Berechnung des Netzwerks mittels Helmholtz Superposition
    U_CL = u(2+numel(OCV.R_RC)+numel(OCV.C_ser):1+numel(OCV.R_RC)+numel(OCV.C_ser)+numel(R_Ladder_OCV));
    GL1 = 1/R_Ladder_OCV(1);
    if numel(R_Ladder_OCV) > 1; GL2 = 1/R_Ladder_OCV(2); else GL2 = 0; end;
    GRser = 1/OCV.R_ser;
    GOCV = 1/ROCV;
    
    % Stromteiler für Stromquelle I
    I_COCV = I*(GOCV/(GRser+GL1+GOCV)); %
    % Strom aus OCV-Spannungsquelle
    I_COCV = I_COCV - U_COCV / (ROCV + 1/(GRser+GL1));
    % Strom aus Voigt-Netzwerk + Cser
    I_aus_Voigt = (sum(U_RC)+sum(U_C)) / (OCV.R_ser + 1/(GOCV+GL1));
    I_COCV = I_COCV + I_aus_Voigt * GOCV/(GOCV+GL1);
    % Strom aus Ladder-Netzwerk
    I_aus_UCL1_durch_RL1 = U_CL(1) / (R_Ladder_OCV(1) + 1/(GRser+GOCV));
    I_COCV = I_COCV + I_aus_UCL1_durch_RL1 * GOCV/(GOCV+GRser);
    
    if OCV.R_ser == 0
        % Stromteiler für Stromquelle I
        I_Voigt = I; %
        % Strom aus OCV-Spannungsquelle
        I_aus_OCV = U_COCV / (ROCV + 1/(GRser+GL1));
        I_Voigt = I_Voigt + I_aus_OCV ;
        
    else
        % Stromteiler für Stromquelle I
        I_Voigt = I*(GRser/(GRser+GL1+GOCV)); %
        % Strom aus OCV-Spannungsquelle
        I_aus_OCV = U_COCV / (ROCV + 1/(GRser+GL1));
        I_Voigt = I_Voigt + I_aus_OCV * GRser/(GRser+GL1) ;
    end
    % Strom aus Voigt-Netzwerk + Cser
    I_Voigt = I_Voigt - (sum(U_RC)+sum(U_C)) / (OCV.R_ser + 1/(GOCV+GL1));
    % Strom aus Ladder-Netzwerk
    I_aus_UCL1_durch_RL1 = U_CL(1) / (R_Ladder_OCV(1) + 1/(GRser+GOCV));
    if OCV.R_ser == 0
        I_Voigt = I_Voigt + I_aus_UCL1_durch_RL1;
    else
        I_Voigt = I_Voigt + I_aus_UCL1_durch_RL1 * GRser/(GOCV+GRser);
    end
    I_Ladder = I - I_COCV-I_Voigt;
    
    
    u_dot(1) = I/COCV;
    if numel(OCV.R_RC)>0
        u_dot(2:1+numel(OCV.R_RC))   = (I_Voigt-U_RC./OCV.R_RC)./OCV.C_RC;
    end
    if numel(OCV.C_ser)>0 && abs(OCV.C_ser)<1e16
        u_dot(2+numel(OCV.R_RC):1+numel(OCV.R_RC)+numel(OCV.C_ser)) = I_Voigt./OCV.C_ser;
    end
    
    if numel(R_Ladder_OCV)>1
        u_dot(1+numel(OCV.R_RC)+numel(OCV.C_ser)+numel(R_Ladder_OCV)) = (U_CL(end-1)-U_CL(end)) / R_Ladder_OCV(end) / C_Ladder_OCV(end);
        for i = (numel(R_Ladder_OCV)-1):-1:2
            u_dot(1+numel(OCV.R_RC)+numel(OCV.C_ser)+i) = ((U_CL(i-1)-U_CL(i)) / R_Ladder_OCV(i) - (U_CL(i)-U_CL(i+1)) / R_Ladder_OCV(i+1))/C_Ladder_OCV(i);
        end
        u_dot(1+numel(OCV.R_RC)+numel(OCV.C_ser)+1) = (I_Ladder - (U_CL(1)-U_CL(2)) / R_Ladder_OCV(2)) / C_Ladder_OCV(1);
    elseif numel(R_Ladder_OCV)>0
        u_dot(1+numel(OCV.R_RC)+numel(OCV.C_ser)+numel(R_Ladder_OCV)) = I_Ladder / C_Ladder_OCV;
    end
    
    
    
    
end




% --- Executes on button press in PlotOCVButton.
function PlotOCVButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlotOCVButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% todo: Refit muss auch geplottet werden
global DRT_GUI
FarbenLaden
if ~sum(strcmp(fieldnames(handles),'Implementierung')) || isempty(handles.Implementierung) ||...
        ~sum(strcmp(fieldnames(handles.Implementierung),'OCV')) || isempty(handles.Implementierung.OCV)
    return
end
axes(handles.axes2)
hold off
plot(DRT_GUI.Messdaten.relax.zeit,DRT_GUI.Messdaten.relax.spannung ,'color',RWTHBlau,'DisplayName','Messung','LineWidth',2)
grid on
hold on

drawnow
ROCV = handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),'ROCV'),1),2};
COCV = handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),'COCV'),1),2};
OCV.n_Ladder = sum(cell2mat(regexp(handles.Implementierung.OCV(:,1),'OCV_RL\d')));
R_Ladder_OCV = zeros(1,OCV.n_Ladder);
C_Ladder_OCV = zeros(1,OCV.n_Ladder);

for i = 1:(OCV.n_Ladder)
    R_Ladder_OCV(1,i) = handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_RL' num2str(i)]),1),2};
    C_Ladder_OCV(1,i) = handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['OCV_CL' num2str(i)]),1),2};
end



Voigt.R_RC = [];
Voigt.C_RC = [];
Voigt.R_ser = 0;
Voigt.C_ser = [];
OCV.R_RC = [];
OCV.C_RC = [];
OCV.R_ser = 0;
OCV.C_ser = [];
for i = 1:numel(handles.Implementierung.Info)-1
    args = cell(1,numel(handles.Implementierung.Info{i}.inputs));
    argliste = '';
    for k = 1:numel(handles.Implementierung.Info{i}.inputs)
        ParNr = find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),handles.Implementierung.Table{i,k+4}));
        if isempty(ParNr)
            warning('Konnte Parameter aus Implementierung nicht finden. Implementierungsinfos werden reseted!')
            DRT_GUI.Fit=rmfield(DRT_GUI.Fit,'Implementierung');
            return
        end
        args{k} = DRT_GUI.Fit.Parameter(ParNr);
        if strcmp(handles.Implementierung.Table{i,2},'Re-Fit')
            args{k} = handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['ReFit_' handles.Implementierung.Table{i,k+4}]),1),2};
        end
        argliste = [argliste 'args{' num2str(k) '},' ];
    end
    argliste = argliste(1:end-1);
    if strcmp(handles.Implementierung.Table{i,1},'OCV_source')
        DeltaU = DRT_GUI.Messdaten.relax.spannung(end)-DRT_GUI.Messdaten.relax.spannung(1);
        Ladung = [0 cumsum(DRT_GUI.Messdaten.relax.strom(1:end-1) .* diff(DRT_GUI.Messdaten.relax.zeit))];
        C_OCV = Ladung(end) / DeltaU;
        
        if ismember('Funktionsname',fieldnames(handles.Implementierung.Info{i}))
            Z = CalculateESBeImpedance(handles.Implementierung.Info{i},DRT_GUI.Fit.omega,C_OCV);
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(handles.Implementierung.Info{i}.Funktionsname,C_OCV);
        elseif ismember('f',fieldnames(handles.Implementierung.Info{i}))
            Z = handles.Implementierung.Info{i}.Z(C_OCV,DRT_GUI.Fit.omega);
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = handles.Implementierung.Info{i}.f(C_OCV);
        end
    elseif isempty(argliste)
        if ismember('Funktionsname',fieldnames(handles.Implementierung.Info{i}))
            Z = CalculateESBeImpedance(handles.Implementierung.Info{i},DRT_GUI.Fit.omega);
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(handles.Implementierung.Info{i}.Funktionsname);
        elseif ismember('f',fieldnames(handles.Implementierung.Info{i}))
            Z =handles.Implementierung.Info{i}.Z(DRT_GUI.Fit.omega);
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = handles.Implementierung.Info{i}.f;
        end
    else
        if ismember('Funktionsname',fieldnames(handles.Implementierung.Info{i}))
            Z = CalculateESBeImpedance(handles.Implementierung.Info{i},DRT_GUI.Fit.omega,args{:});
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(handles.Implementierung.Info{i}.Funktionsname,args{:});
        elseif ismember('f',fieldnames(handles.Implementierung.Info{i}))
            eval(['Z=handles.Implementierung.Info{i}.Z(' argliste ',DRT_GUI.Fit.omega);'])
            eval(['[R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = handles.Implementierung.Info{i}.f(' argliste ');'])
        end
    end
    
    if ~isempty(regexp(handles.Implementierung.Table{i,2},'OCV\d'))
        OCV.R_RC = [OCV.R_RC ;R_RC'];
        OCV.C_RC = [OCV.C_RC ;C_RC'];
        if ~isempty(R_ser) , OCV.R_ser = OCV.R_ser + R_ser; end
        if ~isempty(C_ser) && abs(C_ser) < 1e16
            if isempty(OCV.C_ser) || abs(OCV.C_ser) > 1e16
                OCV.C_ser = C_ser;
            else
                OCV.C_ser = (OCV.C_ser .* C_ser)./(OCV.C_ser + C_ser);
            end
        end
    else
        Voigt.R_RC = [Voigt.R_RC ;R_RC'];
        Voigt.C_RC = [Voigt.C_RC ;C_RC'];
        if ~isempty(R_ser) , Voigt.R_ser = Voigt.R_ser + R_ser; end
        if ~isempty(C_ser) && abs(C_ser) < 1e16
            if isempty(Voigt.C_ser) || abs(Voigt.C_ser) > 1e16
                Voigt.C_ser = C_ser;
            else
                Voigt.C_ser = (Voigt.C_ser .* C_ser)./(Voigt.C_ser + C_ser);
            end
        end
    end
end

if (isempty(OCV.R_RC) && (isempty(OCV.C_ser) || abs(OCV.C_ser)>1e16) && OCV.R_ser ==0) && ...
        sum(cell2mat(regexp(handles.Implementierung.Table(:,2),'Re-Fit')))==0
    return,
end
stromindex = [1 1+ find(abs(diff(DRT_GUI.Messdaten.relax.strom)./diff(DRT_GUI.Messdaten.relax.zeit))>1)];

if stromindex(end) < numel(DRT_GUI.Messdaten.relax.strom),
    stromindex(end+1) = numel(DRT_GUI.Messdaten.relax.strom);
end

%    stromindex=(1:numel(DRT_GUI.Messdaten.relax.strom));
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
ModellSpannung = DRT_GUI.Messdaten.relax.strom .* Voigt.R_ser;
if ~(isempty(Voigt.C_ser) || abs(Voigt.C_ser) > 1e16)
    ModellSpannung =ModellSpannung +...
        [0 cumsum(diff(DRT_GUI.Messdaten.relax.zeit).*DRT_GUI.Messdaten.relax.strom(1:end-1)./Voigt.C_ser)];
end
%display(sprintf('Cserspannung: %f,   Cser: %f      As: %f', sum(diff(DRT_GUI.Messdaten.relax.zeit).*DRT_GUI.Messdaten.relax.strom(1:end-1)./Voigt.C_ser), Voigt.C_ser,sum(diff(DRT_GUI.Messdaten.relax.zeit).*DRT_GUI.Messdaten.relax.strom(1:end-1))));
U_RC = zeros(numel(DRT_GUI.Messdaten.relax.strom),numel(Voigt.R_RC));
for i = 1:numel(stromindex)-1
    if stromindex(i)==1
        U0 = zeros(size(Voigt.R_RC));
    else
        U0 = U_RC(stromindex(i),:);
    end
    Umax = strom(i).*Voigt.R_RC;
    t = DRT_GUI.Messdaten.relax.zeit(stromindex(i)+1:stromindex(i+1))-DRT_GUI.Messdaten.relax.zeit(stromindex(i));
    for k = 1:numel(Voigt.R_RC)
        if abs(U0(k)-Umax(k))<=0.0001
            U_RC(stromindex(i)+1:stromindex(i+1),k) = Umax(k);
        else
            U_RC(stromindex(i)+1:stromindex(i+1),k) = U0(k)+(Umax(k)-U0(k)).*(1-exp(-t./(Voigt.R_RC(k).*Voigt.C_RC(k))));
        end
    end
end
ModellSpannung = ModellSpannung + sum(U_RC,2)';

if OCV.n_Ladder>0 || ( isfinite(ROCV) )
    OCV_Korrigiert_Spannung = OCV_Spannung(ROCV,COCV,R_Ladder_OCV,C_Ladder_OCV,DRT_GUI.Messdaten.relax.zeit',OCV,strom,stromindex)';
else
    OCV_Korrigiert_Spannung = 0;
end


data.y = ModellSpannung+OCV_Korrigiert_Spannung+DRT_GUI.Messdaten.relax.spannung(1);
data.x = DRT_GUI.Messdaten.relax.zeit;
data = ReduceData(data);

handles.Implementierung.Sim.spannung = data.y;
handles.Implementierung.Sim.zeit = data.x;

data.x=DRT_GUI.Messdaten.relax.zeit;
data.y=DRT_GUI.Messdaten.relax.spannung;
data = ReduceData(data);
handles.Implementierung.Sim.spannung_orig = data.y;
handles.Implementierung.Sim.zeit_orig = data.x;

guidata(hObject,handles)

plot(DRT_GUI.Messdaten.relax.zeit,ModellSpannung+OCV_Korrigiert_Spannung+DRT_GUI.Messdaten.relax.spannung(1),'--','color',RWTHRot,'DisplayName','Simulation','LineWidth',2);
set(gca,'Ticklabelinterpreter','latex')
xlabel('Zeit in s','Interpreter','latex')
ylabel('Spannung in V','Interpreter','latex')

if OCV.n_Ladder>0 || ( isfinite(ROCV) )
    % Zunächst die resisitive und rein kapazitive Spannungsantwort
    % berechnen
    OrigDiffSpannung = DRT_GUI.Messdaten.relax.strom * OCV.R_ser;
    if ~(isempty(OCV.C_ser) || abs(OCV.C_ser) > 1e16)
        OrigDiffSpannung = OrigDiffSpannung + [0 cumsum(diff(DRT_GUI.Messdaten.relax.zeit).*DRT_GUI.Messdaten.relax.strom(1:end-1)./OCV.C_ser)];
    end
    U_RC = zeros(numel(DRT_GUI.Messdaten.relax.strom),numel(OCV.R_RC));
    for i = 1:numel(stromindex)-1
        if stromindex(i)==1
            U0 = zeros(size(OCV.R_RC));
        else
            U0 = U_RC(:,stromindex(i));
        end
        Umax = strom(i).*OCV.R_RC;
        t = DRT_GUI.Messdaten.relax.zeit(stromindex(i)+1:stromindex(i+1))-DRT_GUI.Messdaten.relax.zeit(stromindex(i));
        for k = 1:numel(OCV.R_RC)
            if abs(U0(k)-Umax(k))<=0.0001
                U_RC(k,stromindex(i)+1:stromindex(i+1)) = Umax(k);
            else
                U_RC(k,stromindex(i)+1:stromindex(i+1)) = U0(k)+(Umax(k)-U0(k)).*(1-exp(-t./(OCV.R_RC(k).*OCV.C_RC(k))));
            end
        end
        
    end
    % Spannungsantwort des reinen Voigt-Netzwerks ( RC-Glieder )
    % in origdiffspannung werden alle Elemente so benutzt, wie sie im EIS
    % gefittet wurden. OCV-Fitting ist nicht berücksichtigt
    OrigDiffSpannung = OrigDiffSpannung + sum(U_RC,1);
    plot(DRT_GUI.Messdaten.relax.zeit,ModellSpannung+OrigDiffSpannung+DRT_GUI.Messdaten.relax.spannung(1),'color',RWTHSchwarz,'DisplayName','Simulation ohne OCV','LineWidth',2);
else
    % todo: falls es ReFit gibt
    OrigDiffSpannung = 0;
end
legend('off')
h1=legend('show');
set(h1,'Location','SouthEast','Interpreter','latex')

guidata(hObject,handles)


% --- Executes on button press in UseForAllMeasurementsButton.
function UseForAllMeasurementsButton_Callback(hObject, eventdata, handles)
% hObject    handle to UseForAllMeasurementsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
DRT_GUI_orig = DRT_GUI;
try
    Change_Implementierung_inFolder(['output/' DRT_GUI.Testparameter.Batterie],DRT_GUI.Testparameter.Batterie,DRT_GUI.Fit.aktuell_Modell.Modellname,handles.Implementierung)
    display('Alle Messungen angepasst!')
catch
    warning('Fehler beim Übernehmen der Werte! Datenfile defekt?')
end
DRT_GUI = DRT_GUI_orig;
function Change_Implementierung_inFolder(Folder,ZellName,ModellName,Implementierung)
if Folder(end) == '/' || Folder(end) == '\'
    Folder = Folder(1:end-1);
end

FileList = dir([Folder '/*' ZellName '*.mat']);
for i = 1:numel(FileList)
    if ~strcmp(FileList(i).name(end-10:end),'_Modell.mat') && ~strcmp(FileList(i).name(end-15:end),'_modelexport.mat')
        display(['Modifiziere ' FileList(i).name]);
        
        load([Folder '/' FileList(i).name])
        if ~(exist('DRT_GUI','var')==1)
            warning('Die Datei %s konnte nicht geladen werden',[Folder '/' FileList(i).name])
            continue
        end
        if strcmp(DRT_GUI.Fit.aktuell_Modell.Modellname,ModellName)
            DRT_GUI.Fit.Implementierung.Table = Implementierung.Table;
            DRT_GUI.Fit.Implementierung.Info = Implementierung.Info;
            
            save([Folder '/' FileList(i).name],'DRT_GUI')
        end
        clear DRT_GUI
    end
end
FolderList = dir([Folder '/*']);
for i = 1:numel(FolderList)
    if FolderList(i).isdir && ~strcmp(FolderList(i).name,'.') && ~strcmp(FolderList(i).name,'..')
        Change_Implementierung_inFolder([Folder '/' FolderList(i).name],ZellName,ModellName,Implementierung)
    end
end



function PauseDchRatioTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to PauseDchRatioTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PauseDchRatioTextbox as text
%        str2double(get(hObject,'String')) returns contents of PauseDchRatioTextbox as a double
handles.Implementierung.Config.PauseDchRatio = str2double(get(hObject,'String'));
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function PauseDchRatioTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PauseDchRatioTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotNyquistButton.
function PlotNyquistButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlotNyquistButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
Z = 0;
Z_RC = 0;
for i = 1:numel(handles.Implementierung.Info)-1
    args = cell(1,numel(handles.Implementierung.Info{i}.inputs));
    argliste = '';
    for k = 1:numel(handles.Implementierung.Info{i}.inputs)
        ParNr = find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),handles.Implementierung.Table{i,k+4}));
        if isempty(ParNr)
            warning('Konnte Parameter aus Implementierung nicht finden. Implementierungsinfos werden reseted!')
            DRT_GUI.Fit=rmfield(DRT_GUI.Fit,'Implementierung');
            return
        end
        args{k} = DRT_GUI.Fit.Parameter(ParNr);
        if strcmp(handles.Implementierung.Table{i,2},'Re-Fit')
            args{k} = handles.Implementierung.OCV{find(strcmp(handles.Implementierung.OCV(:,1),['ReFit_' handles.Implementierung.Table{i,k+4}]),1),2};
        end
        argliste = [argliste 'args{' num2str(k) '},' ];
    end
    argliste = argliste(1:end-1);
    %     Z_neu = eval(['handles.Implementierung.Info{i}.Z(' argliste ',DRT_GUI.Fit.omega)']);
    %     figure
    %     plot(DRT_GUI.Fit.Zreal,DRT_GUI.Fit.Zimg,'ob');hold on;
    %     plot(real(Z_neu),imag(Z_neu),'xr');
    %     grid on; axis square; axis equal; set(gca,'ydir', 'reverse');
    %     xlabel('Re');ylabel('Im'); %title(Plot_Title,'Interpreter','none');
    %
    %     h1 = legend('Fitting','Implementierung','Location','NorthWest');
    %     set(h1,'Interpreter','none');
    %     axis equal
    %
    if strcmp(handles.Implementierung.Table{i,1},'OCV_source')
        
        DeltaU = DRT_GUI.Messdaten.relax.spannung(end)-DRT_GUI.Messdaten.relax.spannung(1);
        Ladung = [0 cumsum(DRT_GUI.Messdaten.relax.strom(1:end-1) .* diff(DRT_GUI.Messdaten.relax.zeit))];
        C_OCV = Ladung(end) / DeltaU;
        
        if ismember('Funktionsname',fieldnames(handles.Implementierung.Info{i}))
            Z = Z+CalculateESBeImpedance(handles.Implementierung.Info{i},DRT_GUI.Fit.omega,C_OCV);
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(handles.Implementierung.Info{i}.Funktionsname,C_OCV);
        elseif ismember('f',fieldnames(handles.Implementierung.Info{i}))
            Z = Z+handles.Implementierung.Info{i}.Z(C_OCV,DRT_GUI.Fit.omega);
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = handles.Implementierung.Info{i}.f(C_OCV);
        end
    elseif isempty(argliste)
        if ismember('Funktionsname',fieldnames(handles.Implementierung.Info{i}))
            Z = Z+CalculateESBeImpedance(handles.Implementierung.Info{i},DRT_GUI.Fit.omega);
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(handles.Implementierung.Info{i}.Funktionsname);
        elseif ismember('f',fieldnames(handles.Implementierung.Info{i}))
            Z =Z+handles.Implementierung.Info{i}.Z(DRT_GUI.Fit.omega);
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = handles.Implementierung.Info{i}.f;
        end
    else
        if ismember('Funktionsname',fieldnames(handles.Implementierung.Info{i}))
            Z = Z+ CalculateESBeImpedance(handles.Implementierung.Info{i},DRT_GUI.Fit.omega,args{:});
            [R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = RunLocalESBeFunction(handles.Implementierung.Info{i}.Funktionsname,args{:});
        elseif ismember('f',fieldnames(handles.Implementierung.Info{i}))
            eval(['Z=Z+handles.Implementierung.Info{i}.Z(' argliste ',DRT_GUI.Fit.omega);'])
            eval(['[R_RC, C_RC, C_ser, R_ser, R_Ladder, C_Ladder] = handles.Implementierung.Info{i}.f(' argliste ');'])
        end
    end
    if ~isempty(R_ser), Z_RC = Z_RC + R_ser;end
    if ~isempty(C_ser), Z_RC = Z_RC + 1./(1i.*DRT_GUI.Fit.omega.*C_ser);end
    for k = 1:numel(R_RC)
        Z_RC = Z_RC + R_RC(k)./(1+1i.*DRT_GUI.Fit.omega.*R_RC(k).*C_RC(k));
    end
end


FarbenLaden
if isempty(dir('export'))
    mkdir('export')
end
if isempty( dir(['export' '/' DRT_GUI.Testparameter.Batterie]))
    mkdir(['export' '/' DRT_GUI.Testparameter.Batterie])
end


figure('Name','Vgl. EIS-Relax','NumberTitle','off','UnitS','centimeters','Position',[0, 0, 25, 10])
subplot(2,5,[1:2 6:7])
plot(DRT_GUI.Fit.Zreal,DRT_GUI.Fit.Zimg,'o','color',RWTHBlau,'DisplayName','EIS-Modell','LineWidth',1,'MarkerSize',7);hold on;
plot(real(Z),imag(Z),'o','color',RWTHRot,'DisplayName','Zeitbereichsmodell','LineWidth',1,'MarkerSize',7);
% plot(real(Z_RC),imag(Z_RC),'x','color',RWTHOrange,'DisplayName','Implementierung','LineWidth',1,'MarkerSize',7);
plot(DRT_GUI.Fit.Zreal-real(Z),DRT_GUI.Fit.Zimg-imag(Z),':','color',RWTHSchwarz,'DisplayName','Differenz(EIS-Zeitbereich)','LineWidth',2,'MarkerSize',7)
grid on; axis square; axis equal; set(gca,'ydir', 'reverse');
xlabel('$\Re\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
ylabel('$\Im\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
h1 = legend('show','Location','NorthWest');
set(h1,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex')
axis equal
subplot(2,5,3:5)
semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Fit.Zreal,'-','color',RWTHBlau,'DisplayName','EIS-Modell','LineWidth',2,'MarkerSize',7);hold on;
semilogx(DRT_GUI.Fit.frequenz, real(Z),'--','color',RWTHRot,'DisplayName','Zeitbereichsmodell','LineWidth',2,'MarkerSize',7);
% semilogx(DRT_GUI.Fit.frequenz, real(Z_RC),'--','color',RWTHOrange,'DisplayName','Implementierung','LineWidth',2,'MarkerSize',7);
semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Fit.Zreal-real(Z),'--','color',RWTHSchwarz,'DisplayName','Differenz(EIS-Zeitbereich)','LineWidth',2,'MarkerSize',7)
set(gca,'xdir','reverse'),grid on, hold on
set(gca,'TickLabelInterpreter','latex')
h1 = legend('show','Location','NorthWest');
set(h1,'Interpreter','latex');
ylabel('$\Re\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
xlabel('$f$ in Hz','Interpreter','latex');
subplot(2,5,8:10)
semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Fit.Zimg,'-','color',RWTHBlau,'DisplayName','EIS-Modell','LineWidth',2,'MarkerSize',7);hold on;
semilogx(DRT_GUI.Fit.frequenz, imag(Z),'--','color',RWTHRot,'DisplayName','Zeitbereichsmodell','LineWidth',2,'MarkerSize',7);
% semilogx(DRT_GUI.Fit.frequenz, imag(Z_RC),'--','color',RWTHOrange,'DisplayName','Implementierung','LineWidth',2,'MarkerSize',7);
semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Fit.Zimg-imag(Z),'--','color',RWTHSchwarz,'DisplayName','Differenz(EIS-Zeitbereich)','LineWidth',2,'MarkerSize',7)
set(gca,'xdir','reverse'),grid on, hold on
set(gca,'ydir','reverse')
set(gca,'TickLabelInterpreter','latex')
ylabel('$\Im\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
xlabel('$f$ in Hz','Interpreter','latex');
savefig(['export/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie '_vgl_EIS_TDM_' ...
    DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_'...
    strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m') 'SOC'...
    '.fig'])


figure('Name','Diff. EIS-Relax','NumberTitle','off','UnitS','centimeters','Position',[0, 15, 25, 10])
subplot(2,5,[1:2 6:7])
% plot(DRT_GUI.Fit.Zreal,DRT_GUI.Fit.Zimg,'o','color',RWTHBlau,'DisplayName','EIS-Modell','LineWidth',1,'MarkerSize',7);hold on;
% plot(real(Z),imag(Z),'o','color',RWTHRot,'DisplayName','Zeitbereichsmodell','LineWidth',1,'MarkerSize',7);
% plot(real(Z_RC),imag(Z_RC),'x','color',RWTHOrange,'DisplayName','Implementierung','LineWidth',1,'MarkerSize',7);
plot(DRT_GUI.Messdaten.Zreal(DRT_GUI.Messdaten.aktiv==1)-real(Z),DRT_GUI.Messdaten.Zimg(DRT_GUI.Messdaten.aktiv==1)-imag(Z),'-','color',RWTHBlau,'DisplayName','Differenz(EIS-TDMFit)','LineWidth',2,'MarkerSize',7)
hold on
plot(DRT_GUI.Fit.Zreal-real(Z),DRT_GUI.Fit.Zimg-imag(Z),'--','color',RWTHDunkelgrau,'DisplayName','Differenz(EISFit-TDMFit)','LineWidth',2,'MarkerSize',7)
grid on; axis square; axis equal; set(gca,'ydir', 'reverse');
xlabel('$\Re\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
ylabel('$\Im\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
h1 = legend('show','Location','NorthWest');
set(h1,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex')
axis equal
subplot(2,5,3:5)
% semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Fit.Zreal,'-','color',RWTHBlau,'DisplayName','EIS-Modell','LineWidth',2,'MarkerSize',7);hold on;
% semilogx(DRT_GUI.Fit.frequenz, real(Z),'--','color',RWTHRot,'DisplayName','Zeitbereichsmodell','LineWidth',2,'MarkerSize',7);
% semilogx(DRT_GUI.Fit.frequenz, real(Z_RC),'--','color',RWTHOrange,'DisplayName','Implementierung','LineWidth',2,'MarkerSize',7);
semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Messdaten.Zreal(DRT_GUI.Messdaten.aktiv==1)-real(Z),'-','color',RWTHBlau,'DisplayName','Differenz(EIS-TDMFit)','LineWidth',2,'MarkerSize',7)
hold on
semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Fit.Zreal-real(Z),'--','color',RWTHDunkelgrau,'DisplayName','Differenz(EISFit-TDMFit)','LineWidth',2,'MarkerSize',7)
set(gca,'xdir','reverse'),grid on, hold on
set(gca,'TickLabelInterpreter','latex')
h1 = legend('show','Location','NorthWest');
set(h1,'Interpreter','latex');
ylabel('$\Re\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
xlabel('$f$ in Hz','Interpreter','latex');
subplot(2,5,8:10)
% semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Fit.Zimg,'-','color',RWTHBlau,'DisplayName','EIS-Modell','LineWidth',2,'MarkerSize',7);hold on;
% semilogx(DRT_GUI.Fit.frequenz, imag(Z),'--','color',RWTHRot,'DisplayName','Zeitbereichsmodell','LineWidth',2,'MarkerSize',7);
% semilogx(DRT_GUI.Fit.frequenz, imag(Z_RC),'--','color',RWTHOrange,'DisplayName','Implementierung','LineWidth',2,'MarkerSize',7);
semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Messdaten.Zimg(DRT_GUI.Messdaten.aktiv==1)-imag(Z),'-','color',RWTHBlau,'DisplayName','Differenz(EIS-TDMFit)','LineWidth',2,'MarkerSize',7)
hold on
semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Fit.Zimg-imag(Z),'--','color',RWTHDunkelgrau,'DisplayName','Differenz(EISFit-TDMFit)','LineWidth',2,'MarkerSize',7)

set(gca,'xdir','reverse'),grid on, hold on
set(gca,'ydir','reverse')
set(gca,'TickLabelInterpreter','latex')
ylabel('$\Im\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
xlabel('$f$ in Hz','Interpreter','latex');
savefig(['export/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie '_diff_EIS_TDM_' ...
    DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_'...
    strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m') 'SOC'...
    '.fig'])




figure('Name','Vgl. Fit-Implementierung','NumberTitle','off','UnitS','centimeters','Position',[25, 0, 25, 10])
subplot(2,5,[1:2 6:7])
plot(DRT_GUI.Fit.Zreal,DRT_GUI.Fit.Zimg,'o','color',RWTHBlau,'DisplayName','EIS-Modell','LineWidth',1,'MarkerSize',7);hold on;
plot(real(Z),imag(Z),'o','color',RWTHRot,'DisplayName','Zeitbereichsmodell','LineWidth',1,'MarkerSize',7);
 plot(real(Z_RC),imag(Z_RC),'x','color',RWTHSchwarz,'DisplayName','Implementierung','LineWidth',1,'MarkerSize',7);
grid on; axis square; axis equal; set(gca,'ydir', 'reverse');
xlabel('$\Re\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
ylabel('$\Im\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
h1 = legend('show','Location','NorthWest');
set(h1,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex')
axis equal,
subplot(2,5,3:5)
semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Fit.Zreal,'-','color',RWTHBlau,'DisplayName','EIS-Modell','LineWidth',2,'MarkerSize',7);hold on;
semilogx(DRT_GUI.Fit.frequenz, real(Z),'--','color',RWTHRot,'DisplayName','Zeitbereichsmodell','LineWidth',2,'MarkerSize',7);
semilogx(DRT_GUI.Fit.frequenz, real(Z_RC),'--','color',RWTHSchwarz,'DisplayName','Implementierung','LineWidth',2,'MarkerSize',7);
% semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Messdaten.Zreal-real(Z),':','color',RWTHSchwarz,'DisplayName','Differenz(EIS-Zeitbereich)','LineWidth',2,'MarkerSize',7)
set(gca,'xdir','reverse'),grid on, hold on
set(gca,'TickLabelInterpreter','latex')
h1 = legend('show','Location','NorthWest');
set(h1,'Interpreter','latex');
ylabel('$\Re\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
xlabel('$f$ in Hz','Interpreter','latex');
subplot(2,5,8:10)
semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Fit.Zimg,'-','color',RWTHBlau,'DisplayName','EIS-Modell','LineWidth',2,'MarkerSize',7);hold on;
semilogx(DRT_GUI.Fit.frequenz, imag(Z),'--','color',RWTHRot,'DisplayName','Zeitbereichsmodell','LineWidth',2,'MarkerSize',7);
semilogx(DRT_GUI.Fit.frequenz, imag(Z_RC),'--','color',RWTHSchwarz,'DisplayName','Implementierung','LineWidth',2,'MarkerSize',7);
% semilogx(DRT_GUI.Fit.frequenz, DRT_GUI.Messdaten.Zimg-imag(Z),':','color',RWTHSchwarz,'DisplayName','Differenz(EIS-Zeitbereich)','LineWidth',2,'MarkerSize',7)
set(gca,'xdir','reverse'),grid on, hold on
set(gca,'ydir','reverse')
set(gca,'TickLabelInterpreter','latex')
ylabel('$\Im\{\underline{Z}\}$ in $\Omega$','Interpreter','latex');
xlabel('$f$ in Hz','Interpreter','latex');
savefig(['export/' DRT_GUI.Testparameter.Batterie '/' DRT_GUI.Testparameter.Batterie '_vgl_Fit_Implementierung_' ...
    DRT_GUI.Testparameter.Zustand '_' strrep(num2str(DRT_GUI.Testparameter.Temperatur),'-','m') 'grad_'...
    strrep(num2str(DRT_GUI.Testparameter.SOC),'-','m') 'SOC'...
    '.fig'])


% --- Executes on button press in Relaxation_complete_CheckBox.
function Relaxation_complete_CheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to Relaxation_complete_CheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Relaxation_complete_CheckBox



function KettenleiterGliederEdit_Callback(hObject, eventdata, handles)
% hObject    handle to KettenleiterGliederEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KettenleiterGliederEdit as text
%        str2double(get(hObject,'String')) returns contents of KettenleiterGliederEdit as a double

% hier wird die Anzahl von R_Ladder_OCV und C_Ladder_OCV in der Tabelle angepasst.
global DRT_GUI

if ~sum(strcmp(fieldnames(handles),'Implementierung')) || isempty(handles.Implementierung) ,
    set(handles.KettenleiterGliederEdit,'String','0');
    errordlg('Bitte zuerst Implementierung auswählen!')
    set(hObject,'string','0')
end
if ~sum(strcmp(fieldnames(handles.Implementierung),'OCV')) || isempty(handles.Implementierung.OCV) || (isempty(cell2mat(regexp(handles.Implementierung.Table(:,2),'OCV\d', 'once'))) && isempty(cell2mat(regexp(handles.Implementierung.Table(:,2),'Re-Fit', 'once'))))
    DeltaU = DRT_GUI.Messdaten.relax.spannung(end)-DRT_GUI.Messdaten.relax.spannung(1);
    Ladung = [0 cumsum(DRT_GUI.Messdaten.relax.strom(1:end-1) .* diff(DRT_GUI.Messdaten.relax.zeit))];
    C_OCV = Ladung(end) / DeltaU;
    handles.Implementierung.OCV = {'ROCV',inf,false,-inf,inf;'COCV',C_OCV,false,-inf,inf;'UStart',DRT_GUI.Messdaten.relax.spannung(1),false,-inf,inf;'UEnde',DRT_GUI.Messdaten.relax.spannung(end),false,-inf,inf};
    set(handles.RelaxTable,'Data',handles.Implementierung.OCV)
end
if (~strcmp(get(hObject,'string'),'0') || get(handles.ParallelOCVcheckbox,'Value')) ...
        && isempty(cell2mat(regexp(handles.Implementierung.Table(:,2),'OCV\d', 'once')))
    set(handles.KettenleiterGliederEdit,'String','0');
    errordlg('Bitte zuerst bei Implementierungselementen die OCV-Elemente auswählen!')
    set(hObject,'string','0')
    set(handles.ParallelOCVcheckbox,'Value',0)
end
try
    Wert = str2num(get(hObject,'string'));
catch error_msg
    set(hObject,'string','0')
    errordlg(error_msg)
end
if isempty(Wert)|| (Wert<0)
    set(hObject,'string','0')
    Wert = 0;
    errordlg('Ungültiger Wert')
elseif Wert>3
    Wert = 3;
    set(hObject,'string','3')
    errordlg('maximal 3 Glieder des Kettenleiters')
end


if sum(cell2mat(regexp(handles.Implementierung.OCV(:,1),'OCV_RL\d'))) > Wert
    handles.Implementierung.OCV = handles.Implementierung.OCV(1:(4+Wert*2),:);
end
if size(handles.Implementierung.OCV,1)>(4+Wert*2)
    handles.Implementierung.OCV = handles.Implementierung.OCV(1:(4+Wert*2),:);
end

if sum(cell2mat(regexp(handles.Implementierung.OCV(:,1),'OCV_RL\d'))) < Wert
    for i = 1:Wert
        handles.Implementierung.OCV((4+2*i-1),:) = {['OCV_RL' num2str(i)],10^(-2),false,-inf,inf};
        handles.Implementierung.OCV((4+2*i),:)   = {['OCV_CL' num2str(i)],1,false,-inf,inf};
    end
end

if size(handles.Implementierung.OCV,2) == 2 % altes Format
    handles.Implementierung.OCV(:,3) = {false};
    handles.Implementierung.OCV(:,4) = {-inf};
    handles.Implementierung.OCV(:,5) = {inf};
end
%Startwerte für Re-Fit eintragen
n_p=5+2*Wert;
for i = find(~cellfun(@isempty,regexp(handles.Implementierung.Table(:,2),'Re-Fit')))'
    for k = 1:numel(handles.Implementierung.Info{i}.inputs)
        ParNr = find(strcmp(DRT_GUI.Fit.aktuell_Modell.P_Name(1,:),handles.Implementierung.Table{i,k+4}));
        
        if DRT_GUI.Fit.Parameter(ParNr)==0,
            handles.Implementierung.OCV(n_p,:) = {['ReFit_' handles.Implementierung.Table{i,k+4}],...
                DRT_GUI.Fit.Parameter(ParNr),false,0,inf};
        else
            handles.Implementierung.OCV(n_p,:) = {['ReFit_' handles.Implementierung.Table{i,k+4}],...
                DRT_GUI.Fit.Parameter(ParNr),false,DRT_GUI.Fit.Parameter(ParNr)*0.25,DRT_GUI.Fit.Parameter(ParNr)*4};
        end
        n_p = n_p+1;
    end
end



set(handles.RelaxTable,'Data',handles.Implementierung.OCV)

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function KettenleiterGliederEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KettenleiterGliederEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ParallelOCVcheckbox.
function ParallelOCVcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to ParallelOCVcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ParallelOCVcheckbox
KettenleiterGliederEdit_Callback(handles.KettenleiterGliederEdit, eventdata, handles)

% --- Executes during object deletion, before destroying properties.
function Relaxation_complete_CheckBox_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to Relaxation_complete_CheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ResetOCVFitButton.
function ResetOCVFitButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetOCVFitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata) && ismember('Indices',fieldnames(eventdata))
    eventdata.Indices = [1 2 ];
end
ImplementierungsTable_CellEditCallback(handles.ImplementierungsTable,eventdata,handles)
handles = guidata(hObject);
PlotOCVButton_Callback(handles.PlotOCVButton, [], handles)


% --- Executes on button press in stromloseMesspunkteCheckbox.
function stromloseMesspunkteCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to stromloseMesspunkteCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stromloseMesspunkteCheckbox


% --- Executes on button press in FitPlotZeichnenCheckbox.
function FitPlotZeichnenCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to FitPlotZeichnenCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FitPlotZeichnenCheckbox


% --- Executes on button press in CopyButton.
function CopyButton_Callback(hObject, eventdata, handles)
% hObject    handle to CopyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Implementierung_Copy
Implementierung_Copy = handles.Implementierung;

% --- Executes on button press in PasteButton.
function PasteButton_Callback(hObject, eventdata, handles)
% hObject    handle to PasteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Implementierung_Copy
if ~isempty(Implementierung_Copy)
    handles.Implementierung.Config = Implementierung_Copy.Config;
    set(handles.PauseDchRatioTextbox,'string',handles.Implementierung.Config.PauseDchRatio)
    handles.Implementierung.Table = Implementierung_Copy.Table;
    set(handles.ImplementierungsTable,'Data',handles.Implementierung.Table)
    guidata(hObject, handles);
    ResetOCVFitButton_Callback(handles.ResetOCVFitButton, eventdata, handles)
    handles = guidata(hObject);
    handles.Implementierung.OCV(5:end,:) = Implementierung_Copy.OCV(5:end,:);
    set(handles.RelaxTable,'Data',handles.Implementierung.OCV)
    guidata(hObject, handles);
    
    
end

function y = linFunction(x1,y1,x2,y2,x)
m = (y2-y1)/(x2-x1);
n = y1 - m*x1;
y = m*x + n;

function data = ReduceData(data)
resolution = 0.0001;

lengthBefore = length(data.x);

deleteList = [];
lastUndeleted = 1;
for i = 2:length(data.x)-1;
    y = linFunction(data.x(lastUndeleted), data.y(lastUndeleted), data.x(i+1), data.y(i+1), data.x(lastUndeleted+1:i));
    if(max(abs(y - data.y(lastUndeleted+1:i))) < resolution)
        deleteList = [deleteList; i];
    else
        lastUndeleted = i;
    end;
end;

data.x(deleteList) = [];
data.y(deleteList) = [];

lengthAfter = length(data.x);

if (lengthAfter < lengthBefore)
    disp([num2str(lengthBefore) ' Datenpunkte vorher, ' num2str(lengthAfter) ' Datenpunkte nachher. Reduktion um ' num2str(100-100*lengthAfter/lengthBefore,3) ' %']);
end;

function run_DRT_GUI_save()
[functionhandle handles] =FittingGUI;
FittingGUI('SpeichernButton_Callback',handles.SpeichernButton,[],handles)
