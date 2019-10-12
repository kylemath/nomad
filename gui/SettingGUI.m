function varargout = SettingGUI(varargin)
% SETTINGGUI MATLAB code for SettingGUI.fig
%      SETTINGGUI, by itself, creates a new SETTINGGUI or raises the existing
%      singleton*.
%
%      H = SETTINGGUI returns the handle to a new SETTINGGUI or the handle to
%      the existing singleton*.
%
%      SETTINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETTINGGUI.M with the given input arguments.
%
%      SETTINGGUI('Property','Value',...) creates a new SETTINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SettingGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SettingGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SettingGUI

% Last Modified by GUIDE v2.5 11-Oct-2019 22:08:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SettingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SettingGUI_OutputFcn, ...
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


% --- Executes just before SettingGUI is made visible.
function SettingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SettingGUI (see VARARGIN)

% Choose default command line output for SettingGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SettingGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% This creates the 'background' axes
ha = axes('units','normalized', ...
'position',[0 0 1 1]);

% Move the background axes to the bottom
uistack(ha,'bottom');

% Load in a background image and display it using the correct colors
% The image used below, is in the Image Processing Toolbox. If you do not have %access to this toolbox, you can use another image file instead.
I=imread('nomad.jpg');
hi = imagesc(I);
colormap gray

% Turn the handlevisibility off so that we don't inadvertently plot into the axes again
% Also, make the axes invisible
set(ha,'handlevisibility','off', ...
'visible','off')





% --- Outputs from this function are returned to the command line.
function varargout = SettingGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





function NSrcs_Callback(hObject, eventdata, handles)
% hObject    handle to NSrcs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function NSrcs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NSrcs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NDets_Callback(hObject, eventdata, handles)
% hObject    handle to NDets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NDets as text
%        str2double(get(hObject,'String')) returns contents of NDets as a double


% --- Executes during object creation, after setting all properties.
function NDets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NDets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NMuxs_Callback(hObject, eventdata, handles)
% hObject    handle to NMuxs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NMuxs as text
%        str2double(get(hObject,'String')) returns contents of NMuxs as a double
handles.n_muxs = str2double(get(hObject,'String'));   % returns contents of NSrcs as a double


% --- Executes during object creation, after setting all properties.
function NMuxs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NMuxs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxDist_Callback(hObject, eventdata, handles)
% hObject    handle to MaxDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxDist as text
%        str2double(get(hObject,'String')) returns contents of MaxDist as a double


% --- Executes during object creation, after setting all properties.
function MaxDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MinDist_Callback(hObject, eventdata, handles)
% hObject    handle to MinDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinDist as text
%        str2double(get(hObject,'String')) returns contents of MinDist as a double


% --- Executes during object creation, after setting all properties.
function MinDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function HelmType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HelmType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in AutoSrcs.
function AutoSrcs_Callback(hObject, eventdata, handles)
% hObject    handle to AutoSrcs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AutoSrcs



% --- Executes on selection change in HelmetType.
function HelmetType_Callback(hObject, eventdata, handles)
% hObject    handle to HelmetType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns HelmetType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from HelmetType


% --- Executes during object creation, after setting all properties.
function HelmetType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HelmetType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NMtgs_Callback(hObject, eventdata, handles)
% hObject    handle to NMtgs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NMtgs as text
%        str2double(get(hObject,'String')) returns contents of NMtgs as a double


% --- Executes during object creation, after setting all properties.
function NMtgs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NMtgs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function NWvls_Callback(hObject, eventdata, handles)
% hObject    handle to NWvls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NWvls as text
%        str2double(get(hObject,'String')) returns contents of NWvls as a double


% --- Executes during object creation, after setting all properties.
function NWvls_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NWvls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HelmetTypeOrder_Callback(hObject, eventdata, handles)
% hObject    handle to HelmetTypeOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HelmetTypeOrder as text
%        str2double(get(hObject,'String')) returns contents of HelmetTypeOrder as a double


% --- Executes during object creation, after setting all properties.
function HelmetTypeOrder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HelmetTypeOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in SourceDistList.
function SourceDistList_Callback(hObject, eventdata, handles)
% hObject    handle to SourceDistList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SourceDistList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SourceDistList


% --- Executes during object creation, after setting all properties.
function SourceDistList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourceDistList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Load_Button.
function Load_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global mtg
cd examples
[mtg(1).load_filename mtg(1).load_pathname] = uigetfile('*.mat','Select Saved .mat Montage Structure:');
load([mtg(1).load_pathname mtg(1).load_filename]);
cd ..

if exist('mtg2')
    
    if isstruct(mtg2)
    
        temp_diff = length(fields(mtg1))-length(fields(mtg2));

        if temp_diff > 0
            temp_fields = fields(mtg1);  
            for i_add = abs(temp_diff):-1:1
                eval(['mtg2.' temp_fields{end-i_add+1} ' = [];']);
            end
        elseif temp_diff < 0
            temp_fields = fields(mtg2);  
            for i_add = abs(temp_diff):-1:1
                eval(['mtg1.' temp_fields{end-i_add+1} ' = [];']);
            end
        end

        mtg = [mtg1 mtg2];
    end
end

if ~isfield(mtg,'n_mtgs')
    mtg.n_mtgs = 1;
end

% if ~exist('helm') %for the EMM montages



for i_mtg = 1:mtg(1).n_mtgs
    
    if ~isfield(mtg,'n_wvls')
        mtg(i_mtg).n_wvls = 1;
    end
      
    mtg(i_mtg).file_load = 1;
end
delete(handles.figure1)
   

            
AssignMuxGUI;


% --- Executes on button press in OkButton.
function OkButton_Callback(hObject, eventdata, handles)
% hObject    handle to OkButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%This gives back to the workspace all of the entries 

global mtg helm

mtg(1).n_mtgs = str2double(get(handles.NMtgs,'String'));


for i_mtg = 1:mtg(1).n_mtgs  %loop through montages and set up the structure
    
    mtg(i_mtg).mtg_number = i_mtg;
    mtg(i_mtg).n_mtgs = str2double(get(handles.NMtgs,'String'));
    mtg(i_mtg).n_wvls = str2double(get(handles.NWvls,'String'));
    mtg(i_mtg).n_dets = str2double(get(handles.NDets,'String')); % returns contents of NDets as a double

    mtg(i_mtg).n_srcs = str2double(get(handles.NSrcs,'String'));
    mtg(i_mtg).n_muxs = str2double(get(handles.NMuxs,'String'));

    mtg(i_mtg).n_banks = ceil(mtg(i_mtg).n_srcs/mtg(i_mtg).n_muxs);
    mtg(i_mtg).min_dist = str2double(get(handles.MinDist,'String'));
    mtg(i_mtg).max_dist = str2double(get(handles.MaxDist,'String'));

    if mtg(i_mtg).n_wvls == 2                    %solving for two detectors is equivalent to this (Mathewson, Owens, et al., in prep);
       mtg(i_mtg).n_srcs =  mtg(i_mtg).n_srcs/2;
        mtg(i_mtg).n_muxs = mtg(i_mtg).n_muxs/2;   
    end

    contents = cellstr(get(handles.HelmetType,'String')); %returns HelmetType contents as cell array
    mtg(i_mtg).helmet_type = contents{get(handles.HelmetType,'Value')}; %returns selected item from HelmetType

    if strcmp(mtg(i_mtg).helmet_type, 'Custom');
        %get the path
        cd elp
        [mtg(1).elp_file mtg(1).elp_path] = uigetfile('*.elp','Select .elp 3D coordinate file:');
        cd ..
    end
        
        
    mtg(i_mtg).auto_srcs = get(handles.AutoSrcs,'Value');  %returns toggle state of AutoSrcs %move to SchemGUI as button
    mtg(i_mtg).mod_mux = get(handles.ModMuxFlag,'Value'); %returns toggle state of modulation frequency multiplexing option for imagent 2
    
    helm.det_space = 4;
    helm.src_space = 10;
    
    
end
delete(handles.figure1)
SchemGUI

function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to NMtgs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NMtgs as text
%        str2double(get(hObject,'String')) returns contents of NMtgs as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NMtgs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ModMuxFlag.
function ModMuxFlag_Callback(hObject, eventdata, handles)
% hObject    handle to ModMuxFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ModMuxFlag
