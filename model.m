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

function varargout = model(varargin)
% MODEL MATLAB code for model.fig
%      MODEL, by itself, creates a new MODEL or raises the existing
%      singleton*.
%
%      H = MODEL returns the handle to a new MODEL or the handle to
%      the existing singleton*.
%
%      MODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODEL.M with the given input arguments.
%
%      MODEL('Property','Value',...) creates a new MODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before model_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to model_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help model

% Last Modified by GUIDE v2.5 21-Nov-2016 09:34:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @model_OpeningFcn, ...
                   'gui_OutputFcn',  @model_OutputFcn, ...
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


% --- Executes just before model is made visible.
function model_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to model (see VARARGIN)

% Choose default command line output for model
handles.output = hObject;
handles.aktualisieren_button_Callback = @aktualisieren_button_Callback;
handles.ReloadButton_Callback = @ReloadButton_Callback;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes model wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = model_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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
            Folders = [Folders;f(i).name];
        end
    end
end
set(handles.ZustandPopup,'string',Folders);
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
global ModelDaten
gui_objects = fieldnames(handles);
Check_objects = gui_objects(find(~cellfun(@isempty,strfind(gui_objects,'_Check'))));
T_Check = Check_objects(find(~cellfun(@isempty,strfind(Check_objects,'T'))));
SOC_Check = Check_objects(find(~cellfun(@isempty,strfind(Check_objects,'SOC'))));
for i = 1:numel(Check_objects)
    set(handles.(Check_objects{i}),'string','')
    set(handles.(Check_objects{i}),'value',0)
    set(handles.(Check_objects{i}),'visible','off')
end
Batterien = get(handles.BatterieNamePopup,'string');
Zustaende = get(handles.ZustandPopup,'string');
if get(handles.ZustandPopup,'Value') == 1 && ~isempty(DRT_GUI) && ...
 sum(ismember(fieldnames(DRT_GUI),'Testparameter')) && ~isempty(DRT_GUI.Testparameter) &&...
 sum(ismember(fieldnames(DRT_GUI.Testparameter),'Zustand')) && ~isempty(DRT_GUI.Testparameter.Zustand) 
    if ~isempty(find(ismember(Zustaende,DRT_GUI.Testparameter.Zustand)))
        set(handles.ZustandPopup,'Value',find(ismember(Zustaende,DRT_GUI.Testparameter.Zustand)))
    end
end

Folders = {};
if get(handles.ZustandPopup,'Value') > 1
    f = dir(['output/' Batterien{get(handles.BatterieNamePopup,'Value')} '/'  Zustaende{get(handles.ZustandPopup,'Value')} '/*']);
    for i = 1:numel(f)
        if ~strcmp(f(i).name,'.') && ~strcmp(f(i).name,'..') && f(i).isdir 
            Folders = [Folders;f(i).name];
        end
    end
end
Temperaturen = zeros(size(Folders));
SOCs = [];
for i = 1:numel(Folders)
    Temperaturen(i) = str2num(strrep(strrep(Folders{i},'grad',''),'m','-'));
    SOCFiles = {};
    f = dir(['output/' Batterien{get(handles.BatterieNamePopup,'Value')} '/'  Zustaende{get(handles.ZustandPopup,'Value')} '/' Folders{i} '/*_*SOC_Modell.mat']);
    for j = 1:numel(f)
        if ~strcmp(f(j).name,'.') && ~strcmp(f(j).name,'..') && ~f(j).isdir 
            SOCFiles = [SOCFiles;strrep(strrep(strrep(strrep(strrep(f(j).name,Folders{i},''),Batterien{get(handles.BatterieNamePopup,'Value')},''),Zustaende{get(handles.ZustandPopup,'Value')},''),'_',''),'Modell.mat','')];
        end
    end
    for j = 1:numel(SOCFiles)
        if ~sum(find(SOCs == str2num(strrep(strrep(SOCFiles{j},'SOC',''),'m','-'))))
            SOCs = [SOCs ; str2num(strrep(strrep(SOCFiles{j},'SOC',''),'m','-'))];
        end
            
    end    
end
Temperaturen = sort(Temperaturen,1);
SOCs = sort(SOCs,1);
Data = cell(size(SOCs,1),2);
Data(:,1) = num2cell(SOCs);
Data(:,2)  = {true};
set(handles.SOCTable,'Data',Data )

Data = cell(size(Temperaturen,1),2);
Data(:,1) = num2cell(Temperaturen);
Data(:,2)  = {true};
set(handles.TemperaturTable,'Data',Data )


ReloadButton_Callback(handles.ReloadButton, eventdata, handles)

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


% --- Executes on button press in aktualisieren_button.
function aktualisieren_button_Callback(hObject, eventdata, handles)
% hObject    handle to aktualisieren_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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



% --- Executes on selection change in ModellnamePopup.
function ModellnamePopup_Callback(hObject, eventdata, handles)
% hObject    handle to ModellnamePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ModellnamePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ModellnamePopup
global ModelDaten
gui_objects = fieldnames(handles);
Par_Radio = gui_objects(find(~cellfun(@isempty,strfind(gui_objects,'Par')) & ~cellfun(@isempty,strfind(gui_objects,'Radio'))));
for i = 1:numel(Par_Radio)
    set(handles.(Par_Radio{i}),'string','')
    set(handles.(Par_Radio{i}),'visible','off')
end
Modellname = get(handles.ModellnamePopup,'string');
Modellname = Modellname{get(handles.ModellnamePopup,'value')};
Modell = [];
for i = 1:numel(ModelDaten.Model)
    if ~isempty( ModelDaten.Model{i})
        if sum(ismember(fieldnames(ModelDaten.Model{i}),'Fit')) && ~isempty(ModelDaten.Model{i}.Fit)
            if strcmp(Modellname,ModelDaten.Model{i}.Fit.Modell.Modellname)
                Modell = ModelDaten.Model{i}.Fit.Modell;
                break
            end
        end
        
    end
end
if isempty(Modell),return,end
for i = 1:size(Modell.P_Name,2)
    set(handles.(['Par' num2str(i) 'Radio']),'string',Modell.P_Name(1,i));
    set(handles.(['Par' num2str(i) 'Radio']),'visible','on');
end



ParameterPanel_SelectionChangeFcn(handles.ParameterPanel, [], handles)

% --- Executes during object creation, after setting all properties.
function ModellnamePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModellnamePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in FrequenzbereichPopup.
function FrequenzbereichPopup_Callback(hObject, eventdata, handles)
% hObject    handle to FrequenzbereichPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FrequenzbereichPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FrequenzbereichPopup


% --- Executes during object creation, after setting all properties.
function FrequenzbereichPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrequenzbereichPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in FrequenzbereichPanel.
function FrequenzbereichPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in FrequenzbereichPanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ReloadButton.
function ReloadButton_Callback(hObject, eventdata, handles)
% hObject    handle to ReloadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ModelDaten
gui_objects = fieldnames(handles);
Batterien = get(handles.BatterieNamePopup,'string');
Zustaende = get(handles.ZustandPopup,'string');
if get(handles.BatterieNamePopup,'Value') == 1 || get(handles.ZustandPopup,'Value') == 1, return; end
TemperaturData = get(handles.TemperaturTable,'Data');
ModelDaten.T=cell2mat(TemperaturData(:,1));
ModelDaten.T = ModelDaten.T(cell2mat(TemperaturData(:,2)));
ModelDaten.T = sort(ModelDaten.T,2);

SOCData = get(handles.SOCTable,'Data');
ModelDaten.SOC=cell2mat(SOCData(:,1));
ModelDaten.SOC = ModelDaten.SOC(cell2mat(SOCData(:,2)));
ModelDaten.SOC = sort(ModelDaten.SOC,2);


ModelDaten.Model = cell(numel(ModelDaten.T),numel(ModelDaten.SOC));

for i = 1:numel(ModelDaten.T)
    for j = 1:numel(ModelDaten.SOC)
        TString = [strrep(num2str(ModelDaten.T(i)),'-','m') 'grad'];
        SOCString = [strrep(num2str(ModelDaten.SOC(j)),'-','m') 'SOC'];
        
        f = dir(['output/' Batterien{get(handles.BatterieNamePopup,'Value')} '/'  Zustaende{get(handles.ZustandPopup,'Value')} '/' TString '/*_' SOCString '_Modell.mat']);
        if ~isempty(f)
            ModelDaten.Model{i,j} = load(['output/' Batterien{get(handles.BatterieNamePopup,'Value')} '/'  Zustaende{get(handles.ZustandPopup,'Value')} '/' TString '/' f.name]);
        end
    end
end
if isempty(ModelDaten) || ~sum(ismember(fieldnames(ModelDaten),'Model')), return,end
ModellnameStrings = {};
for i = 1:numel(ModelDaten.Model)
    if ~isempty( ModelDaten.Model{i})
        if sum(ismember(fieldnames(ModelDaten.Model{i}),'Fit')) && ~isempty(ModelDaten.Model{i}.Fit)
            if ~sum(ismember(ModellnameStrings,ModelDaten.Model{i}.Fit.Modell.Modellname))
                ModellnameStrings = [ ModellnameStrings ; ModelDaten.Model{i}.Fit.Modell.Modellname ];
            end
        end
        
    end
end
alter_ModellName = get(handles.ModellnamePopup,'string');
if ~isempty(alter_ModellName) , alter_ModellName = alter_ModellName{get(handles.ModellnamePopup,'value')};end
modellindex = find(ismember(ModellnameStrings,alter_ModellName));
if isempty(modellindex),modellindex=1;end
set(handles.ModellnamePopup,'value',modellindex)
set(handles.ModellnamePopup,'string',ModellnameStrings)
ModellnamePopup_Callback(handles.ModellnamePopup,[],handles);

% --- Executes when selected object is changed in ParameterPanel.
function ParameterPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in ParameterPanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global ModelDaten
gui_objects = fieldnames(handles);
Par_Radio = gui_objects(find(~cellfun(@isempty,strfind(gui_objects,'Par')) & ~cellfun(@isempty,strfind(gui_objects,'Radio'))));
ModelName = get(handles.ModellnamePopup,'string');
ModelName =  ModelName{get(handles.ModellnamePopup,'value')};
if get(handles.spline_check,'value')
    methode = 'spline';
else
    methode =  'linear';
end
for i = 1:numel(Par_Radio)
    if get(handles.(Par_Radio{i}),'value')
        if strcmp(get(handles.(Par_Radio{i}),'visible'),'off')
            set(handles.('Par1Radio'),'value',1)
            set(handles.(Par_Radio{i}),'value',0)
            ParNummer = find(~cellfun(@isempty,strfind(gui_objects,'Par1Radio')));
            ModelDaten.ParName = get(handles.('Par1Radio'),'string');
            
        else
            ParNummer = i;
            ModelDaten.ParName=get(handles.(Par_Radio{i}),'string');
        end
        break
        
    end
end
ModelDaten.Parameter = NaN(numel(ModelDaten.T),numel(ModelDaten.SOC));

for i = find(~cellfun(@isempty,ModelDaten.Model(:)))'
    if sum(ismember(fieldnames(ModelDaten.Model{i}),'Fit')) && ~isempty(ModelDaten.Model{i}.Fit) && ...
        strcmp(ModelDaten.Model{i}.Fit.Modell.Modellname,ModelName) && ( ( sum(ismember(fieldnames(ModelDaten.Model{i}.Fit),'gueltig')) && ModelDaten.Model{i}.Fit.gueltig ) || get(handles.ungueltige_check,'value'))
        ParIndex = find(ismember(ModelDaten.Model{i}.Fit.Modell.P_Name(1,:),ModelDaten.ParName));
        if ~isempty(ParIndex)
            ModelDaten.Parameter(i) = ModelDaten.Model{i}.Fit.Parameter(ParIndex);
        end
        
    end 
end

colors = hsv(numel(ModelDaten.T));
axes(handles.axes1)
hold off
for i =1:numel(ModelDaten.T)
    plot(ModelDaten.SOC',ModelDaten.Parameter(i,:)','o','Color',colors(i,:))
    hold on
end
grid on
legend(num2str(ModelDaten.T))
for i =1:numel(ModelDaten.T)
    if numel(find(~isnan(ModelDaten.Parameter(i,:))))>1
        x_hd = [min(ModelDaten.SOC(~isnan(ModelDaten.Parameter(i,:)))):1:max(ModelDaten.SOC(~isnan(ModelDaten.Parameter(i,:))))];
        if get(handles.extrapolieren_check,'value'), x_hd = [0:1:min(x_hd) x_hd max(x_hd):1:100];end
        y_hd = interp1(ModelDaten.SOC(~isnan(ModelDaten.Parameter(i,:))),ModelDaten.Parameter(i,~isnan(ModelDaten.Parameter(i,:))),x_hd,methode,'extrap');
        plot(x_hd',y_hd,'Color',colors(i,:))
    end
end

if numel(ModelDaten.T)>1
    axes(handles.axes2)
    hold off

    SOCs = eval(['[' get(handles.SOCText,'string') ']' ]);
    Values = nan(numel(ModelDaten.T),numel(SOCs));
    colors = hsv(numel(SOCs));
    for i = 1:numel(ModelDaten.T)
        if numel(find(~isnan(ModelDaten.Parameter(i,:))))>1
            Values(i,:) = interp1(ModelDaten.SOC(~isnan(ModelDaten.Parameter(i,:))),ModelDaten.Parameter(i,~isnan(ModelDaten.Parameter(i,:))),SOCs,methode,'extrap');
        end
    end
    for i = 1:numel(SOCs)
        if get(handles.ArrheniusCheckbox,'value')
            semilogy(1./(ModelDaten.T+273.15),Values(:,i),'o','Color',colors(i,:))
        else
            plot(ModelDaten.T,Values(:,i),'o','Color',colors(i,:))
        end
        hold on
    end
    for i = 1:numel(SOCs)
        if numel(find(~isnan(Values(:,i))))>1
            if get(handles.ArrheniusCheckbox,'value')
                x_hd = min(ModelDaten.T):1:max(ModelDaten.T);
                y_hd = exp(interp1(1./(ModelDaten.T+273.15),log(Values(:,i)),1./(x_hd'+273.15),methode));    
                semilogy(1./(x_hd'+273.15),y_hd,'Color',colors(i,:))
            else
                x_hd = min(ModelDaten.T):1:max(ModelDaten.T);
                y_hd = interp1(ModelDaten.T,Values(:,i),x_hd,methode);    
                plot(x_hd',y_hd,'Color',colors(i,:))
            end
        end
    end
    legend(num2str(SOCs'))
    %plot(repmat(ModelDaten.T',[numel(ModelDaten.SOC) 1])',ModelDaten.Parameter,'bo')
    grid on
end



% --- Executes on button press in allSOCButton.
function allSOCButton_Callback(hObject, eventdata, handles)
% hObject    handle to allSOCButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Batterien = get(handles.BatterieNamePopup,'string');
Zustaende = get(handles.ZustandPopup,'string');
if get(handles.BatterieNamePopup,'Value') == 1 || get(handles.ZustandPopup,'Value') == 1, return; end

SOCData = get(handles.SOCTable,'Data');
SOCData(:,2) = {true};
set(handles.SOCTable,'Data',SOCData);

% --- Executes on button press in noneSOCButton.
function noneSOCButton_Callback(hObject, eventdata, handles)
% hObject    handle to noneSOCButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Batterien = get(handles.BatterieNamePopup,'string');
Zustaende = get(handles.ZustandPopup,'string');
if get(handles.BatterieNamePopup,'Value') == 1 || get(handles.ZustandPopup,'Value') == 1, return; end

SOCData = get(handles.SOCTable,'Data');
SOCData(:,2) = {false};
set(handles.SOCTable,'Data',SOCData);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in spline_check.
function spline_check_Callback(hObject, eventdata, handles)
% hObject    handle to spline_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of spline_check
ParameterPanel_SelectionChangeFcn(handles.ParameterPanel,[],handles)

% --- Executes on button press in ungueltige_check.
function ungueltige_check_Callback(hObject, eventdata, handles)
% hObject    handle to ungueltige_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ungueltige_check
ParameterPanel_SelectionChangeFcn(handles.ParameterPanel,[],handles)

% --- Executes on button press in extrapolieren_check.
function extrapolieren_check_Callback(hObject, eventdata, handles)
% hObject    handle to extrapolieren_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ParameterPanel_SelectionChangeFcn(handles.ParameterPanel,[],handles)
% Hint: get(hObject,'Value') returns toggle state of extrapolieren_check



function SOCText_Callback(hObject, eventdata, handles)
% hObject    handle to SOCText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SOCText as text
%        str2double(get(hObject,'String')) returns contents of SOCText as a double
ParameterPanel_SelectionChangeFcn(handles.ParameterPanel,[],handles)


% --- Executes during object creation, after setting all properties.
function SOCText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SOCText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% This function is used to create a Fit struct that contains all Fitting results
function Fit = CreateExport(SOC, SplineInterpolation)
global ModelDaten
Fit={};


for i = find(~cellfun(@isempty,ModelDaten.Model(:)))'
    [T_i,SOC_i] = ind2sub(size(ModelDaten.Model),i);
    
    if ~isempty(ModelDaten.Model{i}.Fit) && sum(ismember(fieldnames(ModelDaten.Model{i}),'Fit')) && sum(ismember(fieldnames(ModelDaten.Model{i}.Fit),'gueltig')) && ModelDaten.Model{i}.Fit.gueltig
        if isempty(Fit) || ~sum(ismember(Fit(:,1),ModelDaten.Model{i}.Fit.Modell.Modellname))
            Fit = [Fit ; ModelDaten.Model{i}.Fit.Modell.ModellCell {ModelDaten.Model{i}.Fit.Modell.P_Name(1,:)} {ModelDaten.T} {reshape(ModelDaten.SOC,[1 numel(ModelDaten.SOC)])} {nan(numel(ModelDaten.T), numel(ModelDaten.SOC), numel(ModelDaten.Model{i}.Fit.Parameter))} {ModelDaten.T} {SOC} {nan(numel(ModelDaten.T), numel(SOC), numel(ModelDaten.Model{i}.Fit.Parameter))}];
            if iscell(Fit{size(Fit,1),4}), Fit{size(Fit,1),4}=cell2mat(Fit{size(Fit,1),4});end
            if iscell(Fit{size(Fit,1),5}), Fit{size(Fit,1),5}=cell2mat(Fit{size(Fit,1),5});end
            if iscell(Fit{size(Fit,1),6}), Fit{size(Fit,1),6}=cell2mat(Fit{size(Fit,1),6});end
            if iscell(Fit{size(Fit,1),7}), Fit{size(Fit,1),7}=logical(cell2mat(Fit{size(Fit,1),7}));end
        end
        Fit_index = find(ismember(Fit(:,1),ModelDaten.Model{i}.Fit.Modell.Modellname));
        for i_p = 1:numel(Fit{Fit_index,11}(T_i,SOC_i,:))
            ParName = Fit{8}(i_p);
            ParNameIndex = find( strcmp(ModelDaten.Model{i}.Fit.Modell.P_Name(1,:) , ParName),1);
            if  isempty(ParNameIndex) , continue , end
            Fit{Fit_index,11}(T_i,SOC_i,i_p) = ModelDaten.Model{i}.Fit.Parameter(ParNameIndex);
            if ModelDaten.Model{i}.Fit.Parameter_min(ParNameIndex)<Fit{Fit_index,5}(i_p)
                Fit{Fit_index,5}(i_p)=ModelDaten.Model{i}.Fit.Parameter_min(ParNameIndex);
            end
            if ModelDaten.Model{i}.Fit.Parameter_max(ParNameIndex)>Fit{Fit_index,6}(i_p)
                Fit{Fit_index,6}(i_p)=ModelDaten.Model{i}.Fit.Parameter_max(ParNameIndex);
            end
        end
        
    end
    
end
Fit = cell2struct(Fit,{'name','formel','P_name_string','P_init','P_min','P_max','P_fix','P_namen','T_mess','SOC_mess','P_fit','T_lookup','SOC_lookup','P_lookup'},2);
for i = 1:numel(Fit)
    min_SOC = Fit(i).SOC_mess(find(sum(isnan(Fit(i).P_fit(:,:,1)),1)>0,1,'first'));
    max_SOC = Fit(i).SOC_mess(find(sum(isnan(Fit(i).P_fit(:,:,1)),1)>0,1,'last'));
    %Fit(i).SOC_lookup = SOC(find(SOC<=min_SOC,1,'last')):5:SOC(find(SOC>=max_SOC,1,'first'));
    Fit(i).T_lookup = [Fit(i).T_mess(sum(~isnan(Fit(i).P_fit(:,:,1)),2)>0)];
    Fit(i).P_lookup = nan(numel(Fit(i).T_lookup)+1,numel(Fit(i).SOC_lookup),size(Fit(i).P_fit,3));
    for T_i = 1:numel(Fit(i).T_lookup)
        T_index = find(Fit(i).T_mess == Fit(i).T_lookup(T_i));
        for P_i = 1:size(Fit(i).P_fit,3)
            SOC_index = find(~isnan(Fit(i).P_fit(T_index,:,P_i)));
            if ~isempty(SOC_index)
                Fit(i).P_lookup(T_i,:,P_i) = interp1(Fit(i).SOC_mess(SOC_index),Fit(i).P_fit(T_index,SOC_index,P_i),Fit(i).SOC_lookup,'linear','extrap');
                if SplineInterpolation
                    if license('checkout', 'Curve_Fitting_Toolbox')
                        [~, Fit(i).P_lookup(T_i,:,P_i)] = spaps(Fit(i).SOC_lookup, Fit(i).P_lookup(T_i,:,P_i), 1e-11);
                    else
                        %% TODO
                        % keep it linear until then
                    end
                end
                Fit(i).P_lookup(T_i,Fit(i).P_lookup(T_i,:,P_i)<Fit(i).P_min(P_i),P_i) = Fit(i).P_min(P_i);
                Fit(i).P_lookup(T_i,Fit(i).P_lookup(T_i,:,P_i)>Fit(i).P_max(P_i),P_i) = Fit(i).P_max(P_i);
            end
        end
    end
    if numel(find(isnan(Fit(i).P_lookup(:)))) == numel(Fit(i).P_lookup(:)) , continue,end
    
    Fit(i).T_lookup = [Fit(i).T_lookup ;135];
    for P_i = 1:size(Fit(i).P_fit,3)
        for SOC_i = 1:numel(Fit(i).SOC_lookup)
            if numel(Fit(i).T_lookup(1:end-1)) ==1
                Fit(i).P_lookup(end,SOC_i,P_i) = Fit(i).P_lookup(1:end-1,SOC_i,P_i);
            else
                Fit(i).P_lookup(end,SOC_i,P_i) = interp1(Fit(i).T_lookup(1:end-1),Fit(i).P_lookup(1:end-1,SOC_i,P_i),Fit(i).T_lookup(end),'linear','extrap');
            end
        end
        Fit(i).P_lookup(end,Fit(i).P_lookup(end,:,P_i)<Fit(i).P_min(P_i),P_i) = Fit(i).P_min(P_i);
        Fit(i).P_lookup(end,Fit(i).P_lookup(end,:,P_i)>Fit(i).P_max(P_i),P_i) = Fit(i).P_max(P_i);
    end
end


% --- Executes on button press in export_lookups_button.
function export_Lookups_button_Callback(hObject, eventdata, handles)
% hObject    handle to export_lookups_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
export_FrameworkParameterSet_button_Callback(hObject, eventdata, handles)
global ModelDaten
Batterien = get(handles.BatterieNamePopup,'string');
Zustaende = get(handles.ZustandPopup,'string');
if get(handles.BatterieNamePopup,'Value') == 1 || get(handles.ZustandPopup,'Value') == 1, return; end
if isempty(ModelDaten) || ~sum(ismember(fieldnames(ModelDaten),'Model')) || isempty(ModelDaten.Model), return, end
SOC = [-5; ModelDaten.SOC; 105]';
Fit=CreateExport(SOC, 0);

filename = ['output/' Batterien{get(handles.BatterieNamePopup,'Value')} '/'  Zustaende{get(handles.ZustandPopup,'Value')} '/'  Batterien{get(handles.BatterieNamePopup,'Value')} '_' Zustaende{get(handles.ZustandPopup,'Value')} ];
save( [filename '_modelexport.mat'],'Fit');
if ~isempty(dir([filename '_modelexport.xls']))
    delete([filename '_modelexport.xls']);
end

xlsCell = {};
maxCols=max(arrayfun(@(x) size(x.SOC_lookup,2),Fit))+1;
for i = 1:numel(Fit)
    if numel(find(isnan(Fit(i).P_lookup(:)))) == numel(Fit(i).P_lookup(:)) , continue,end
    
    xlsCell = [xlsCell ; Fit(i).name cell(1,maxCols-1)];
    for j = 1:numel(Fit(i).P_namen)
        xlsCell = [xlsCell ; Fit(i).P_namen(j) cell(1,maxCols-1)];
        xlsCell = [xlsCell ; [cell(1,1) num2cell(Fit(i).SOC_lookup) cell(1,maxCols-1-numel(Fit(i).SOC_lookup))]];
        xlsCell = [xlsCell ; num2cell(Fit(i).T_lookup) num2cell(Fit(i).P_lookup(:,:,j)) cell(numel(Fit(i).T_lookup),maxCols-1-numel(Fit(i).SOC_lookup))];
    end
end
xlswrite([filename '_modelexport.xls'],xlsCell,'Fit')
display(sprintf('In Datei %s geschrieben',[filename '_modelexport.xls']));


function export_FrameworkParameterSet_button_Callback(hObject, eventdata, handles)
% hObject    handle to export_lookups_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ModelDaten
Batterien = get(handles.BatterieNamePopup,'string');
Zustaende = get(handles.ZustandPopup,'string');
if get(handles.BatterieNamePopup,'Value') == 1 || get(handles.ZustandPopup,'Value') == 1, return; end
if isempty(ModelDaten) || ~sum(ismember(fieldnames(ModelDaten),'Model')) || isempty(ModelDaten.Model), return, end
SOC = [-5; ModelDaten.SOC; 105]';
doSpline = get(handles.spline_check,'value');
Fit=CreateExport(SOC, doSpline );
Modellnamenliste = get(handles.ModellnamePopup,'string');
Modellname = Modellnamenliste(get(handles.ModellnamePopup,'Value'));
if strcmp( Modellname, 'LiIon4')
    xml = sprintf(CreateLilon4(Fit));
    try
        x = fopen('framework.xml', 'w');
        fwrite(x , xml)
        fclose(x);
    catch
        fclose(x);
    end
        
    
else
    error('Unknow Model');
end



% --- Executes on button press in fig1_export_button.
function fig1_export_button_Callback(hObject, eventdata, handles)
% hObject    handle to fig1_export_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
[a,b,c,legende] = legend; 
legendPosition = get(a,'Location');
x_label =  'State of charge in %';
y_label =  get(get(gca,'ylabel'),'string');
xlimits = xlim;
ylimits = ylim;
figure;
copyobj(get(handles.axes1,'Children'),gca)
grid on; 
xlabel(x_label);ylabel(y_label);
legend(legende,'Location',legendPosition);
axes(handles.axes1);
legend(legende,'Location',legendPosition);

% --- Executes on button press in fig2_export_button.
function fig2_export_button_Callback(hObject, eventdata, handles)
% hObject    handle to fig2_export_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
[a,b,c,legende] = legend;
legendPosition = get(a,'Location');

y_label =  get(get(gca,'ylabel'),'string');
xlimits = xlim;
ylimits = ylim;
figure;
copyobj(get(handles.axes2,'Children'),gca)
grid on;
if get(handles.ArrheniusCheckbox,'value')
    x_label =  ' 1/T in 1/K';
    set(gca, 'YScale','log');
else
    x_label =  'Temperature in °C' ;
end
xlabel(x_label);ylabel(y_label);
legend(legende,'Location',legendPosition);
axes(handles.axes2);
legend(legende,'Location',legendPosition);


% --- Executes on button press in zustandplotbutton.
function zustandplotbutton_Callback(hObject, eventdata, handles)
% hObject    handle to zustandplotbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ModelDaten
SOCs=[];
Temperaturen=[];
Werte={};
ZustandsNummern = {};
Zustandsnamen = get(handles.ZustandPopup,'string');
Zustandsnamen = Zustandsnamen(2:end);
Modellnamenliste = get(handles.ModellnamePopup,'string');
Modellname = Modellnamenliste(get(handles.ModellnamePopup,'Value'));
ParameterFelder = get(handles.ParameterPanel,'Children');

for i = 1:numel(ParameterFelder)
    if get(ParameterFelder(i),'value')
        ParameterNummer=i;
    end
end
ParameterName = get(ParameterFelder(ParameterNummer),'String');
for Z_i = 2:numel(Zustandsnamen)+1
    set(handles.ZustandPopup,'value',Z_i)
    ZustandPopup_Callback(handles.ZustandPopup,eventdata,handles)
    Modellnamenliste = get(handles.ModellnamePopup,'string');
    if isempty(find(strcmp(Modellnamenliste,Modellname), 1)), continue,end
    set(handles.ModellnamePopup,'Value',find(strcmp(Modellnamenliste,Modellname), 1))
    ModellnamePopup_Callback(handles.ModellnamePopup,eventdata,handles)
    ParameterFelder = get(handles.ParameterPanel,'Children');
    set(ParameterFelder(ParameterNummer),'Value',1)
    ParameterPanel_SelectionChangeFcn(handles.ParameterPanel, [], handles)
    for T_i = 1:numel(ModelDaten.T)
        for SOC_i = 1:numel(ModelDaten.SOC)
            if isnan(ModelDaten.Parameter(T_i,SOC_i)),continue, end
            SOC_Wert = 5 * round(ModelDaten.SOC(SOC_i)/5);
            T_Wert = 5 * round(ModelDaten.T(T_i)/5);
            SOC_T_Index = find(SOCs == SOC_Wert & Temperaturen == T_Wert,1);
            if isempty(SOC_T_Index)
                SOC_T_Index = numel(Werte)+1;
                SOCs(SOC_T_Index) = SOC_Wert;
                Temperaturen(SOC_T_Index) = T_Wert;
                Werte{SOC_T_Index} = [];
                ZustandsNummern{SOC_T_Index} = [];
            else
                                
            end
            Werte{SOC_T_Index} = [Werte{SOC_T_Index} ModelDaten.Parameter(T_i,SOC_i)];
            ZustandsNummern{SOC_T_Index} = [ZustandsNummern{SOC_T_Index} Z_i-1];
            
        end
    end
    
end
cmap=colormap(lines((numel(SOCs))));
[SOCs ix ] = sort(SOCs,2);
ZustandsNummern = ZustandsNummern(ix);
Werte = Werte(ix);
figure;
for i = 1:numel(SOCs)
    FarbenIndex = i; 
    if (~isempty(find(diff(Temperaturen),1)) && ~isempty(find(diff(SOCs),1))) || numel(SOCs)==1
        LegendenEintrag = sprintf('%0.0f%% SOC %0.0f°C',SOCs(i),Temperaturen(i));
    elseif isempty(find(diff(Temperaturen),1)) && ~isempty(find(diff(SOCs),1))
        LegendenEintrag = sprintf('%0.0f%% SOC',SOCs(i));
    elseif ~isempty(find(diff(Temperaturen),1)) && isempty(find(diff(SOCs),1))
        LegendenEintrag = sprintf('%0.0f°C',Temperaturen(i));
    end
    plot(ZustandsNummern{i},Werte{i},'DisplayName',LegendenEintrag ,'Color',cmap(FarbenIndex,:),'LineStyle','-','Marker','o')

    hold on
end
grid on
legend('show','location','northwest')
xticklabel_rotate([1:numel(Zustandsnamen)],60,Zustandsnamen,'interpreter','none')

Batteriename = get(handles.BatterieNamePopup,'string');
Batteriename = Batteriename{get(handles.BatterieNamePopup,'value')};
if isempty(dir('export'))
    mkdir('export')
end
if isempty( dir(['export' '/' Batteriename]))
    mkdir(['export' '/' Batteriename])
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
print(gcf,['export' '/' Batteriename '/' ParameterName{1} '.png'], '-dpng', '-r900');
title(ParameterName)
saveas(gcf,['export' '/' Batteriename '/' ParameterName{1} '.fig'])
    



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
if ~isempty(dir(['output/' Batteriename '/Zustandaliases.mat'])) || ~isempty(dir(['output/' Batteriename '/Zustandaliases.xls'])) ||~isempty(dir(['output/' Batteriename '/Zustandaliases.xlsx']))
    
    for Z_i = 1:numel(Zustandaliases)
        cmap=colormap(lines((numel(SOCs))));
        figure;
        for SOC_T_Index = 1:numel(Werte)
            WerteNeu{SOC_T_Index} = [];
            ZustandsNummernNeu{SOC_T_Index} = [];
            for W_i = 1:numel(Zustandaliases{Z_i}.Zustands_name)
                
                AlteNummer = find(strcmp(Zustandsnamen,    Zustandaliases{Z_i}.Zustands_name{W_i}));
                if ~isempty(AlteNummer)
                    Alter_index = find(ZustandsNummern{SOC_T_Index}==AlteNummer,1,'first');
                    if ~isempty(Alter_index)
                        WerteNeu{SOC_T_Index} = [WerteNeu{SOC_T_Index} Werte{SOC_T_Index}(Alter_index)];
                        if iscell(Zustandaliases{Z_i}.value)
                            ZustandsNummernNeu{SOC_T_Index} = [ZustandsNummernNeu{SOC_T_Index} W_i];
                        else
                            ZustandsNummernNeu{SOC_T_Index} = [ZustandsNummernNeu{SOC_T_Index} Zustandaliases{Z_i}.value(W_i)];
                        end
                    end
                end
            end
            FarbenIndex = SOC_T_Index; 
            if (~isempty(find(diff(Temperaturen),1)) && ~isempty(find(diff(SOCs),1))) || numel(SOCs)==1
                LegendenEintrag = sprintf('%0.0f%% SOC %0.0f°C',SOCs(SOC_T_Index),Temperaturen(SOC_T_Index));
            elseif isempty(find(diff(Temperaturen),1)) && ~isempty(find(diff(SOCs),1))
                LegendenEintrag = sprintf('%0.0f%% SOC',SOCs(SOC_T_Index));
            elseif ~isempty(find(diff(Temperaturen),1)) && isempty(find(diff(SOCs),1))
                LegendenEintrag = sprintf('%0.0f°C',Temperaturen(SOC_T_Index));
            end
            plot(ZustandsNummernNeu{SOC_T_Index},WerteNeu{SOC_T_Index},'DisplayName',LegendenEintrag ,'Color',cmap(FarbenIndex,:),'LineStyle','-','Marker','o')

            hold on
        end
        
        ylabel(ParameterName)
        if isempty(Zustandaliases{Z_i}.unit)
            xlabel(Zustandaliases{Z_i}.name)
        else
            xlabel([Zustandaliases{Z_i}.name ' in ' Zustandaliases{Z_i}.unit])
        end
        if strcmpi(Zustandaliases{Z_i}.name,'soh'),
            set(gca,'xdir','reverse')
        end
        grid on
        legend('show','location','northwest')
        if iscell(Zustandaliases{Z_i}.value)
            xticklabel_rotate([1:numel(Zustandaliases{Z_i}.value)],60,Zustandaliases{Z_i}.value,'interpreter','none')
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
%         print(gcf,['export' '/' Batteriename '/' ParameterName{1} ' ' Zustandaliases{Z_i}.name '.png'], '-dpng', '-r900');
        title(ParameterName)
        saveas(gcf,['export' '/' Batteriename '/' ParameterName{1} ' ' Zustandaliases{Z_i}.name '.fig'])

            
    end
end


% --- Executes on button press in ArrheniusCheckbox.
function ArrheniusCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to ArrheniusCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ArrheniusCheckbox
ParameterPanel_SelectionChangeFcn(handles.ParameterPanel,[],handles)
