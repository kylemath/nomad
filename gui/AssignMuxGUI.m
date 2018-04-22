function varargout = AssignMuxGUI(varargin)
% ASSIGNMUXGUI MATLAB code for AssignMuxGUI.fig
%      ASSIGNMUXGUI, by itself, creates a new ASSIGNMUXGUI or raises the existing
%      singleton*.
%
%      H = ASSIGNMUXGUI returns the handle to a new ASSIGNMUXGUI or the handle to
%      the existing singleton*.
%
%      ASSIGNMUXGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSIGNMUXGUI.M with the given input arguments.
%
%      ASSIGNMUXGUI('Property','Value',...) creates a new ASSIGNMUXGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AssignMuxGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AssignMuxGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AssignMuxGUI

% Last Modified by GUIDE v2.5 06-Feb-2013 17:36:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AssignMuxGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AssignMuxGUI_OutputFcn, ...
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


% --- Executes just before AssignMuxGUI is made visible.
function AssignMuxGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AssignMuxGUI (see VARARGIN)

% Choose default command line output for AssignMuxGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AssignMuxGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

axes(handles.axes4)
axis off;
axes(handles.axes3) 
axis off;

% % This creates the 'background' axes
% ha = axes('units','normalized', ...
% 'position',[0 0 1 1]);
% 
% % Move the background axes to the bottom
% uistack(ha,'bottom');
% 
% % Load in a background image and display it using the correct colors
% % The image used below, is in the Image Processing Toolbox. If you do not have %access to this toolbox, you can use another image file instead.
% I=imread('nomad.jpg');
% hi = imagesc(I);
% colormap gray
% 
% % Turn the handlevisibility off so that we don't inadvertently plot into the axes again
% % Also, make the axes invisible
% set(ha,'handlevisibility','off', ...
% 'visible','off')

global mtg 

if ~isfield(mtg,'mux_numbers')
    for i_mtg = 1:mtg(1).n_mtgs
        mtg(i_mtg).mux_numbers = zeros(mtg.n_srcs,1);
    end
end



mtg(1).Parallel_toggle = 0;
mtg(1).current = 1;


contents = cellstr(get(handles.SchemClrList,'String'));
mtg(mtg(1).current).schem_clr = contents{get(handles.SchemClrList,'Value')}; 
mtg(mtg(1).current).bank_choose = 0; %Flag to replace the grey with chosen colour

% mtg(1).schem_clr = 'Custom';
% mtg(1).bank_choose = 0;


%populate the list of mtgs
for i_mtg = 1:mtg(1).n_mtgs
    mtg_name{i_mtg} = num2str(i_mtg);
end
set(handles.Current_montage,'String',mtg_name); % select_voice is popup menu tag


%adjust the settings to what was originally selected
if mtg(1).n_wvls == 2
    set(handles.NMuxs,'String',num2str(mtg(1).n_muxs*2));
elseif mtg(1).n_wvls == 1
    set(handles.NMuxs,'String',num2str(mtg(1).n_muxs));
end





guidata(hObject,handles);




% --- Outputs from this function are returned to the command line.
function varargout = AssignMuxGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Done_Button.
function Done_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Done_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%This gives back to the workspace all of the entries 

global mtg helm

contents = cellstr(get(handles.SchemClrList,'String'));
mtg(mtg(1).current).schem_clr = contents{get(handles.SchemClrList,'Value')}; 
mtg(mtg(1).current).bank_choose = 0; %Flag to replace the grey with chosen colour

delete(handles.figure1)
OutputGUI



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



% --- Executes on selection change in MuxAssignList.
function MuxAssignList_Callback(hObject, eventdata, handles)
% hObject    handle to MuxAssignList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MuxAssignList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MuxAssignList


% --- Executes during object creation, after setting all properties.
function MuxAssignList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MuxAssignList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

global mtg helm 

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







% --- Executes on selection change in SchemClrList.
function SchemClrList_Callback(hObject, eventdata, handles)
% hObject    handle to SchemClrList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SchemClrList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SchemClrList


% --- Executes during object creation, after setting all properties.
function SchemClrList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SchemClrList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function NumTry_Callback(hObject, eventdata, handles)
% hObject    handle to NumTry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTry as text
%        str2double(get(hObject,'String')) returns contents of NumTry as a double


% --- Executes during object creation, after setting all properties.
function NumTry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Colour_Button.
function Colour_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Colour_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
global mtg helm

contents = str2double(get(handles.Current_montage,'String'));
mtg(1).current = contents(get(handles.Current_montage,'Value')); 
mtg(mtg(1).current).n_muxs = str2double(get(handles.NMuxs,'String'));
mtg(mtg(1).current).n_banks = ceil(mtg(mtg(1).current).n_srcs/mtg(mtg(1).current).n_muxs);
if mtg(mtg(1).current).n_wvls == 2                    %solving for two detectors is equivalent to this (Mathewson, Owens, et al., in prep);
    mtg(mtg(1).current).n_muxs = mtg(mtg(1).current).n_muxs/2;   
    mtg(mtg(1).current).n_banks = ceil((mtg(mtg(1).current).n_srcs*2)/(mtg(mtg(1).current).n_muxs*2));
end

contents = cellstr(get(handles.SchemClrList,'String'));
mtg(mtg(1).current).schem_clr = contents{get(handles.SchemClrList,'Value')}; 
mtg(mtg(1).current).bank_choose = 0; %Flag to replace the grey with chosen colour

contents = cellstr(get(handles.MuxAssignList,'String'));
mtg(mtg(1).current).mux_assign_type = contents{get(handles.MuxAssignList,'Value')}; 
mtg(mtg(1).current).n_trys = str2double(get(handles.NumTry,'String'));



%run the assignment and plot it
axes(handles.axes4)
cla
title('');
rotate3d off

axes(handles.axes3) 
title('');
cla
assign_the_mux;    % run the mux assignment
helm_draw_mtg; axis off;



% --- Executes on button press in Back_button.
function Back_button_Callback(hObject, eventdata, handles)
% hObject    handle to Back_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mtg helm
delete(handles.figure1)
SchemGUI
make_the_montage




% --- Executes on button press in Bananas_Button.
function Bananas_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Bananas_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mtg helm

%plot the output stats and head coverage
axes(handles.axes3) 
cla
axis off;
title('');
axes(handles.axes4) 
cla
title('');
mtg_head_plot; rotate3d on; axis off;
% Turn on rotation and fix aspect ratio.
axis(gca,'vis3d');



% plot the graphs in clique form
%         [fig1 ph plot_i plot_handle]=helm_draw_sch; % Display the graph, - add to GUI
%         set(plot_i,'currentaxes',plot_handle(1)) %update the scatterplot with the graph
%         gplot(mtg(1).E_mat,mtg(1).src_xy);


% --- Executes on selection change in Current_montage.
function Current_montage_Callback(hObject, eventdata, handles)
% hObject    handle to Current_montage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Current_montage contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Current_montage

global mtg

contents = str2double(get(handles.Current_montage,'String'));
mtg(1).current = contents(get(handles.Current_montage,'Value')); 


% --- Executes during object creation, after setting all properties.
function Current_montage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Current_montage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Parallel_Toggle.
function Parallel_Toggle_Callback(hObject, eventdata, handles)
% hObject    handle to Parallel_Toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Parallel_Toggle
global mtg

mtg(1).Parallel_toggle = get(hObject,'Value');
if get(hObject,'Value') == 1
    matlabpool
elseif get(hObject,'Value') == 0
    matlabpool close
end


% --- Executes on button press in Show_montage.
function Show_montage_Callback(hObject, eventdata, handles)
% hObject    handle to Show_montage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mtg helm
axes(handles.axes4)
cla
axis off;
title('');
rotate3d off
axes(handles.axes3) 
cla
title('');
helm_draw_mtg; axis off;


% --- Executes on button press in StatButton.
function StatButton_Callback(hObject, eventdata, handles)
% hObject    handle to StatButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mtg helm
axes(handles.axes4)
cla
axis off;
rotate3d off
axes(handles.axes3) 
cla
channel_stat_plot; axis on;


% % --- Executes on button press in GraphForm.
% function GraphForm_Callback(hObject, eventdata, handles)
% % hObject    handle to GraphForm (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% global mtg helm
% axes(handles.axes4)
% cla
% axis off;
% rotate3d off
% axes(handles.axes3) 
% cla
% addpath(genpath('..\matgraph\'));
% plotgraph; axis off;


% --- Executes on button press in VerificationButton.
function VerificationButton_Callback(hObject, eventdata, handles)
% hObject    handle to VerificationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mtg helm
for i_mtg = 1:mtg(1).n_mtgs
    %% Converts into a graph for easier computation and ploting
    mtg(i_mtg).V = 1:mtg(i_mtg).n_srcs;
    mtg(i_mtg).E = [];
    mtg(i_mtg).E_mat = zeros(length(mtg(i_mtg).V));
    i_edge = 1;
    for i_det = 1:mtg(i_mtg).n_dets
        clique = find(mtg(i_mtg).close_dets(:,i_det) == 1);
        for i_cli = 1:length(clique)-1
            for i_cli2 = i_cli+1:length(clique)
                if mtg(i_mtg).E_mat(clique(i_cli),clique(i_cli2)) == 0

                    mtg(i_mtg).E(i_edge,:) = [clique(i_cli) clique(i_cli2)];
                    mtg(i_mtg).E_mat(clique(i_cli),clique(i_cli2)) = 1;
                    mtg(i_mtg).E_mat(clique(i_cli2),clique(i_cli)) = 1;
                    i_edge = i_edge+1;
                end
            end
        end
    end
end


MathewsonMuxCheck
