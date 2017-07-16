function varargout = pandemicOriginal(varargin)
% PANDEMICORIGINAL MATLAB code for pandemicOriginal.fig
%      PANDEMICORIGINAL, by itself, creates a new PANDEMICORIGINAL or raises the existing
%      singleton*.
%
%      H = PANDEMICORIGINAL returns the handle to a new PANDEMICORIGINAL or the handle to
%      the existing singleton*.
%
%      PANDEMICORIGINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PANDEMICORIGINAL.M with the given input arguments.
%
%      PANDEMICORIGINAL('Property','Value',...) creates a new PANDEMICORIGINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pandemicOriginal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pandemicOriginal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pandemicOriginal

% Last Modified by GUIDE v2.5 01-Jun-2016 13:29:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pandemicOriginal_OpeningFcn, ...
                   'gui_OutputFcn',  @pandemicOriginal_OutputFcn, ...
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


% --- Executes just before pandemicOriginal is made visible.
function pandemicOriginal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pandemicOriginal (see VARARGIN)

% Choose default command line output for pandemicOriginal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

handles.infectionRateText.String = '2';
handles.safeTurnsText.String = 0;
handles.turnsLeftText.String = num2str(26);
handles.epidemicChanceText.String = [num2str((2/10)*100), '%'];

infectionDeckSetUpF(handles)

% UIWAIT makes pandemicOriginal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pandemicOriginal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in infectCitiesButton.
function infectCitiesButton_Callback(hObject, eventdata, handles)
% hObject    handle to infectCitiesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infectionRate = getappdata(gcf, 'infectionRate');
infectionDeck = getappdata(gcf, 'infectionDeck');
handles.turnsLeftText.String = num2str(str2double(handles.turnsLeftText.String)-1);
handles.previewText.String = {};
counter = 0;
for iDraw = 1:infectionRate
    for istep = 1:48
        if infectionDeck(istep).location == 1 && ~strcmp(infectionDeck(istep).color, 'out')
            counter = counter + 1;
            infectedCities{counter} = infectionDeck(istep).name;
        end
    end
    for istep = 1:48
        infectionDeck(istep).location = infectionDeck(istep).location - 1;
    end
end
if length(infectedCities) < infectionRate
    for istep = 1:48
        if infectionDeck(istep).location == 1
            infectedCities{length(infectedCities)+1} = infectionDeck(istep).name;
        end
    end
    for istep = 1:48
        infectionDeck(istep).location = infectionDeck(istep).location - 1;
    end
end
    
handles.infectText.String = infectedCities;
discardPile = getappdata(gcf, 'discardPile');
discardPile = [discardPile, infectedCities];
setappdata(gcf, 'discardPile', discardPile);
setappdata(gcf, 'infectionDeck', infectionDeck);
setappdata(gcf, 'infectedCities', infectedCities);

% --- Executes on button press in epidemicButton.
function epidemicButton_Callback(hObject, eventdata, handles)
% hObject    handle to epidemicButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
epidemics = getappdata(gcf, 'epidemics');
infectionRate = getappdata(gcf, 'infectionRate');
infectionDeck = getappdata(gcf, 'infectionDeck');
highestLocation = getappdata(gcf, 'highestLocation');
ndiscardPile = getappdata(gcf, 'ndiscardPile');
epidemics = epidemics + 1;
if epidemics > 2 && epidemics < 5
    infectionRate = 3;
elseif epidemics >= 5
    infectionRate = 4;
end
for istep = 1:48
    if infectionDeck(istep).location > highestLocation
        highestLocation = infectionDeck(istep).location;
        bottomCard = istep;
    end
end
handles.epidemicText.String = infectionDeck(bottomCard).name;
infectionDeck(bottomCard).location = 0;
for icard = 1:48
    if infectionDeck(icard).location <= 0
        ndiscardPile = ndiscardPile + 1;
    end
end
postEpidemicLocations = randperm(ndiscardPile);
counter = 0;
for icard = 1:48
    if infectionDeck(icard).location <= 0
        counter = counter + 1;
        infectionDeck(icard).location = postEpidemicLocations(counter);
    else
        infectionDeck(icard).location = infectionDeck(icard).location + ndiscardPile;
    end
end
setappdata(gcf, 'epidemics', epidemics);
setappdata(gcf, 'infectionRate', infectionRate);
setappdata(gcf, 'infectionDeck', infectionDeck);


function infectText_Callback(hObject, eventdata, handles)
% hObject    handle to infectText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of infectText as text
%        str2double(get(hObject,'String')) returns contents of infectText as a double


% --- Executes during object creation, after setting all properties.
function infectText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to infectText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epidemicText_Callback(hObject, eventdata, handles)
% hObject    handle to epidemicText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epidemicText as text
%        str2double(get(hObject,'String')) returns contents of epidemicText as a double


% --- Executes during object creation, after setting all properties.
function epidemicText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epidemicText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in infectResolveButton.
function infectResolveButton_Callback(hObject, eventdata, handles)
% hObject    handle to infectResolveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
discardPile = getappdata(gcf, 'discardPile');
infectionRate = getappdata(gcf, 'infectionRate');
infectedCities = getappdata(gcf, 'infectedCities');
topDrawPile = getappdata(gcf, 'topDrawPile');
upperDrawPile = getappdata(gcf, 'upperDrawPile');
middleDrawPile = getappdata(gcf, 'middleDrawPile');
lowerDrawPile = getappdata(gcf, 'lowerDrawPile');
if length(topDrawPile) > length(infectedCities)
    for istep = 1:length(infectedCities)
        endloop = false;
        for icheck = 1:length(topDrawPile)
            if endloop == false
                if strcmp(topDrawPile{icheck}, infectedCities{istep})
                    topDrawPile(icheck) = [];
                    endloop = true;
                end
            end
        end
    end
else
    if ~isempty(upperDrawPile)
        for istep = 1:length(infectedCities)
            endloop = false;
            for icheck = 1:length(upperDrawPile)
                if endloop == false
                    if strcmp(upperDrawPile{icheck}, infectedCities{istep})
                        upperDrawPile(icheck) = [];
                        endloop = true;
                    end
                end
            end
        end
        topDrawPile = upperDrawPile;
        if ~isempty(middleDrawPile)
            upperDrawPile = middleDrawPile;
            if ~isempty(lowerDrawPile)
                middleDrawPile = lowerDrawPile;
                lowerDrawPile = {};
            else
                middleDrawPile = {};
            end
        else
            upperDrawPile = {};
        end
    else
        topDrawPile = {};
    end
end
handles.infectText.String = '';
handles.discardText.String = discardPile;
handles.topDrawText.String = topDrawPile;
handles.upperDrawText.String = upperDrawPile;
handles.middleDrawText.String = middleDrawPile;
handles.lowerDrawText.String = lowerDrawPile;
setappdata(gcf, 'topDrawPile', topDrawPile);
setappdata(gcf, 'upperDrawPile', upperDrawPile);
setappdata(gcf, 'middleDrawPile', middleDrawPile);
setappdata(gcf, 'lowerDrawPile', lowerDrawPile);

epidemics = getappdata(gcf, 'epidemics');
switch epidemics
    case 0
        switch handles.eventCardsPopup.Value
            case 1
                handles.epidemicChanceText.String = [num2str(2/(str2double(handles.turnsLeftText.String)*2 - 42)*100), '%'];
            case 2
                if (str2double(handles.turnsLeftText.String)*2 - 45) == 1
                    handles.epidemicChanceText.String = '100%';
                else
                    handles.epidemicChanceText.String = [num2str(2/(str2double(handles.turnsLeftText.String)*2 - 45)*100), '%'];
                end
        end
    case 1
        switch handles.eventCardsPopup.Value
            case 1
                switch str2double(handles.turnsLeftText.String)
                    case 25
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 4;
                    case 24
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 3;
                    case 23
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 2;
                    case 22
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 1;
                    case 21
                        handles.epidemicChanceText.String = [num2str(2/10*100), '%'];
                    case 20
                        handles.epidemicChanceText.String = [num2str(2/8*100), '%'];
                    case 19
                        handles.epidemicChanceText.String = [num2str(2/6*100), '%'];
                    case 18
                        handles.epidemicChanceText.String = [num2str(2/4*100), '%'];
                    case 17
                        handles.epidemicChanceText.String = '100%';
                end
            case 2
                switch str2double(handles.turnsLeftText.String)
                    case 27
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 4;
                    case 26
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 3;
                    case 25
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 2;
                    case 24
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 1;
                    case 23
                        handles.epidemicChanceText.String = [num2str(1/11*100), '%'];
                    case 22
                        handles.epidemicChanceText.String = [num2str(2/10*100), '%'];
                    case 21
                        handles.epidemicChanceText.String = [num2str(2/8*100), '%'];
                    case 20
                        handles.epidemicChanceText.String = [num2str(2/6*100), '%'];
                    case 19
                        handles.epidemicChanceText.String = [num2str(2/4*100), '%'];
                    case 18
                        handles.epidemicChanceText.String = '100%';
                end
        end
    case 2
        switch handles.eventCardsPopup.Value
            case 1
                switch str2double(handles.turnsLeftText.String)
                    case 20
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 4;
                    case 19
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 3;
                    case 18
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 2;
                    case 17
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 1;
                    case 16
                        handles.epidemicChanceText.String = [num2str(2/10*100), '%'];
                    case 15
                        handles.epidemicChanceText.String = [num2str(2/8*100), '%'];
                    case 14
                        handles.epidemicChanceText.String = [num2str(2/6*100), '%'];
                    case 13
                        handles.epidemicChanceText.String = [num2str(2/4*100), '%'];
                    case 12
                        handles.epidemicChanceText.String = '100%';
                end
            case 2
                switch str2double(handles.turnsLeftText.String)
                    case 22
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 5;
                    case 21
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 4;
                    case 20
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 3;
                    case 19
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 2;
                    case 18
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 1;
                    case 17
                        handles.epidemicChanceText.String = [num2str(2/11*100), '%'];
                    case 16
                        handles.epidemicChanceText.String = [num2str(2/9*100), '%'];
                    case 15
                        handles.epidemicChanceText.String = [num2str(2/7*100), '%'];
                    case 14
                        handles.epidemicChanceText.String = [num2str(2/5*100), '%'];
                    case 13
                        handles.epidemicChanceText.String = [num2str(2/3*100), '%'];
                    case 12
                        handles.epidemicChanceText.String = '100%';
                end
        end
    case 3
        switch handles.eventCardsPopup.Value
            case 1
                switch str2double(handles.turnsLeftText.String)
                    case 15
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 4;
                    case 14
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 3;
                    case 13
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 2;
                    case 12
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 1;
                    case 11
                        handles.epidemicChanceText.String = [num2str(2/10*100), '%'];
                    case 10
                        handles.epidemicChanceText.String = [num2str(2/8*100), '%'];
                    case 9
                        handles.epidemicChanceText.String = [num2str(2/6*100), '%'];
                    case 8
                        handles.epidemicChanceText.String = [num2str(2/4*100), '%'];
                    case 7
                        handles.epidemicChanceText.String = '100%';
                end
            case 2
                switch str2double(handles.turnsLeftText.String)
                    case 16
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 4;
                    case 15
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 3;
                    case 14
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 2;
                    case 13
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 1;
                    case 12
                        handles.epidemicChanceText.String = [num2str(1/11*100), '%'];
                    case 11
                        handles.epidemicChanceText.String = [num2str(2/10*100), '%'];
                    case 10
                        handles.epidemicChanceText.String = [num2str(2/8*100), '%'];
                    case 9
                        handles.epidemicChanceText.String = [num2str(2/6*100), '%'];
                    case 8
                        handles.epidemicChanceText.String = [num2str(2/4*100), '%'];
                    case 7
                        handles.epidemicChanceText.String = '100%';
                end
        end
    case 4
        switch handles.eventCardsPopup.Value
            case 1
                switch str2double(handles.turnsLeftText.String)
                    case 10
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 4;
                    case 9
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 3;
                    case 8
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 2;
                    case 7
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 1;
                    case 6
                        handles.epidemicChanceText.String = [num2str(2/10*100), '%'];
                    case 5
                        handles.epidemicChanceText.String = [num2str(2/8*100), '%'];
                    case 4
                        handles.epidemicChanceText.String = [num2str(2/6*100), '%'];
                    case 3
                        handles.epidemicChanceText.String = [num2str(2/4*100), '%'];
                    case 2
                        handles.epidemicChanceText.String = '100%';
                    case 1
                        handles.epidemicChanceText.String = 'End';
                end
            case 2
                switch str2double(handles.turnsLeftText.String)
                    case 11
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 5;
                    case 10
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 4;
                    case 9
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 3;
                    case 8
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 2;
                    case 7
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 1;
                    case 6
                        handles.epidemicChanceText.String = [num2str(2/11*100), '%'];
                    case 5
                        handles.epidemicChanceText.String = [num2str(2/9*100), '%'];
                    case 4
                        handles.epidemicChanceText.String = [num2str(2/7*100), '%'];
                    case 3
                        handles.epidemicChanceText.String = [num2str(2/5*100), '%'];
                    case 2
                        handles.epidemicChanceText.String = [num2str(2/3*100), '%'];
                    case 1
                        handles.epidemicChanceText.String = 'End';
                end
        end
    case 5
        if strcmp(handles.turnsLeftText.String, '1')
            handles.epidemicChanceText.String = 'End';
        else
            handles.epidemicChanceText.String = '0%';
            handles.safeTurnsText.String = handles.turnsLeftText.String;
        end
end
if ~strcmp(handles.epidemicChanceText.String, '0%')
    handles.safeTurnsText.String = 0;
end

if infectionRate == 1
    oldInfectionRate = getappdata(gcf, 'oldInfectionRate');
    setappdata(gcf, 'infectionRate', oldInfectionRate);
    handles.infectionRateText.String = num2str(oldInfectionRate);
end

% --- Executes on button press in epidemicResolveButton.
function epidemicResolveButton_Callback(hObject, eventdata, handles)
% hObject    handle to epidemicResolveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infectionRate = getappdata(gcf, 'infectionRate');
handles.infectionRateText.String = num2str(infectionRate);
discardPile = getappdata(gcf, 'discardPile');
discardPile = [discardPile, {handles.epidemicText.String}];
if ~strcmp(handles.topDrawText.String, '')
    if ~strcmp(handles.upperDrawText.String, '')
        if ~strcmp(handles.middleDrawText.String, '')
            middleDrawPile = getappdata(gcf, 'middleDrawPile');
            lowerDrawPile = middleDrawPile;
            handles.lowerDrawText.String = lowerDrawPile;
            upperDrawPile = getappdata(gcf, 'upperDrawPile');
            middleDrawPile = upperDrawPile;
            handles.middleDrawText.String = middleDrawPile;
            topDrawPile = getappdata(gcf, 'topDrawPile');
            upperDrawPile = topDrawPile;
            handles.upperDrawText.String = upperDrawPile;
            topDrawPile = discardPile;
            handles.topDrawText.String = topDrawPile;
            setappdata(gcf, 'lowerDrawPile', lowerDrawPile);
            setappdata(gcf, 'middleDrawPile', middleDrawPile);
            setappdata(gcf, 'upperDrawPile', upperDrawPile);
            setappdata(gcf, 'topDrawPile', topDrawPile);
        else
            upperDrawPile = getappdata(gcf, 'upperDrawPile');
            middleDrawPile = upperDrawPile;
            handles.middleDrawText.String = middleDrawPile;
            topDrawPile = getappdata(gcf, 'topDrawPile');
            upperDrawPile = topDrawPile;
            handles.upperDrawText.String = upperDrawPile;
            topDrawPile = discardPile;
            handles.topDrawText.String = topDrawPile;
            setappdata(gcf, 'middleDrawPile', middleDrawPile);
            setappdata(gcf, 'upperDrawPile', upperDrawPile);
            setappdata(gcf, 'topDrawPile', topDrawPile);
        end
    else
        topDrawPile = getappdata(gcf, 'topDrawPile');
        upperDrawPile = topDrawPile;
        handles.upperDrawText.String = upperDrawPile;
        topDrawPile = discardPile;
        handles.topDrawText.String = topDrawPile;
        setappdata(gcf, 'upperDrawPile', upperDrawPile);
        setappdata(gcf, 'topDrawPile', topDrawPile);
    end
else
    topDrawPile = discardPile;
    handles.topDrawText.String = topDrawPile;
    setappdata(gcf, 'topDrawPile', topDrawPile);
end
handles.discardText.String = {};
handles.epidemicText.String = '';
setappdata(gcf, 'discardPile', {});

% --- Executes on button press in quietNightButton.
function quietNightButton_Callback(hObject, eventdata, handles)
% hObject    handle to quietNightButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
epidemics = getappdata(gcf, 'epidemics');
handles.turnsLeftText.String = num2str(str2double(handles.turnsLeftText.String)-1);
switch epidemics
    case 0
                handles.epidemicChanceText.String = [num2str(2/(str2double(handles.turnsLeftText.String)*2 - 42)*100), '%'];
    case 1
                switch str2double(handles.turnsLeftText.String)
                    case 25
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 4;
                    case 24
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 3;
                    case 23
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 2;
                    case 22
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 1;
                    case 21
                        handles.epidemicChanceText.String = [num2str(2/10*100), '%'];
                    case 20
                        handles.epidemicChanceText.String = [num2str(2/8*100), '%'];
                    case 19
                        handles.epidemicChanceText.String = [num2str(2/6*100), '%'];
                    case 18
                        handles.epidemicChanceText.String = [num2str(2/4*100), '%'];
                    case 17
                        handles.epidemicChanceText.String = '100%';
                end
    case 2
                switch str2double(handles.turnsLeftText.String)
                    case 20
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 4;
                    case 19
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 3;
                    case 18
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 2;
                    case 17
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 1;
                    case 16
                        handles.epidemicChanceText.String = [num2str(2/10*100), '%'];
                    case 15
                        handles.epidemicChanceText.String = [num2str(2/8*100), '%'];
                    case 14
                        handles.epidemicChanceText.String = [num2str(2/6*100), '%'];
                    case 13
                        handles.epidemicChanceText.String = [num2str(2/4*100), '%'];
                    case 12
                        handles.epidemicChanceText.String = '100%';
                end
    case 3
                switch str2double(handles.turnsLeftText.String)
                    case 15
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 4;
                    case 14
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 3;
                    case 13
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 2;
                    case 12
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 1;
                    case 11
                        handles.epidemicChanceText.String = [num2str(2/10*100), '%'];
                    case 10
                        handles.epidemicChanceText.String = [num2str(2/8*100), '%'];
                    case 9
                        handles.epidemicChanceText.String = [num2str(2/6*100), '%'];
                    case 8
                        handles.epidemicChanceText.String = [num2str(2/4*100), '%'];
                    case 7
                        handles.epidemicChanceText.String = '100%';
                end
    case 4
                switch str2double(handles.turnsLeftText.String)
                    case 10
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 4;
                    case 9
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 3;
                    case 8
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 2;
                    case 7
                        handles.epidemicChanceText.String = '0%';
                        handles.safeTurnsText.String = 1;
                    case 6
                        handles.epidemicChanceText.String = [num2str(2/10*100), '%'];
                    case 5
                        handles.epidemicChanceText.String = [num2str(2/8*100), '%'];
                    case 4
                        handles.epidemicChanceText.String = [num2str(2/6*100), '%'];
                    case 3
                        handles.epidemicChanceText.String = [num2str(2/4*100), '%'];
                    case 2
                        handles.epidemicChanceText.String = '100%';
                    case 1
                        handles.epidemicChanceText.String = 'End';
                end
    case 5
        if strcmp(handles.turnsLeftText.String, '1')
            handles.epidemicChanceText.String = 'End';
        else
            handles.epidemicChanceText.String = '0%';
            handles.safeTurnsText.String = handles.turnsLeftText.String;
        end
end
if ~strcmp(handles.epidemicChanceText.String, '0%')
    handles.safeTurnsText.String = 0;
end


function resilientPopText_Callback(hObject, eventdata, handles)
% hObject    handle to resilientPopText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resilientPopText as text
%        str2double(get(hObject,'String')) returns contents of resilientPopText as a double


% --- Executes during object creation, after setting all properties.
function resilientPopText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resilientPopText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resilientPopButton.
function resilientPopButton_Callback(hObject, eventdata, handles)
% hObject    handle to resilientPopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infectionDeck = getappdata(gcf, 'infectionDeck');
discardPile = getappdata(gcf, 'discardPile');
foundOne = false;
for istep = 1:48
    if strcmp(infectionDeck(istep).name, handles.resilientPopText.String)
        infectionDeck(istep).color = 'out';
        resPopCityName = infectionDeck(istep).name;
        foundOne = true;
        handles.resilientPopText.String = '';
    end
end
if foundOne == false;
    handles.resilientPopText.String = 'Try again';
else
    stopIt = false;
    for idiscard = 1:length(discardPile)
        if stopIt == false;
            if strcmp(discardPile{idiscard}, resPopCityName)
                discardPile(idiscard) = [];
                handles.discardText.String = discardPile;
                stopIt = true;
            end
        end
    end
end
setappdata(gcf, 'discardPile', discardPile);
setappdata(gcf, 'infectionDeck', infectionDeck);

function forecastText_Callback(hObject, eventdata, handles)
% hObject    handle to forecastText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of forecastText as text
%        str2double(get(hObject,'String')) returns contents of forecastText as a double


% --- Executes during object creation, after setting all properties.
function forecastText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to forecastText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function reorderText_Callback(hObject, eventdata, handles)
% hObject    handle to reorderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reorderText as text
%        str2double(get(hObject,'String')) returns contents of reorderText as a double


% --- Executes during object creation, after setting all properties.
function reorderText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reorderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in forecastButton.
function forecastButton_Callback(hObject, eventdata, handles)
% hObject    handle to forecastButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infectionDeck = getappdata(gcf, 'infectionDeck');
for istep = 1:48
    for iforecast = 1:6
        if infectionDeck(istep).location == iforecast
            forecastList{iforecast} = infectionDeck(istep).name;
        end
    end
end
handles.forecastText.String = forecastList;

% --- Executes on button press in reorderButton.
function reorderButton_Callback(hObject, eventdata, handles)
% hObject    handle to reorderButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
forecastOrder = handles.reorderText.String;
infectionDeck = getappdata(gcf, 'infectionDeck');
for istep = 1:48
    stopLoop = false;
    for iforecast = 1:6
        if infectionDeck(istep).location == iforecast && stopLoop == false;
            infectionDeck(istep).location = str2double(forecastOrder(iforecast));
            stopLoop = true;
        end
    end
end
handles.forecastText.String = '';
handles.reorderText.String = '';
setappdata(gcf, 'infectionDeck', infectionDeck);

function turnsLeftText_Callback(hObject, eventdata, handles)
% hObject    handle to turnsLeftText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of turnsLeftText as text
%        str2double(get(hObject,'String')) returns contents of turnsLeftText as a double


% --- Executes during object creation, after setting all properties.
function turnsLeftText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to turnsLeftText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epidemicChanceText_Callback(hObject, eventdata, handles)
% hObject    handle to epidemicChanceText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epidemicChanceText as text
%        str2double(get(hObject,'String')) returns contents of epidemicChanceText as a double


% --- Executes during object creation, after setting all properties.
function epidemicChanceText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epidemicChanceText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function safeTurnsText_Callback(hObject, eventdata, handles)
% hObject    handle to safeTurnsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of safeTurnsText as text
%        str2double(get(hObject,'String')) returns contents of safeTurnsText as a double


% --- Executes during object creation, after setting all properties.
function safeTurnsText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to safeTurnsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function infectionRateText_Callback(hObject, eventdata, handles)
% hObject    handle to infectionRateText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of infectionRateText as text
%        str2double(get(hObject,'String')) returns contents of infectionRateText as a double


% --- Executes during object creation, after setting all properties.
function infectionRateText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to infectionRateText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in initialinfectionButton.
function initialinfectionButton_Callback(hObject, eventdata, handles)
% hObject    handle to initialinfectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infectionDeck = getappdata(gcf, 'infectionDeck');
counter = 0;
for iDraw = 1:9
    for istep = 1:48
        if infectionDeck(istep).location == 1
            counter = counter + 1;
            initialInfection{counter} = infectionDeck(istep).name;
        end
    end
    for istep = 1:48
        infectionDeck(istep).location = infectionDeck(istep).location - 1;
    end
end
handles.initialText.String = initialInfection;
setappdata(gcf, 'discardPile', initialInfection)
setappdata(gcf, 'infectionDeck', infectionDeck);


function initialText_Callback(hObject, eventdata, handles)
% hObject    handle to initialText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initialText as text
%        str2double(get(hObject,'String')) returns contents of initialText as a double


% --- Executes during object creation, after setting all properties.
function initialText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initialText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in initialResolveButton.
function initialResolveButton_Callback(hObject, eventdata, handles)
% hObject    handle to initialResolveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
discardPile = getappdata(gcf, 'discardPile');
handles.discardText.String = discardPile;
handles.initialText.String = '';

% --- Executes on button press in endGameButton.
function endGameButton_Callback(hObject, eventdata, handles)
% hObject    handle to endGameButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infectionDeckSetUpF(handles);
handles.initialText.String = '';
handles.infectText.String = '';
handles.epidemicText.String = '';
handles.previewText.String = '';
handles.discardText.String = '';
handles.eventCardsPopup.Value = 1;
handles.topDrawText.String = {};
handles.upperDrawText.String = {};
handles.middleDrawText.String = {};
handles.lowerDrawText.String = {};

setappdata(gcf, 'topDrawPile', {});
setappdata(gcf, 'upperDrawPile', {});
setappdata(gcf, 'middleDrawPile', {});
setappdata(gcf, 'lowerDrawPile', {});
setappdata(gcf, 'discardPile', {});

handles.infectionRateText.String = '2';
handles.safeTurnsText.String = '0';
handles.turnsLeftText.String = '26';
handles.epidemicChanceText.String = [num2str((2/10)*100), '%'];
clc


function discardText_Callback(hObject, eventdata, handles)
% hObject    handle to discardText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of discardText as text
%        str2double(get(hObject,'String')) returns contents of discardText as a double


% --- Executes during object creation, after setting all properties.
function discardText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to discardText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function topDrawText_Callback(hObject, eventdata, handles)
% hObject    handle to topDrawText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of topDrawText as text
%        str2double(get(hObject,'String')) returns contents of topDrawText as a double


% --- Executes during object creation, after setting all properties.
function topDrawText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to topDrawText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upperDrawText_Callback(hObject, eventdata, handles)
% hObject    handle to upperDrawText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upperDrawText as text
%        str2double(get(hObject,'String')) returns contents of upperDrawText as a double


% --- Executes during object creation, after setting all properties.
function upperDrawText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upperDrawText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function middleDrawText_Callback(hObject, eventdata, handles)
% hObject    handle to middleDrawText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of middleDrawText as text
%        str2double(get(hObject,'String')) returns contents of middleDrawText as a double


% --- Executes during object creation, after setting all properties.
function middleDrawText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to middleDrawText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lowerDrawText_Callback(hObject, eventdata, handles)
% hObject    handle to lowerDrawText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowerDrawText as text
%        str2double(get(hObject,'String')) returns contents of lowerDrawText as a double


% --- Executes during object creation, after setting all properties.
function lowerDrawText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowerDrawText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in previewButton.
function previewButton_Callback(hObject, eventdata, handles)
% hObject    handle to previewButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infectionDeck = getappdata(gcf, 'infectionDeck');
infectionRate = getappdata(gcf, 'infectionRate');
for istep = 1:48
    for ipreview = 1:infectionRate
        if infectionDeck(istep).location == ipreview
            preview{ipreview} = infectionDeck(istep).name;
        end
    end
end
handles.previewText.String = preview;


function previewText_Callback(hObject, eventdata, handles)
% hObject    handle to previewText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of previewText as text
%        str2double(get(hObject,'String')) returns contents of previewText as a double


% --- Executes during object creation, after setting all properties.
function previewText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to previewText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in eventCardsPopup.
function eventCardsPopup_Callback(hObject, eventdata, handles)
% hObject    handle to eventCardsPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns eventCardsPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eventCardsPopup
switch handles.eventCardsPopup.Value
    case 1
        handles.turnsLeftText.String = num2str(26);
        handles.epidemicChanceText.String = [num2str((2/10)*100), '%'];
    case 2
        handles.turnsLeftText.String = num2str(27);
        handles.epidemicChanceText.String = [num2str((2/11)*100), '%'];
end

% --- Executes during object creation, after setting all properties.
function eventCardsPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventCardsPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ctbButton.
function ctbButton_Callback(hObject, eventdata, handles)
% hObject    handle to ctbButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infectionRate = getappdata(gcf, 'infectionRate');
setappdata(gcf, 'oldInfectionRate', infectionRate);
setappdata(gcf, 'infectionRate', 1);
handles.infectionRateText.String = '1';


% --- Executes on button press in add1button.
function add1button_Callback(hObject, eventdata, handles)
% hObject    handle to add1button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infectionDeck = getappdata(gcf, 'infectionDeck');
infectionRate = getappdata(gcf, 'infectionRate');
infectedCities = getappdata(gcf, 'infectedCities');
for istep = 1:48
    if infectionDeck(istep).location == 1 && ~strcmp(infectionDeck(istep).color, 'out')
        infectedCities{infectionRate + 1} = infectionDeck(istep).name;
    end
end
for istep = 1:48
    infectionDeck(istep).location = infectionDeck(istep).location - 1;
end

if length(infectedCities) < infectionRate + 1
    for istep = 1:48
        if infectionDeck(istep).location == 1
            infectedCities{length(infectedCities)+1} = infectionDeck(istep).name;
        end
    end
    for istep = 1:48
        infectionDeck(istep).location = infectionDeck(istep).location - 1;
    end
end
    
handles.infectText.String = infectedCities;
discardPile = getappdata(gcf, 'discardPile');
discardPile = [discardPile, infectedCities(infectionRate + 1)];
setappdata(gcf, 'discardPile', discardPile);
setappdata(gcf, 'infectionDeck', infectionDeck);
setappdata(gcf, 'infectedCities', infectedCities);