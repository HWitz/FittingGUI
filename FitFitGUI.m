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


function varargout = FitFitGUI(varargin)
% FITFITGUI MATLAB code for FitFitGUI.fig
%      FITFITGUI, by itself, creates a new FITFITGUI or raises the existing
%      singleton*.
%
%      H = FITFITGUI returns the handle to a new FITFITGUI or the handle to
%      the existing singleton*.
%
%      FITFITGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FITFITGUI.M with the given input arguments.
%
%      FITFITGUI('Property','Value',...) creates a new FITFITGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FitFitGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FitFitGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FitFitGUI

% Last Modified by GUIDE v2.5 30-Nov-2016 18:50:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FitFitGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FitFitGUI_OutputFcn, ...
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


% --- Executes just before FitFitGUI is made visible.
function FitFitGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FitFitGUI (see VARARGIN)

% Choose default command line output for FitFitGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FitFitGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FitFitGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles;

% --- Executes on button press in FitButton.
function FitButton_Callback(hObject, eventdata, handles)
% hObject    handle to FitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FitFitData;
Par=cell2struct(FitFitData.ParameterTable ,{'ParameterFix' 'ParameterNamen' 'Functions' 'Results'},2);
useindex = find(cell2mat(FitFitData.SOCTable(:,1))==1);
if isempty(useindex), 
    error('Bitte wählen Sie mindestens einen Ladezustand zum Fitten aus.')
end
SOC_vektor = FitFitData.SOCs(useindex)';
Par_orig_vektor = zeros(numel(SOC_vektor),numel(Par));
FitFitData.linear.indices = [];
FitFitData.linear.koeffizient_init=[];
FitFitData.linear.pinit=[];
FitFitData.linear.pmin=[];
FitFitData.linear.pmax=[];
FitFitData.constant=FitFitData.linear;
FitFitData.square=FitFitData.linear;
FitFitData.cubic=FitFitData.linear;
FitFitData.exponential=FitFitData.linear;
FitFitData.individual=FitFitData.linear;


for i = 1:numel(Par)
    for j = 1:numel(useindex)
        Par_orig_vektor(j,i) = FitFitData.Model{1,useindex(j)}.Fit.Parameter(i);   
    end
    if ~FitFitData.ParameterTable{i,1}
        if strcmpi('linear',FitFitData.ParameterTable{i,3})
            FitFitData.linear.function='p(1).*w+p(2)';
            b = ([SOC_vektor' ones(numel(SOC_vektor),1) ]\Par_orig_vektor(:,i));
            FitFitData.linear.indices = [ FitFitData.linear.indices i];
            FitFitData.linear.koeffizient_init = [FitFitData.linear.koeffizient_init b];
            FitFitData.linear.pinit=[FitFitData.linear.pinit b];
            
            FitFitData.linear.pmin=[FitFitData.linear.pmin b'-0.3*b'  ];
            FitFitData.linear.pmax=[FitFitData.linear.pmax b'+0.3*b' ];  
        elseif strcmpi('constant',FitFitData.ParameterTable{i,3})
            FitFitData.constant.function='p(1)';
            b = (ones(numel(SOC_vektor),1)\Par_orig_vektor(:,i));
            FitFitData.constant.indices = [ FitFitData.constant.indices i];
            FitFitData.constant.koeffizient_init = [FitFitData.constant.koeffizient_init b];
            FitFitData.constant.pinit=[FitFitData.constant.pinit b];
            FitFitData.constant.pmin=[FitFitData.constant.pmin FitFitData.aktuell_Modell.ModellCell{5}{i} ];
            FitFitData.constant.pmax=[FitFitData.constant.pmax FitFitData.aktuell_Modell.ModellCell{6}{i} ];            
        elseif strcmpi('square',FitFitData.ParameterTable{i,3})
            FitFitData.square.function='p(1)+p(2).*w+p(3).*w.^2';
            b = ([ ones(numel(SOC_vektor),1) SOC_vektor']\Par_orig_vektor(:,i));
            p=[ b' 0.1];
            options = optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-12,'TolFun',1e-12);
            w = SOC_vektor';
            p_min = [ -abs(b'*10) -inf ];
            p_max = [ abs(b'*10) inf ];
            [p,~,~,~]=function_fit_easyfit2(w,[Par_orig_vektor(:,i), zeros(size(Par_orig_vektor(:,i)))],...
                p,@function_model_all_types2, ...
                p_min,  p_max ,options, FitFitData.square.function);
            FitFitData.square.indices = [ FitFitData.square.indices i];
            FitFitData.square.koeffizient_init = [FitFitData.square.koeffizient_init p'];
            FitFitData.square.pinit=[FitFitData.square.pinit p'];
            FitFitData.square.pmin=[FitFitData.square.pmin p_min' ];
            FitFitData.square.pmax=[FitFitData.square.pmax p_max' ];
        elseif strcmpi('cubic',FitFitData.ParameterTable{i,3})
            FitFitData.cubic.function='p(1)+p(2).*w+p(3).*w.^2+p(4).*w.^3';
            b = ([ ones(numel(SOC_vektor),1) SOC_vektor']\Par_orig_vektor(:,i));
            p=[ b' 0.01];
            options = optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-12,'TolFun',1e-12);
            w = SOC_vektor';
            p_min = [ -abs(b'*10) -inf ];
            p_max = [ abs(b'*10) inf ];
            [p,~,~,~]=function_fit_easyfit2(w,[Par_orig_vektor(:,i), zeros(size(Par_orig_vektor(:,i)))],...
                p,@function_model_all_types2, ...
                p_min,  p_max ,options, 'p(1)+p(2).*w+p(3).*w.^2');
            p_min = [ -abs(p*10) -inf ];
            p_max = [ abs(p*10) inf ];
            p=[ p 0.01];
            [p,~,~,~]=function_fit_easyfit2(w,[Par_orig_vektor(:,i), zeros(size(Par_orig_vektor(:,i)))],...
                p,@function_model_all_types2, ...
                p_min,  p_max ,options, FitFitData.square.function);
            [p,~,~,~]=function_fit_easyfit2(w,[Par_orig_vektor(:,i), zeros(size(Par_orig_vektor(:,i)))],...
                p,@function_model_all_types2, ...
                p_min,  p_max ,options, FitFitData.cubic.function);
            FitFitData.cubic.indices = [ FitFitData.cubic.indices i];
            FitFitData.cubic.koeffizient_init = [FitFitData.cubic.koeffizient_init p'];
            FitFitData.cubic.pinit=[FitFitData.cubic.pinit p'];
            FitFitData.cubic.pmin=[FitFitData.cubic.pmin p_min' ];
            FitFitData.cubic.pmax=[FitFitData.cubic.pmax p_max' ];
        elseif strcmpi('exponential',FitFitData.ParameterTable{i,3})
            FitFitData.exponential.function='p(1)+p(2).*exp((w-p(4))./p(3))';
            b = ([SOC_vektor' ones(numel(SOC_vektor),1) ]\Par_orig_vektor(:,i));
            if b(1)<0
                p=[ 0.1 0.1 -10 5 ];
                p_min=[ 0 1e-6 -1000 -10 ];
                p_max=[inf 1000 -.1 110 ];
            else
                p=[ 0.1 0.1 10 5 ];
                p_min=[ 0 1e-6 0.1 -10 ];
                p_max=[inf 1000 1000 110 ];
            end
            options = optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-12,'TolFun',1e-12);
            w = SOC_vektor';
            [p,~,~,~]=function_fit_easyfit2(w,[Par_orig_vektor(:,i), zeros(size(Par_orig_vektor(:,i)))],...
                p,@function_model_all_types2, ...
                p_min,  p_max ,options, FitFitData.exponential.function);
            Fitted = eval(FitFitData.exponential.function);
            FitFitData.exponential.indices = [ FitFitData.exponential.indices i];
            FitFitData.exponential.koeffizient_init = [FitFitData.exponential.koeffizient_init p'];
            FitFitData.exponential.pinit=[FitFitData.exponential.pinit p'];
            FitFitData.exponential.pmin=[FitFitData.exponential.pmin p_min' ];
            FitFitData.exponential.pmax=[FitFitData.exponential.pmax p_max' ];
        elseif strcmpi('individual',FitFitData.ParameterTable{i,3})
            FitFitData.individual.indices = [ FitFitData.individual.indices i];
            FitFitData.individual.koeffizient_init = [FitFitData.individual.koeffizient_init ones(numel(useindex),1)];
            for j = 1:numel(useindex)
                pmax(j,1) = FitFitData.Model{useindex(j)}.Fit.Parameter_max(i);
                pmin(j,1) = FitFitData.Model{useindex(j)}.Fit.Parameter_min(i);
                pinit(j,1) = FitFitData.Model{useindex(j)}.Fit.Parameter(i);
            end
            FitFitData.individual.pinit=[FitFitData.individual.pinit pinit];
            FitFitData.individual.pmin=[FitFitData.individual.pmin pmin];
            FitFitData.individual.pmax=[FitFitData.individual.pmax pmax];
        end
    end
end
fitfitparnr=0;
pinit_ges=[];
pmin_ges=[];
pmax_ges=[];


for variante = {'linear' 'constant' 'square' 'cubic' 'exponential' 'individual'}
    ParIndices = fitfitparnr+(1:numel(FitFitData.(variante{1}).koeffizient_init));
    FitFitData.(variante{1}).fitfitparind = reshape(ParIndices,size(FitFitData.(variante{1}).koeffizient_init));
    FitFitData.(variante{1}).Ersetzfunction={};
    if ~strcmp(variante{1},'individual')
        for k = 1:numel(FitFitData.(variante{1}).indices)
            FitFitData.(variante{1}).Ersetzfunction{k}=FitFitData.(variante{1}).function;
            for k2 = 1:size(FitFitData.(variante{1}).koeffizient_init,1)
                FitFitData.(variante{1}).Ersetzfunction{k} = strrep(FitFitData.(variante{1}).Ersetzfunction{k},['p(' num2str(k2) ')'],['r(' num2str(k2) ')']);
            end
            for k2 = 1:size(FitFitData.(variante{1}).koeffizient_init,1)
                 FitFitData.(variante{1}).Ersetzfunction{k} = ...
                     strrep(FitFitData.(variante{1}).Ersetzfunction{k},...
                     ['r(' num2str(k2) ')'],['p(' num2str(FitFitData.(variante{1}).fitfitparind(k2,k)) ')']);
            end
        end
    end
    fitfitparnr = fitfitparnr + numel(FitFitData.(variante{1}).koeffizient_init);
    pinit_ges = [pinit_ges ; FitFitData.(variante{1}).pinit(:)];
    pmin_ges = [pmin_ges ; FitFitData.(variante{1}).pmin(:)];
    pmax_ges = [pmax_ges ; FitFitData.(variante{1}).pmax(:)];

end

GesamtFitFunction='';
GesamtFitFunction_MF='';
w_ges=[];
Z_ges=[];
Z_origFit=[];
Z_origFit_MF=[];

start_w=zeros(size(useindex));
end_w=zeros(size(useindex));
for j=1:numel(useindex)
    f2 = dir(['output/' FitFitData.BatterieName '/'  FitFitData.Zustand '/' FitFitData.TString '/*_' FitFitData.SOCString{useindex(j)} '.mat']);
    LoadedData = load(['output/' FitFitData.BatterieName '/'  FitFitData.Zustand '/' FitFitData.TString '/' f2.name]);
    if ~isempty(LoadedData) && ismember('DRT_GUI',fieldnames(LoadedData)) ...
            && ~isempty(LoadedData.DRT_GUI) && ismember('Messdaten',fieldnames(LoadedData.DRT_GUI))
        w=LoadedData.DRT_GUI.Messdaten.omega(LoadedData.DRT_GUI.Messdaten.aktiv==1) ;
        w_ges = [w_ges ; reshape(w,numel(w),1)];
        Zreal=LoadedData.DRT_GUI.Messdaten.Zreal(LoadedData.DRT_GUI.Messdaten.aktiv==1) ;
        Zimg=LoadedData.DRT_GUI.Messdaten.Zimg(LoadedData.DRT_GUI.Messdaten.aktiv==1) ;
        Z_origFit_real=LoadedData.DRT_GUI.Fit.Zreal ;
        Z_origFit_img=LoadedData.DRT_GUI.Fit.Zimg ;
        Z_origFitMF_real=LoadedData.DRT_GUI.Fit.korrigiert.Zreal ;
        Z_origFitMF_img=LoadedData.DRT_GUI.Fit.korrigiert.Zimg ;
        Z_ges = [Z_ges ; [reshape(Zreal,numel(w),1) reshape(Zimg,numel(w),1)]];
        Z_origFit = [Z_origFit ; [reshape(Z_origFit_real,numel(w),1) reshape(Z_origFit_img,numel(w),1)]];
        Z_origFit_MF = [Z_origFit_MF ; [reshape(Z_origFitMF_real,numel(w),1) reshape(Z_origFitMF_img,numel(w),1)]];
        if j==1
            start_w(j) = 1;
        else
            start_w(j) = end_w(j-1)+1;
        end
        end_w(j) = start_w(j)+numel(w)-1;
        

        EinzelFunction = FitFitData.aktuell_Modell.Rechnen_Modell;
        EinzelFunction_MF = FitFitData.aktuell_Modell.Rechnen_Modell_MF;
        for i = 1:numel(Par)
            EinzelFunction = strrep(EinzelFunction,['p(' num2str(i) ')'] ,['q(' num2str(i) ')']);
            EinzelFunction_MF = strrep(EinzelFunction_MF,['p(' num2str(i) ')'] ,['q(' num2str(i) ')']);
        end
        EinzelFunction = strrep(EinzelFunction,'w',['w(' num2str(start_w(j)) ':' num2str(end_w(j)) ')']);
        EinzelFunction_MF = strrep(EinzelFunction_MF,'w',['w(' num2str(start_w(j)) ':' num2str(end_w(j)) ')']);
        for i = 1:numel(Par)
            if Par(i).ParameterFix
                EinzelFunction = strrep(EinzelFunction,['q(' num2str(i) ')'],['(' num2str(Par_orig_vektor(j,i)) ')']);
                EinzelFunction_MF = strrep(EinzelFunction_MF,['q(' num2str(i) ')'],['(' num2str(Par_orig_vektor(j,i)) ')']);
            elseif ismember(i,FitFitData.individual.indices)
                EinzelFunction = strrep(EinzelFunction,['q(' num2str(i) ')'],['p(' ...
                            num2str(FitFitData.individual.fitfitparind(j,FitFitData.individual.indices==i)) ...
                            ')']);
                EinzelFunction_MF = strrep(EinzelFunction_MF,['q(' num2str(i) ')'],['p(' ...
                            num2str(FitFitData.individual.fitfitparind(j,FitFitData.individual.indices==i)) ...
                            ')']);
            else
                for variante = {'linear' 'constant' 'square' 'cubic' 'exponential' }
                    if ismember(i,FitFitData.(variante{1}).indices)
                        EinzelFunction = strrep(EinzelFunction,['q(' num2str(i) ')'],['(' ...
                            strrep(FitFitData.(variante{1}).Ersetzfunction{FitFitData.(variante{1}).indices==i},'w',['(' num2str(FitFitData.SOCs(useindex(j))) ')']) ...
                            ')']);
                        EinzelFunction_MF = strrep(EinzelFunction_MF,['q(' num2str(i) ')'],['(' ...
                            strrep(FitFitData.(variante{1}).Ersetzfunction{FitFitData.(variante{1}).indices==i},'w',['(' num2str(FitFitData.SOCs(useindex(j))) ')']) ...
                            ')']);
                        break;
                    end
                end
            end
        end
        GesamtFitFunction = [GesamtFitFunction ' ; ' EinzelFunction];
        GesamtFitFunction_MF = [GesamtFitFunction_MF ' ; ' EinzelFunction_MF];

    else
        error(['Datei fehlerhaft:' 'output/' FitFitData.BatterieName '/'  FitFitData.Zustand '/' FitFitData.TString '/' f2.name ])
    end
    
    
end

GesamtFitFunction = ['[' GesamtFitFunction ']'];
GesamtFitFunction_MF = ['[' GesamtFitFunction_MF ']'];
options = optimset('MaxIter',50000,'MaxFunEvals',500000,'TolX',1e-8,'TolFun',1e-8);
w=w_ges;
[p,~,~,~]=function_fit_easyfit2(w_ges,Z_ges,pinit_ges,@function_model_all_types2, pmin_ges, pmax_ges,options, GesamtFitFunction);
Z_FitFit = eval(GesamtFitFunction);
Z_FitFit_MF = eval(GesamtFitFunction_MF);

Par_neu_vektor = Par_orig_vektor;
Par_init_vektor = Par_orig_vektor;
for i=1:numel(Par)
    
    if Par(i).ParameterFix
        
    else
%         figure;plot(FitFitData.SOCs(useindex),Par_orig_vektor(:,i),'DisplayName',[FitFitData.ParameterTable{i,2} ' original']);
%         hold all; grid on
        if ismember(i,FitFitData.individual.indices)
            Par_neu_vektor(:,i) = p(FitFitData.individual.fitfitparind(:,FitFitData.individual.indices==i)); 
%             plot(FitFitData.SOCs(useindex),Par_neu_vektor(:,i),...
%                 'DisplayName',[FitFitData.ParameterTable{i,2} ' individual fitfit'])
        else
            for variante = {'linear' 'constant' 'square' 'cubic' 'exponential' }
                if ismember(i,FitFitData.(variante{1}).indices)
                    w=FitFitData.SOCs(useindex);
                    
                    Par_neu_vektor(:,i)=eval(FitFitData.(variante{1}).Ersetzfunction{FitFitData.(variante{1}).indices==i});
                    p_old = p;p=pinit_ges;
                    Par_init_vektor(:,i) = eval(FitFitData.(variante{1}).Ersetzfunction{FitFitData.(variante{1}).indices==i});
%                     plot(FitFitData.SOCs(useindex),Par_init_vektor(:,i),...
%                         'DisplayName',[FitFitData.ParameterTable{i,2} ' initial guess'])
                    p=p_old;
%                     plot(FitFitData.SOCs(useindex),Par_neu_vektor(:,i),...
%                         'DisplayName',[FitFitData.ParameterTable{i,2} ' ' variante{1} ' fitfit'])
                    break;
                end
            end
        end
%         l=legend('show');
%         set(l,'Interpreter','none')
                    
    end
end
FitFitData.FitFit.Par_orig_vektor = Par_orig_vektor;
FitFitData.FitFit.Par_neu_vektor = Par_neu_vektor;
FitFitData.FitFit.Par_init_vektor = Par_init_vektor;
FitFitData.FitFit.pinit_ges = pinit_ges;
FitFitData.FitFit.pbest = p;
FitFitData.FitFit.w_ges = w_ges;
FitFitData.FitFit.start_w = start_w;
FitFitData.FitFit.end_w = end_w;
FitFitData.FitFit.Z_ges = Z_ges;
FitFitData.FitFit.Z_origFit = Z_origFit;
FitFitData.FitFit.Z_origFit_MF = Z_origFit_MF;
FitFitData.FitFit.Z_FitFit = Z_FitFit;
FitFitData.FitFit.Z_FitFit_MF = Z_FitFit_MF;
FitFitData.FitFit.GesamtFitFunction = GesamtFitFunction;
FitFitData.FitFit.GesamtFitFunction_MF = GesamtFitFunction_MF;
FitFitData.FitFit.useindex = useindex;
FitFitData.FitFit.SOC_vektor = SOC_vektor;
eventdata2.Indices=[find(cell2mat(FitFitData.ParameterTable(:,1))==false,1,'first') 2];
ParameterTable_CellSelectionCallback(handles.ParameterTable,eventdata2,handles)
eventdata2.Indices=[useindex(1) 2];
SOCTable_CellSelectionCallback(handles.SOCTable,eventdata2,handles)






% --- Executes on button press in PlotResultsButton.
function PlotResultsButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlotResultsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LoadDataButton.
function LoadDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DRT_GUI
global FitFitData

if isempty(DRT_GUI) || ~isstruct(DRT_GUI) ...
        || ~ismember('Fit',fieldnames(DRT_GUI)) || isempty(DRT_GUI.Fit) || ~isstruct(DRT_GUI.Fit) ...
        || ~ismember('aktuell_Modell',fieldnames(DRT_GUI.Fit)) ...
        || ~ismember('P_Name',fieldnames(DRT_GUI.Fit.aktuell_Modell))
    return
end
BatterieName = DRT_GUI.Testparameter.Batterie;
Zustand = DRT_GUI.Testparameter.Zustand;
Temperatur = DRT_GUI.Testparameter.Temperatur;
TString = [strrep(num2str(Temperatur),'-','m') 'grad'];
OrigSOC = DRT_GUI.Testparameter.SOC;
OrigSOCString = [strrep(num2str(OrigSOC),'-','m') 'SOC'];
f = dir(['output/' BatterieName '/'  Zustand '/' TString '/*_' OrigSOCString '_Modell.mat']);
if ~isempty(f)
   OriginalModell = load(['output/' BatterieName '/'  Zustand '/' TString '/' f.name]);
else
   error('Bitte speichern Sie zuerst den aktuellen Datensatz in der DRT_GUI.') 
end
ParameterNamen = DRT_GUI.Fit.aktuell_Modell.P_Name(1,:)';
ParameterFix = num2cell(true(numel(ParameterNamen),1));%num2cell(logical(DRT_GUI.Fit.ParFix'));
Functions = repmat({''},numel(ParameterNamen),1);
Results = repmat({''},numel(ParameterNamen),1);
FitFitData.ParameterTable=[ParameterFix ParameterNamen Functions Results];
set(handles.ParameterTable,'Data',FitFitData.ParameterTable);



SOCs = [];
SOCString = {};
    f = dir(['output/' BatterieName '/'  Zustand '/' TString '/*_*SOC_Modell.mat']);
    for j = 1:numel(f)
        if ~strcmp(f(j).name,'.') && ~strcmp(f(j).name,'..') && ~f(j).isdir 
            SOCString = [SOCString;strrep(strrep(strrep(strrep(strrep(f(j).name,TString,''),BatterieName,''),Zustand,''),'_',''),'Modell.mat','')];
        end
    end
    for j = 1:numel(SOCString)
        if ~sum(find(SOCs == str2num(strrep(strrep(SOCString{j},'SOC',''),'m','-'))))
            SOCs = [SOCs ; str2num(strrep(strrep(SOCString{j},'SOC',''),'m','-'))];
        end  
    end    
[SOCs,sortIndex] = sort(SOCs);
SOCString = SOCString(sortIndex);
gueltig = repmat({false},numel(SOCs),1);

Model = cell(1,numel(SOCs));

richtigesModell = zeros(size(SOCs));

for j = 1:numel(SOCs)
    f = dir(['output/' BatterieName '/'  Zustand '/' TString '/*_' SOCString{j} '_Modell.mat']);
    f2 = dir(['output/' BatterieName '/'  Zustand '/' TString '/*_' SOCString{j} '.mat']);
    if ~isempty(f) && ~isempty(f2)
        Model{1,j} = load(['output/' BatterieName '/'  Zustand '/' TString '/' f.name]);
        CompareName =Model{1,j}.Fit.Modell.Modellname;
        if strcmp(CompareName(end-3:end),'_OCV'), CompareName=CompareName(1:end-4);end
        if strcmp(CompareName,DRT_GUI.Fit.aktuell_Modell.Modellname) ...
                && size(Model{1,j}.Fit.Modell.P_Name(1,~strcmp((Model{1,j}.Fit.Modell.P_Name(2,:)),'')),2) == numel(ParameterNamen)
            richtigesModell(j)=1;
            if Model{1,j}.Fit.gueltig
                gueltig{j}=true;
            end
        end
    end
end
FitFitData.SOCTable=[ gueltig(richtigesModell==1,1) num2cell(SOCs(richtigesModell==1)) gueltig(richtigesModell==1,1)];
FitFitData.BatterieName=BatterieName;
FitFitData.Zustand=Zustand;
FitFitData.Temperatur=Temperatur;
FitFitData.TString=TString;
FitFitData.SOCs=SOCs(richtigesModell==1);
FitFitData.SOCString=SOCString(richtigesModell==1);
FitFitData.Model=Model(1,richtigesModell==1);
FitFitData.gueltig=gueltig(richtigesModell==1);
FitFitData.aktuell_Modell = DRT_GUI.Fit.aktuell_Modell;
set(handles.SOCTable,'Data',FitFitData.SOCTable)

FitFitData.FitFit=[];
FitButton_Callback(handles.FitButton,eventdata,handles)

% --- Executes on button press in SaveResultsButton.
function SaveResultsButton_Callback(hObject, eventdata, handles)
global FitFitData
if isempty(FitFitData) || ~isstruct(FitFitData) || ~ismember('FitFit',fieldnames(FitFitData)) || isempty(FitFitData.FitFit) || ~isstruct(FitFitData.FitFit)
    return
end
neuer_Batteriename= inputdlg('Unterwelchem Batterienamen sollen die Änderungen gespeichert werden?','Batteriename',[1],{FitFitData.BatterieName});
if isempty(neuer_Batteriename),return,end       
FitChoice = questdlg('mit anschliessendem Fitting?', ...
	'Dessert Menu', ...
	'Ja','Nein','Nein');
if isempty(FitChoice),return,end
if strcmpi(FitChoice,'ja')
    Prozesschoice = questdlg('mit anschliessendem Prozessfitting?', ...
        'Dessert Menu', ...
        'Ja','Nein','Nein');
    if isempty(Prozesschoice),return,end
else
    Prozesschoice='nein';
end
global DRT_GUI
old_DRT_GUI = DRT_GUI;
useindex = FitFitData.FitFit.useindex;
for j=1:numel(useindex)
    f2 = dir(['output/' FitFitData.BatterieName '/'  FitFitData.Zustand '/' FitFitData.TString '/*_' FitFitData.SOCString{useindex(j)} '.mat']);
    load(['output/' FitFitData.BatterieName '/'  FitFitData.Zustand '/' FitFitData.TString '/' f2.name]);
    DRT_GUI.Testparameter.Batterie = neuer_Batteriename{1};
    for variante = {'linear' 'constant' 'square' 'cubic' 'exponential' 'individual'}
        for i = FitFitData.(variante{1}).indices
            DRT_GUI.Fit.Parameter(i)  =  FitFitData.FitFit.Par_neu_vektor(j,i);
            DRT_GUI.Fit.ParFix(i) = true  ;
        end
    end
    run_DRT_GUI_save(FitChoice,Prozesschoice);
    
end

DRT_GUI = old_DRT_GUI;

% hObject    handle to SaveResultsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in CloseButton.
function CloseButton_Callback(hObject, eventdata, handles)
% hObject    handle to CloseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in ParameterTable.
function ParameterTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to ParameterTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

global FitFitData
ParameterTable = get(handles.ParameterTable,'Data');
if isempty(eventdata) || ~ismember('Indices',fieldnames(eventdata))
    for i = 1:size(ParameterTable,1)
        if ParameterTable{i,1}
            ParameterTable{i,3}=' ';
            ParameterTable{i,4}='';
        else
            ParameterTable{i,3}='linear';
            ParameterTable{i,4}='';
        end
    end
else
    if eventdata.Indices(2) ==1;
        if ParameterTable{eventdata.Indices(1),1}
            ParameterTable{eventdata.Indices(1),3}=' ';
            ParameterTable{eventdata.Indices(1),4}='';
        else
            ParameterTable{eventdata.Indices(1),3}='linear';
            ParameterTable{eventdata.Indices(1),4}='';
        end
    elseif eventdata.Indices(2) ==3;
        if ParameterTable{eventdata.Indices(1),3}==' '
            ParameterTable{eventdata.Indices(1),1}=true;
            ParameterTable{eventdata.Indices(1),4}='';
        else
            ParameterTable{eventdata.Indices(1),1}=false;
            ParameterTable{eventdata.Indices(1),4}='';
        end
    end
end
set(handles.ParameterTable,'Data',ParameterTable)
FitFitData.ParameterTable = ParameterTable;

% --- Executes when entered data in editable cell(s) in SOCTable.
function SOCTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to SOCTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global FitFitData;
FitFitData.SOCTable=get(handles.SOCTable,'Data');


% --- Executes when selected cell(s) is changed in ParameterTable.
function ParameterTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to ParameterTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global FitFitData
axes(handles.ParameterAxes)
plot(0,0)
legend('show')
legend('off')
cla(handles.ParameterAxes)


if isempty(FitFitData) || ~isstruct(FitFitData) || ~ismember('FitFit',fieldnames(FitFitData)) || isempty(FitFitData.FitFit) || ~isstruct(FitFitData.FitFit)...
        || isempty(eventdata) || isnumerictype(eventdata) || ~ismember('Indices',fieldnames(eventdata)) || numel(eventdata.Indices)~=2
    return
end
i = eventdata.Indices(1);
plot(FitFitData.FitFit.SOC_vektor',FitFitData.FitFit.Par_orig_vektor(:,i),'DisplayName',[FitFitData.ParameterTable{i,2} ' original']);
hold all; grid on;
if ismember(i,FitFitData.individual.indices)
    plot(FitFitData.FitFit.SOC_vektor',FitFitData.FitFit.Par_neu_vektor(:,i),...
        'DisplayName',[FitFitData.ParameterTable{i,2} ' individual fitfit'])
else
    for variante = {'linear' 'constant' 'square' 'cubic' 'exponential' }
        if ismember(i,FitFitData.(variante{1}).indices)
            plot(FitFitData.FitFit.SOC_vektor',FitFitData.FitFit.Par_neu_vektor(:,i),...
                'DisplayName',[FitFitData.ParameterTable{i,2} ' ' variante{1} ' fitfit'])
            plot(FitFitData.FitFit.SOC_vektor',FitFitData.FitFit.Par_init_vektor(:,i),...
                'DisplayName',[FitFitData.ParameterTable{i,2} ' initial guess'])
            break;
        end
    end
end
l=legend('show');
set(l,'Interpreter','none');
xlabel('SOC in %','Interpreter','none')


% --- Executes when selected cell(s) is changed in SOCTable.
function SOCTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to SOCTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


global FitFitData
FarbenLaden
axes(handles.NyquistAxes)
plot(0,0)
legend('show')
legend('off')
cla(handles.NyquistAxes)


axes(handles.NyquistMFAxes)
plot(0,0)
legend('show')
legend('off')
cla(handles.NyquistMFAxes)

axes(handles.RealAxes)
plot(0,0)
legend('show')
legend('off')
cla(handles.RealAxes)

axes(handles.ImagAxes)
plot(0,0)
legend('show')
legend('off')
cla(handles.ImagAxes)

if ~isempty(get(gca,'children')),legend('off'),end
if isempty(FitFitData) || ~isstruct(FitFitData) || ~ismember('FitFit',fieldnames(FitFitData)) || isempty(FitFitData.FitFit) || ~isstruct(FitFitData.FitFit)...
        || isempty(eventdata)  || isnumerictype(eventdata) || ~ismember('Indices',fieldnames(eventdata)) || numel(eventdata.Indices)~=2
    return
end
j = find(FitFitData.FitFit.useindex==eventdata.Indices(1));
if isempty(j),return;end
start = FitFitData.FitFit.start_w(j);
ende =  FitFitData.FitFit.end_w(j);
w = FitFitData.FitFit.w_ges(start:ende);
Z_mess = FitFitData.FitFit.Z_ges(start:ende,1)+1i*FitFitData.FitFit.Z_ges(start:ende,2);
Z_origFit = FitFitData.FitFit.Z_origFit(start:ende,1)+1i*FitFitData.FitFit.Z_origFit(start:ende,2);
Z_origFit_MF = FitFitData.FitFit.Z_origFit_MF(start:ende,1)+1i*FitFitData.FitFit.Z_origFit_MF(start:ende,2);

axes(handles.NyquistAxes)
plot(Z_mess,'color',RWTHBlau,'DisplayName','Messung');
hold all; grid on;axis equal;  set(gca,'ydir','reverse')
plot(Z_origFit,'color',RWTHTuerkis,'DisplayName','Fit');
if ~isempty(FitFitData.FitFit.pbest)
    plot(FitFitData.FitFit.Z_FitFit(start:ende,1),'color',RWTHRot,'DisplayName','FitFit');
end
l=legend('show');
set(l,'Interpreter','none','Location','Northwest');

axes(handles.RealAxes)
semilogx(w/2/pi,real(Z_mess),'color',RWTHBlau,'DisplayName','Messung');
hold all; grid on; set(gca,'xdir','reverse')
semilogx(w/2/pi,real(Z_origFit),'color',RWTHTuerkis,'DisplayName','Fit');
if ~isempty(FitFitData.FitFit.pbest)
    semilogx(w/2/pi,real(FitFitData.FitFit.Z_FitFit(start:ende,1)),'color',RWTHRot,'DisplayName','FitFit');
end
l=legend('show');
set(l,'Interpreter','none','Location','Northwest');
xlabel('f in Hz')

axes(handles.ImagAxes)
ZCLim=1./(1i.*w.*(1./(w(end)*(-imag(Z_mess(end))))));
semilogx(w/2/pi,imag(Z_mess-ZCLim),'color',RWTHBlau,'DisplayName','Messung');
hold all; grid on; set(gca,'xdir','reverse'),set(gca,'ydir','reverse')
semilogx(w/2/pi,imag(Z_origFit-ZCLim),'color',RWTHTuerkis,'DisplayName','Fit');
if ~isempty(FitFitData.FitFit.pbest)
    semilogx(w/2/pi,imag(FitFitData.FitFit.Z_FitFit(start:ende,1)-ZCLim),'color',RWTHRot,'DisplayName','FitFit');
end
l=legend('show');
set(l,'Interpreter','none','Location','Northwest');
xlabel('f in Hz')

axes(handles.NyquistMFAxes)
plot(Z_mess-Z_origFit+Z_origFit_MF,'color',RWTHBlau,'DisplayName','Messung');
hold all; grid on;axis equal; set(gca,'ydir','reverse')
plot(Z_origFit_MF,'color',RWTHTuerkis,'DisplayName','Fit');
if ~isempty(FitFitData.FitFit.pbest)
    plot(FitFitData.FitFit.Z_FitFit_MF(start:ende,1),'color',RWTHRot,'DisplayName','FitFit');
end
l=legend('show');
set(l,'Interpreter','none','Location','South');


function [functionhandle] = run_DRT_GUI()
functionhandle=DRT_GUI;  

function run_DRT_GUI_save(FitChoice,ProzessFitchoice)
    [functionhandle, handles] =FittingGUI;
    FittingGUI('aktualisieren_Button_Callback',handles.aktualisieren_Button,['kein_plot'],handles)
    if strcmpi(FitChoice,'ja')
        FittingGUI('FitButton_Callback',handles.FitButton,['kein_plot'],handles)
        FittingGUI('DRTButton_Callback',handles.DRTButton,['kein_plot'],handles)
        FittingGUI('Prozesse_fitten_button_Callback',handles.Prozesse_fitten_button,['kein_plot'],handles)

        if strcmpi(ProzessFitchoice,'ja')
            FittingGUI('DRT_Prozesse_use_button_Callback',handles.DRT_Prozesse_use_button,['kein_plot'],handles)
            FittingGUI('FitButton_Callback',handles.FitButton,['kein_plot'],handles)
        end
    else
        FittingGUI('PlotFittedParametersButton_Callback',handles.PlotFittedParametersButton,['kein_plot'],handles)
    end
    FittingGUI('SpeichernButton_Callback',handles.SpeichernButton,[],handles)
