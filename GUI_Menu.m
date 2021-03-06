function varargout = GUI_Menu(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Menu_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Menu_OutputFcn, ...
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


% --- Executes just before GUI_Menu is made visible.
function GUI_Menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Menu (see VARARGIN)

% Choose default command line output for GUI_Menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

but_bg1 = imread('src/button bg/Menu.png');
set(handles.Test_PCA,'CData', but_bg1);

but_bg2 = imread('src/button bg/Menu.png');
set(handles.Test_MoodPCA,'CData', but_bg2);

but_bg3 = imread('src/button bg/Menu.png');
set(handles.Test_HogFeatures,'CData', but_bg3);

but_bg4 = imread('src/button bg/Exit.png');
set(handles.exit,'CData', but_bg4);

% UIWAIT makes GUI_Menu wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0 0 1 1]);

% import the background image and show it on the axes
bg = imread('src/bg/1.jpg'); imagesc(bg);

%prevent plotting over the background and turn the axis oft
set(ah,'handlevisibility','off','visible','off');

%making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');

% --- Outputs from this function are returned to the command line.
function varargout = GUI_Menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function userName_Callback(hObject, eventdata, handles)
% hObject    handle to userName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of userName as text
%        str2double(get(hObject,'String')) returns contents of userName as a double

UI = get (handles.userName, 'String');
a= char(UI);
assignin('base', 'name', a);
% set(handles.text4, 'String', UI);


% --- Executes during object creation, after setting all properties.
function userName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to userName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

assignin ('base', 'CamType',1);
assignin ('base', 'name', []);


% --- Executes on button press in Test_PCA.
function Test_PCA_Callback(hObject, eventdata, handles)
% hObject    handle to Test_PCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Test_PCA
Text = get(handles.userName,'string');

if isempty(Text)
        warndlg('Please Enter Your Name to Continue..','Error');
else 
        evalin('base','TestPCA')
end 

%evalin('base','TestPCA')


% --- Executes on button press in Test_MoodPCA.
function Test_MoodPCA_Callback(hObject, eventdata, handles)
% hObject    handle to Test_MoodPCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Text = get(handles.userName,'string');

if isempty(Text)
        warndlg('Please Enter Your Name to Continue..','Error');
else 
        evalin('base','TestMoodPCA')
end 

% Hint: get(hObject,'Value') returns toggle state of Test_MoodPCA
%evalin('base','TestMoodPCA')

% --- Executes on button press in Test_HogFeatures.
function Test_HogFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to Test_HogFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Text = get(handles.userName,'string');

if isempty(Text)
        warndlg('Please Enter Your Name to Continue..','Error');
else 
        evalin('base','TestHOGG')
end 

% Hint: get(hObject,'Value') returns toggle state of Test_HogFeatures

%evalin('base','TestHOGG')

% --- Executes on button press in Test_TogetherForever.
function Test_TogetherForever_Callback(hObject, eventdata, handles)
% hObject    handle to Test_TogetherForever (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Test_TogetherForever
evalin('base','TestTogetherForever')

% --- Executes during object creation, after setting all properties.
function Test_PCA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Test_PCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Test_MoodPCA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Test_MoodPCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Test_HogFeatures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Test_HogFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Test_TogetherForever_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Test_TogetherForever (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in clearWorkspace.
function clearWorkspace_Callback(hObject, eventdata, handles)
% hObject    handle to clearWorkspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin( 'base', 'clearvars -except name CamType' )
set(handles.userName,'String',"");

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close (GUI_Menu)

% --- Executes during object creation, after setting all properties.
function clearWorkspace_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clearWorkspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function exit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in webCamChoice.
function webCamChoice_Callback(hObject, eventdata, handles)
% hObject    handle to webCamChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns webCamChoice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from webCamChoice
choice = get(hObject, 'Value');
assignin('base', 'CamType',choice)



% --- Executes during object creation, after setting all properties.
function webCamChoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to webCamChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
axes(hObject);
imshow('src\logo\logo.jpg');
% Hint: place code in OpeningFcn to populate axes1
