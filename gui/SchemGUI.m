function varargout = SchemGUI(varargin)
% SCHEMGUI MATLAB code for SchemGUI.fig
%      SCHEMGUI, by itself, creates a new SCHEMGUI or raises the existing
%      singleton*.
%
%      H = SCHEMGUI returns the handle to a new SCHEMGUI or the handle to
%      the existing singleton*.
%
%      SCHEMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCHEMGUI.M with the given input arguments.
%
%      SCHEMGUI('Property','Value',...) creates a new SCHEMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SchemGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SchemGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SchemGUI

% Last Modified by GUIDE v2.5 07-Feb-2013 03:34:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SchemGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SchemGUI_OutputFcn, ...
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


% --- Executes just before SchemGUI is made visible.
function SchemGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SchemGUI (see VARARGIN)

% Choose default command line output for SchemGUI
handles.output = hObject;



% UIWAIT makes SchemGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);



global mtg helm



%design the schematic
helmet_schem_maker

axes(handles.axes3) 
axis off;
title('');
cla

%pick the locations
make_the_montage;

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = SchemGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in restart_Button.
function restart_Button_Callback(hObject, eventdata, handles)
% hObject    handle to restart_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
global mtg helm

    

%run the assignment and plot it
delete(handles.figure1)
SchemGUI




% --- Executes on button press in Done_Button.
function Done_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Done_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%This gives back to the workspace all of the entries 

global mtg helm
delete(handles.figure1)
AssignMuxGUI


% --- Executes on button press in Back_button.
function Back_button_Callback(hObject, eventdata, handles)
% hObject    handle to Back_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mtg helm
SettingGUI
delete(handles.figure1)


% --- Executes during object creation, after setting all properties.
function MainAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MainAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate MainAxes


% --- Executes on button press in SpaceDetBut.
function SpaceDetBut_Callback(hObject, eventdata, handles)
% hObject    handle to SpaceDetBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mtg helm

helm.det_space = helm.det_space + 2;
helmet_schem_maker
delete(handles.figure1)
SchemGUI


% --- Executes on button press in SqueezeDetBut.
function SqueezeDetBut_Callback(hObject, eventdata, handles)
% hObject    handle to SqueezeDetBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mtg helm


helm.det_space = helm.det_space - 2;
helmet_schem_maker
delete(handles.figure1)
SchemGUI


% --- Executes on button press in SpaceSrcBut.
function SpaceSrcBut_Callback(hObject, eventdata, handles)
% hObject    handle to SpaceSrcBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mtg helm

helm.src_space = helm.src_space + 2;
helmet_schem_maker
delete(handles.figure1)
SchemGUI

% --- Executes on button press in SqueezeSrcBut.
function SqueezeSrcBut_Callback(hObject, eventdata, handles)
% hObject    handle to SqueezeSrcBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mtg helm


helm.src_space = helm.src_space - 2;
helmet_schem_maker
delete(handles.figure1)
SchemGUI
