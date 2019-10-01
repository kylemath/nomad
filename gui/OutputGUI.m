function varargout = OutputGUI(varargin)
% OUTPUTGUI M-file for OutputGUI.fig
%      OUTPUTGUI, by itself, creates a new OUTPUTGUI or raises the existing
%      singleton*.
%
%      H = OUTPUTGUI returns the handle to a new OUTPUTGUI or the handle to
%      the existing singleton*.
%
%      OUTPUTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OUTPUTGUI.M with the given input arguments.
%
%      OUTPUTGUI('Property','Value',...) creates a new OUTPUTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OutputGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OutputGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OutputGUI

% Last Modified by GUIDE v2.5 01-Oct-2019 14:13:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OutputGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OutputGUI_OutputFcn, ...
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


% --- Executes just before OutputGUI is made visible.
function OutputGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OutputGUI (see VARARGIN)

% Choose default command line output for OutputGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OutputGUI wait for user response (see UIRESUME)
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
function varargout = OutputGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SchemSaveButt.
function SchemSaveButt_Callback(hObject, eventdata, handles)
% hObject    handle to SchemSaveButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mtg

mtg(1).bank_choose = 0; %Flag to replace the grey with chosen colour


if strcmp(mtg(1).schem_clr,'Custom');  %custom bank colours  %adjust for dual wvl
    mtg(1).bank_choose = 1;
    for i_mtg = 1:mtg(1).n_mtgs
        mtg(i_mtg).bank_clrs = zeros(4,3);
        for i_bank = 1:mtg(i_mtg).n_banks
            mtg(i_mtg).bank_clrs(i_bank,:) = uisetcolor(['Bank ' num2str(i_bank)]);
        end
    end
end

for i_mtg = 1:mtg(1).n_mtgs
    mtg(1).current = i_mtg;
    fig1 = helm_draw_mtg_out;
    title([mtg(i_mtg).helmet_type ' Helmet, Session ' char(64+i_mtg)]);
    [mtg(1).file_schem mtg(1).path_schem] = uiputfile('*.bmp','Save Schematic .bmp file');
    %Save the bmp files
    export_fig([mtg(1).path_schem mtg(1).file_schem], '-bmp', '-a4',fig1);
end
        



    






% --- Executes on button press in SaveMtgButt.
function SaveMtgButt_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMtgButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%This gives back to the workspace all of the entries 
global mtg

%get info from GUI

for i_mtg =1:mtg(1).n_mtgs
    
    if mtg(i_mtg).n_wvls == 1
        contents = str2double(get(handles.WaveList,'String'));
        mtg(i_mtg).wvl = contents(get(handles.WaveList,'Value')); % returns contents of WaveList as a double
    elseif mtg(i_mtg).n_wvls == 2
        mtg(i_mtg).wvl = str2double(get(handles.WaveList,'String'));
    end
    % mtg(i_mtg).wvl = contents(get(handles.WaveList,'Value')); % returns contents of WaveList as a double
    contents = str2double(get(handles.ModFList,'String'));
    mtg(i_mtg).mdf = contents(get(handles.ModFList,'Value')); %


    if strcmp(mtg(1).schem_clr,'DOIL') == 1 || strcmp(mtg(1).schem_clr,'CNL') == 1

        oxy2_dets = find(mtg(i_mtg).det_name(1:mtg(i_mtg).n_dets) < 'a');  %find all the oxy2
        oxy3_dets = find(mtg(i_mtg).det_name(1:mtg(i_mtg).n_dets) >= 'a'); %the others are opt3
        mtg(i_mtg).n_det2 = length(oxy2_dets);
        mtg(i_mtg).n_det3 = length(oxy3_dets);  %every third detector is from oxy 2 in the CNL upstairs

        if mtg(i_mtg).n_det2 * mtg(i_mtg).n_det3 == 0    %check if there are more than one oxyplex needed
            mtg(i_mtg).n_oxy = 1;
        else
            mtg(i_mtg).n_oxy = 2;
        end
    
    elseif strcmp(mtg(1).schem_clr,'APPLAB') == 1

        oxy2_dets = find(mtg(i_mtg).det_name(1:mtg(i_mtg).n_dets) < 'a'); % all letters are capitals
        mtg(i_mtg).n_det2 = length(oxy2_dets);
        mtg(i_mtg).n_oxy = 1;
    end

end


%run the function
Output_mtg_combined_good

%get the path
[mtg(1).file2 mtg(1).path2] = uiputfile('*.mtg','Save Combined *.mtg File');

%save the file
mtg(1).fid2 = fopen([mtg(1).path2 mtg(1).file2], 'w');
fprintf(mtg(1).fid2,'%s \r\n',mtg(1).out_mtg{1:2,1});
for i_line = 3:size(mtg(1).out_mtg,1)
    fprintf(mtg(1).fid2, '%s\t %s\t %s\t %s\t %s\t %s\t \r\n', mtg(1).out_mtg{i_line,1:6});
end
fclose(mtg(1).fid2); 
    
















% --- Executes on button press in CreateGraphDefButt.
function CreateGraphDefButt_Callback(hObject, eventdata, handles)
% hObject    handle to CreateGraphDefButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mtg



% contents = str2double(get(handles.OxyList,'String'));
% mtg.n_oxy = contents(get(handles.OxyList,'Value')); % 
% mtg1.n_oxy = mtg.n_oxy;
% mtg2.n_oxy = mtg.n_oxy;
    
% Opt2: 16 detectors, color-coded brown (opt2 is the trigger machine)
% Opt3: 8 detectors, color-coded grey
%
% Doil1: 8 detectors, color-coded grey (doil1 is the trigger)
% Doil2: 16 detectors, color-coded brown
%

% APPLAB: 15 Detectors, Color-coded grey



%get the path
[mtg(1).file_gdf mtg(1).path_gdf] = uiputfile('Folder','Select folder to save .gdf files');

for i_mtg = 1:mtg(1).n_mtgs
    if mtg(i_mtg).n_wvls == 1
        contents = str2double(get(handles.WaveList,'String'));
        mtg(i_mtg).wvl = contents(get(handles.WaveList,'Value')); % returns contents of WaveList as a double
    elseif mtg(i_mtg).n_wvls == 2
        mtg(i_mtg).wvl = str2double(get(handles.WaveList,'String'));
    end
    % mtg(i_mtg).wvl = contents(get(handles.WaveList,'Value')); % returns contents of WaveList as a double
    contents = str2double(get(handles.ModFList,'String'));
    mtg(i_mtg).mdf = contents(get(handles.ModFList,'Value')); %
    
    oxy2_dets = find(mtg(i_mtg).det_name(1:mtg(i_mtg).n_dets) < 'a');  %find all the oxy2
    oxy3_dets = find(mtg(i_mtg).det_name(1:mtg(i_mtg).n_dets) >= 'a'); %the others are opt3
    mtg(i_mtg).n_det2 = length(oxy2_dets);
    mtg(i_mtg).n_det3 = length(oxy3_dets);  
    
end

%resort by alphabet
[a i_sort] = sort(mtg(1).det_name(oxy2_dets));
oxy2_dets = oxy2_dets(i_sort);
[a i_sort] = sort(mtg(1).det_name(oxy3_dets));
oxy3_dets = oxy3_dets(i_sort);

if mtg(i_mtg).n_det2 * mtg(i_mtg).n_det3 == 0    %check if there are more than one oxyplex needed
    mtg(i_mtg).n_oxy = 1;
else
    mtg(i_mtg).n_oxy = 2;
end

imagent_name = mtg(1).schem_clr;

for i_mtg = 1:mtg(1).n_mtgs
    

    %finds closest of each mux to each detector and records the distance
    mtg(i_mtg).dist = zeros(mtg(i_mtg).n_dets,mtg(i_mtg).n_muxs);  
    for i_det = 1:mtg(i_mtg).n_dets
        for i_mux = 1:mtg(i_mtg).n_muxs
            mtg(i_mtg).dist(i_det,i_mux) = min(mtg(i_mtg).src_dist(i_det,mtg(i_mtg).mux_numbers == i_mux));
        end
    end
    mtg(i_mtg).dist2 = mtg(i_mtg).dist(oxy2_dets,:);
    mtg(i_mtg).dist3 = mtg(i_mtg).dist(oxy3_dets,:);


    path = [mtg(1).path_gdf mtg(i_mtg).helmet_type filesep imagent_name '1' filesep 'Sesh' char(64+i_mtg) filesep];
    if ~exist(path)
        mkdir(path)
    end
    GDFTextFileGenerator_KM(mtg(i_mtg).dist2,[mtg(i_mtg).helmet_type '_Sesh' char(64+i_mtg) '_' imagent_name '1'],path,i_mtg);
    mtg(i_mtg).colorCodes2 = mtg(i_mtg).colorCodes;

    path = [mtg(1).path_gdf mtg(i_mtg).helmet_type filesep imagent_name '2' filesep 'Sesh' char(64+i_mtg) filesep];
    if ~exist(path)
        mkdir(path)
    end
    GDFTextFileGenerator_KM(mtg(i_mtg).dist3,[mtg(i_mtg).helmet_type '_Sesh' char(64+i_mtg) '_' imagent_name '2'],path,i_mtg);   
    mtg(i_mtg).colorCodes3 = mtg(i_mtg).colorCodes;

end




%Create a image of the distance matrices color coded the same way
cm = make_colormap;

scrsz = get(0,'ScreenSize');
fig1=figure('Position',[1 1 scrsz(3)/1.1 scrsz(4)/1.1],'Color',[.8 .8 .8]);
axis off

for i_mtg = 1:mtg(1).n_mtgs
    
    if mtg(i_mtg).n_det3 > 0
        
        subplot(3,3,[1+(i_mtg-1) 4+(i_mtg-1)]); image(mtg(i_mtg).dist3); colormap(cm); axis equal; ylabel([imagent_name '2']); xlabel('Mux Number'); title(['Session ' char(64+i_mtg)]); axis tight;
        hold on
        for i_det = 1:mtg(i_mtg).n_det3
            for i_mux = 1:mtg(i_mtg).n_muxs
                if mtg(i_mtg).dist3(i_det,i_mux) < 99
                    if mtg(i_mtg).dist3(i_det,i_mux) <38 && mtg(i_mtg).dist3(i_det,i_mux) >25
                        dist_clr = [1 1 1];
                    else
                        dist_clr = [0 0 0];
                    end
                 
                    text(i_mux-.25,i_det,num2str(round(mtg(i_mtg).dist3(i_det,i_mux))),'Color',dist_clr);
                end
            end
        end
        for i=65:64+size(mtg(i_mtg).dist3,1)
            labels3{i-64} = char(i);
        end
        for i=65:64+size(mtg(i_mtg).dist3,1)
            labels3{i-64} = char(i);
        end
        
        set(gca,'XTick',1:mtg(i_mtg).n_muxs)
        if mtg(i_mtg).n_wvls == 2
            set(gca,'XTickLabel',1:2:mtg(i_mtg).n_muxs*2)
        else
            set(gca,'XTickLabel',1:mtg(i_mtg).n_muxs)
        end
        
        set(gca,'YTick',1:size(mtg(i_mtg).dist3,1))
        set(gca,'YTickLabel',labels3)
        
        
        
    end
    if mtg(i_mtg).n_det2 >0
        
        subplot(3,3,7+(i_mtg-1)); image(mtg(i_mtg).dist2); colormap(cm); axis equal;  xlabel('Mux Number'); ylabel([imagent_name '1']); title(['Session ' char(64+i_mtg)]); axis tight;
        hold on
        for i_det = 1:mtg(i_mtg).n_det2
            for i_mux = 1:mtg(i_mtg).n_muxs
                if mtg(i_mtg).dist2(i_det,i_mux) < 99
                    if mtg(i_mtg).dist2(i_det,i_mux) <38 && mtg(i_mtg).dist2(i_det,i_mux) >25
                        dist_clr = [1 1 1];
                    else
                        dist_clr = [0 0 0];
                    end
                    text(i_mux-.25,i_det,num2str(round(mtg(i_mtg).dist2(i_det,i_mux))),'Color',dist_clr);
                end
            end
        end
        for i=65:64+size(mtg(i_mtg).dist2,1)
            labels2{i-64} = char(i);
        end
        
        set(gca,'XTick',1:mtg(i_mtg).n_muxs)
        if mtg(i_mtg).n_wvls == 2
            set(gca,'XTickLabel',1:2:mtg(i_mtg).n_muxs*2)
        else
            set(gca,'XTickLabel',1:mtg(i_mtg).n_muxs)
        end
        set(gca,'YTick',1:size(mtg(i_mtg).dist2,1) )
        set(gca,'YTickLabel',labels2)
        
    end
end

subplot(3,3,6); axis tight; axis off; colorbar; title([mtg(1).helmet_type ' Helmet']);
                
[mtg(1).file_dist mtg(1).path_dist] = uiputfile('*.bmp','Save Distance Schematic .bmp');
%Save the bmp files
export_fig([mtg(1).path_dist mtg(1).file_dist], '-bmp', '-a4',fig1);










% --- Executes on button press in SaveDataButt.
function SaveDataButt_Callback(hObject, eventdata, handles)
% hObject    handle to SaveDataButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mtg helm


[mtg(1).datafile mtg(1).datapath] = uiputfile('*.mat','Save Workspace as *.mat file');
%Save the mtg structure as a .mat files
save([mtg(1).datapath mtg(1).datafile],'mtg','helm','-mat');


% --- Executes on button press in ExitButt.
function ExitButt_Callback(hObject, eventdata, handles)
% hObject    handle to ExitButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear all
close all

fprintf('Goodbye! Have a great day!');

% --- Executes on selection change in WaveList.
function WaveList_Callback(hObject, eventdata, handles)
% hObject    handle to WaveList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns WaveList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from WaveList


% --- Executes during object creation, after setting all properties.
function WaveList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WaveList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in ModFList.
function ModFList_Callback(hObject, eventdata, handles)
% hObject    handle to ModFList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ModFList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ModFList


% --- Executes during object creation, after setting all properties.
function ModFList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModFList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in OxyList.
function OxyList_Callback(hObject, eventdata, handles)
% hObject    handle to OxyList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OxyList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OxyList


% --- Executes during object creation, after setting all properties.
function OxyList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OxyList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Back_button.
function Back_button_Callback(hObject, eventdata, handles)
% hObject    handle to Back_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mtg helm
AssignMuxGUI;
