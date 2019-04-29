function varargout = CIEcalculator(varargin)
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Required files for execution: CIEcalculator.m, CIEcalculator.fig,
% xFit_1931.m, yFit_1931.m, zFit_1931.m, CIExy1931.jpg and instructions.png
% Usage: Calculate CIE coordinates and plot them in a CIE diagram. 
% Target System: Windows 
% Interface: Graphical user interfaces (GUIs) 
% Functional Requirements:
% The user must export the data of his photoluminescence spectra to a .txt file
% following some specific instructions. After importing this data file, the user
% could calculate the CIE coordinates and plot them using the appropriate functions.
% 
% version  = 1.0 
% maintainer  = "ya7yawii@yahoo.fr" 
% status  = "Prototype" 
% date  = "29-04-2019"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CIEcalculator_OpeningFcn, ...
                   'gui_OutputFcn',  @CIEcalculator_OutputFcn, ...
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

% --- Executes just before CIEcalculator is made visible.
function CIEcalculator_OpeningFcn(hObject, ~, handles, varargin)

% Display the text image of the instructions about the data file
if exist('instructions.png', 'file')
    axes(handles.instructions);
    myimag = imread('instructions.png');
    imshow(myimag, 'parent', handles.instructions);
    handles.instructions.Visible = 'On';
    handles.instructions.XColor = 'none';
    handles.instructions.YColor = 'none';
    set(handles.instructions,'XTickLabel',[]);
    set(handles.instructions,'YTickLabel',[]);
    set(handles.instructions,'XTick',[]);
    set(handles.instructions,'YTick',[]);
else
    uiwait(errordlg('The instructions file does not exist', 'File Error', 'Error'));
    return
end

% Display the CIE diagram image with x and y axis
if exist('CIExy1931.jpg', 'file')
    axes(handles.CIEdiagram);
    myimage = imread('CIExy1931.jpg');
    imshow(myimage, 'parent', handles.CIEdiagram);
    imshow(myimage, 'XData', 0:0.1:0.8, 'YData', 0.9:-0.1:0);
    axis xy;
    handles.CIEdiagram.Visible = 'On';
    handles.CIEdiagram.FontSize = 12;
    handles.CIEdiagram.LineWidth = 2;
    handles.CIEdiagram.XColor = [0.65 0.65 0.65];
    handles.CIEdiagram.YColor = [0.65 0.65 0.65];
    set(handles.CIEdiagram,'box','off');
    xlb = xlabel(handles.CIEdiagram, 'x', 'FontSize', 16, 'HorizontalAlignment', 'center');
    ylb = ylabel(handles.CIEdiagram, 'y', 'FontSize', 16, 'rotation', 0, 'VerticalAlignment', 'middle');
    px = get(xlb,'position');
    px(2) = 0.8*px(2);
    set(xlb,'position', px);
    py = get(ylb,'position');
    py(1) = 1.3*py(1);
    set(ylb,'position', py);
else
    uiwait(errordlg('The CIE diagram image does not exist', 'File Error', 'Error'));
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialization 

% Browse button
handles.press_browse = 0;

% Edit textbox: Number of rows 
handles.nb_lines = 0;

% Calculate button
handles.Calcul_done = 0;

% Marker symbol popupmenu
handles.select_symbol = 0;

% Marker color popupmenu
handles.select_color = 0;

% Marker size slider
handles.select_size = 0;

% Locate button:
% -count only the user selection of one point with its label
handles.counter = 0;
% -initialize the selected rows
handles.Row1 = ''; handles.Row2 = ''; handles.Row3 = '';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose default command line output for CIEcalculator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = CIEcalculator_OutputFcn(~, ~, handles) 
 
% Sim salabim! It is showtime! ;)

% Get default command line output from handles structure
varargout{1} = handles.output;

% This line of code is just for minimizing compile warnings
% because the object properties are already stored in gui
function CIEdiagram_CreateFcn(~, ~, ~)

% This line of code is just for minimizing compile warnings
% because the object properties are already stored in gui
function instructions_CreateFcn(~, ~, ~)

% --- Executes on button press in Browse.
function Browse_Callback(hObject, ~, handles)

% Import the data file
[FileName,PathName,indx] = uigetfile('*.txt','Select the txt file');
handles.indx = indx;
handles.FileName = FileName;
handles.PathName = PathName;

% User has pressed the button
handles.press_browse = 1;

guidata(hObject,handles);

function nb_lines_Callback(hObject, ~, handles)

% a textbox where to put the number of rows that compose the data file 
num = str2double(get(hObject,'String'));
if isnan(num)
    uiwait(errordlg('Input must be a number', 'Input Error', 'Error'));
    return
elseif num < 0
    uiwait(errordlg('Input must be a positive integer', 'Input Error', 'Error'));
    return
elseif num > 1e9
    uiwait(errordlg('Input must be an integer < 1e9', 'Input Error', 'Error'));
    return
else
    num = uint32(num);
end
handles.nb_lines = num;

guidata(hObject,handles)

% This line of code is just for minimizing compile warnings
% because the object properties are already stored in gui
function nb_lines_CreateFcn(~, ~, ~)

% --- Executes during object creation, after setting all properties.
function xytable_CreateFcn(hObject, ~, ~)

% html code to change the font style of the column name, which is not
% possible with matlab
ColumnNames = { ....
    '<html><b><center /><font face="Tahoma" size=4>Label</font><b></html>', ...
    '<html><b><center /><font face="Tahoma" size=4>x</font><b></html>', ...
    '<html><b><center /><font face="Tahoma" size=4>y</font><b></html>', ...
    };
set(hObject, 'ColumnName',ColumnNames);

% --- Executes on button press in Calculate.
function Calculate_Callback(hObject, ~, handles)

% extract data from the text file
if handles.press_browse == 0
    uiwait(errordlg('Press Browse button first', 'Press button error', 'Error'));
    return
else
    FileName = handles.FileName;
    PathName = handles.PathName;
    indx = handles.indx;
    if exist(fullfile(PathName,FileName)) == 0
        uiwait(errordlg('Select data file', 'File Error', 'Error'));
        return
    elseif indx == 2
        uiwait(errordlg('Wrong file type', 'File Error', 'Error'));
        return
    else
        if handles.nb_lines == 0
            uiwait(errordlg('Set the number of rows', 'Input Error', 'Error'));
            return
        else
            num = handles.nb_lines;
            fid = fopen(fullfile(PathName,FileName));n = 1;
            while n <= num
                switch n
                    case 1
                        titles = fgetl(fid);
                        testlb = regexp(titles,'(?![ .\t])\D','once');
                        if isempty(titles)
                            uiwait(errordlg(...
                                'The first row is empty', 'Data loading', 'Error'));
                            return
                        elseif isempty(testlb)
                            uiwait(msgbox(...
                            'The label row may contain wavelength and intensity values',...
                            'Data loading', 'warn'));
                        end
                    case 2
                        WavInt = fgetl(fid); % Names of wavelength and intensity columns
                        testwi = regexp(WavInt,'(?![ .\t])\D','once');
                        if isempty(WavInt)
                            uiwait(msgbox(...
                                'The second row is empty', 'Data loading', 'warn'));
                        elseif isempty(testwi)
                            uiwait(msgbox(...
                                'The second row may contain wavelength and intensity values',...
                                'Data loading', 'Error'));
                        end
                    otherwise
                        cac = fgetl(fid);
                        if isempty(cac)
                            uiwait(errordlg(sprintf('The row %d is empty', n),...
                                'Data loading', 'error'));
                            return
                        elseif ~ischar(cac)
                            uiwait(errordlg(sprintf(...
                                'The number of rows is actually %d', n-1),...
                                'Data loading', 'error'));
                            return
                        end
                        testchar = regexp(cac,'(?![ .\t])\D','once');
                        testdigit = regexp(cac,'\d[,]\d','once');
                        missing = regexp(cac,'( |--)','once');
                        if ~isempty(testdigit)
                            uiwait(errordlg(...
                                'The commas cannot be neither decimal seperator nor columns seperator',...
                                'Data loading', 'error'));
                            return
                        elseif ~isempty(missing)
                            uiwait(errordlg(...
                                'The missing values should be replaced by 0',...
                                'Data loading', 'error'));
                            return
                        elseif ~isempty(testchar)
                            uiwait(errordlg(...
                                'The wavelength and intensity values contain nondigit characters',...
                                'Data loading', 'error'));
                            return
                        else
                            Data = textscan(cac,'%f');
                            PLdata(n,:) = Data{1};
                        end
                end
                n = n+1;
            end
            if ischar(fgetl(fid))
                uiwait(errordlg(sprintf('The number of rows is not %d',n-1),...
                    'Input Error', 'error'));
                return
            end
            nb_columns = size(PLdata,2);
            if nb_columns > 30
                uiwait(errordlg('The number of columns should not exceed 30',...
                    'Data loading', 'error'));
                return
            end
            fclose(fid);
            Labels = strsplit(titles,'\t');
            for l = 1:2:length(Labels)
                testchareq = strcmp(Labels(l),Labels(l+1));
                if testchareq == 0
                    uiwait(msgbox(...
                        'There is two different labels for the same point',...
                        'Data loading', 'warn'));
                end
            end
        end
    end
end

% CIE coordinates calculation
nb_col = size(PLdata,2)/2;
x = zeros(nb_col, 1); y = zeros(nb_col, 1); Label = cell(nb_col,1);
c = 1; i = 1;
while c <= nb_col*2 && i <= nb_col
    wave = PLdata(:,c);
    int = PLdata(:,c+1);
    CIEXydata = xFit_1931(wave).*int;
    CIEYydata = yFit_1931(wave).*int;
    CIEZydata = zFit_1931(wave).*int;
    X = trapz(wave,CIEXydata);
    Y = trapz(wave,CIEYydata);
    Z = trapz(wave,CIEZydata);
    x(i) = X/(X+Y+Z);
    y(i) = Y/(X+Y+Z);
    Label(i) = Labels(c);
    c = c+2; i = i+1;
end
varNames = {'Label','x','y'};
T = table(Label,round(x,4),round(y,4),'VariableNames',varNames);
handles.Calculate = T;
results = table2cell(T);
xytable = handles.xytable;
set(xytable, 'Data', results); % Transfer results to the table

%User has pressed on Calculate button
handles.Calcul_done = 1;

guidata(hObject,handles)

% --- Executes when selected cell(s) is changed in xytable.
function xytable_CellSelectionCallback(hObject, eventdata, handles)

% Notice any selected cells and store only the three appropriate ones
dataselected = get(handles.xytable,'Data');
if all(cellfun(@isempty, dataselected(:))) || isempty(eventdata.Indices)
    uiwait(errordlg('Do calculation first', 'Input Error', 'Error'));
    return
else
    selecRow = eventdata.Indices(1);
    selecCol = eventdata.Indices(2);
    switch selecCol
        case 1
            Labelcell = dataselected(selecRow,selecCol);
            handles.Labelcell = Labelcell;
            Row1 = selecRow;
            handles.Row1 = Row1;
        case 2
            xcell = dataselected(selecRow,selecCol);
            handles.xcell = xcell;
            Row2 = selecRow;
            handles.Row2 = Row2;
        case 3
            ycell = dataselected(selecRow,selecCol);
            handles.ycell = ycell;
            Row3 = selecRow;
            handles.Row3 = Row3;
    end
end

guidata(hObject, handles)

% This line of code is just for minimizing compile warnings
% because the object properties are already stored in gui
function Marker_symbol_CreateFcn(~, ~, ~)

% --- Executes on selection change in Marker_symbol.
function Marker_symbol_Callback(hObject, ~, handles)

% User has selected a symbol from the popupmenu
handles.select_symbol = 1;

guidata(hObject,handles);


% This line of code is just for minimizing compile warnings
% because the object properties are already stored in gui
function Marker_color_CreateFcn(~, ~, ~)

% --- Executes on selection change in Marker_color.
function Marker_color_Callback(hObject, ~, handles)

% User has selected a color from the popupmenu
handles.select_color = 1;

guidata(hObject,handles);

% This line of code is just for minimizing compile warnings
% because the object properties are already stored in gui
function Marker_size_CreateFcn(~, ~, ~)

% --- Executes on slider movement.
function Marker_size_Callback(hObject, ~, handles)

% Transfer the slide value to edit textbox so the user see its variation
size = round(get(handles.Marker_size,'Value'));
set(handles.slider_value,'String',num2str(size));

% User has selected a size using the slider
handles.select_size = 1;

guidata(hObject, handles)

% This line of code is just for minimizing compile warnings
% because the object properties are already stored in gui
function slider_value_CreateFcn(~, ~, ~)

% --- Executes on button press in Locate.
function Locate_Callback(hObject, ~, handles)

% Plot the selected point in the CIE diagram
if isempty(handles.Row1) 
    uiwait(errordlg('Select label cell from the table', 'Selection Error', 'Error'));
    return
elseif isempty(handles.Row2)
    uiwait(errordlg('Select x cell from the table', 'Selection Error', 'Error'));
    return
elseif isempty(handles.Row3)
    uiwait(errordlg('Select y cell from the table', 'Selection Error', 'Error'));
    return
else
    Row1 = handles.Row1; Row2 = handles.Row2; Row3 = handles.Row3;
end
if handles.counter == 0 && handles.select_symbol == 0 && handles.select_color == 0 && handles.select_size == 0
    uiwait(msgbox(...
        'The marker properties can only be modified before clicking on Locate button',...
        'Marker properties', 'warn'));
end
Labelcell = handles.Labelcell;
xcell = handles.xcell{1};
ycell = handles.ycell{1};
symbols = get(handles.Marker_symbol,'String');
idx_sym = get(handles.Marker_symbol,'Value');
symbol_selected = symbols{idx_sym};
colors = get(handles.Marker_color,'String');
idx_col = get(handles.Marker_color,'Value');
color_selected = colors{idx_col};
size = round(get(handles.Marker_size,'Value'));
if Row1 == Row2 && Row1 == Row3
    handles.counter = handles.counter + 1;
    handles.CIEdiagram = gca;
    hold on;
    switch handles.counter
        case 1
            scat1 = scatter(xcell,ycell,size);
            scat1.Marker = symbol_selected;
            scat1.MarkerFaceColor = color_selected;
            scat1.MarkerEdgeColor = color_selected;
            Legend = char(Labelcell);
            handles.Legend = Legend;
            leg = legend(Legend);
            handles.leg = leg;
        otherwise
            test = handles.Legend;
            char(Labelcell);
            idx = ismember(test,char(Labelcell), 'rows');
            for i = 1:length(idx)
                if idx(i,1) == 1
                    uiwait(errordlg('You selected the same point twice',...
                        'Selection Error', 'Error'));
                    return
                end
            end
            scat2 = scatter(xcell,ycell,size);
            scat2.Marker = symbol_selected;
            scat2.MarkerFaceColor = color_selected;
            scat2.MarkerEdgeColor = color_selected;
            lgd = char(Labelcell);
            Legend = char(lgd,handles.Legend);
            handles.Legend = Legend;
            leg = legend(Legend);
            handles.leg = leg;
    end
else
    uiwait(errordlg('Data must be in the same row', 'Selection Error', 'Error'));
    return
end

guidata(hObject, handles);

% --- Executes on button press in Save.
function Save_Callback(~, ~, handles)

% Choose between saving the table of results or CIE diagram or both
answer = questdlg('Which results do you like to save?', 'Save Menu',...
    'CIE coordinates', 'CIE diagram', 'CIE diagram');
switch answer
    case 'CIE coordinates'
        if handles.Calcul_done == 1
            filter = {'*.txt';'*.dat';'*.csv';'*.*'};
            [filename, pathname, indx] = uiputfile(filter, 'Save as');
            if isequal(filename,0) == 0 || isequal(pathname,0) == 0;
                path_file=fullfile(pathname,filename);
                fopen(path_file,'wt');
                fclose('all');
                if indx == 4
                    uiwait(errordlg('Wrong file type', 'File Error', 'Error'));
                    return
                end
                T = handles.Calculate;
                writetable(T,path_file,'Delimiter','\t');
            end
        else
            uiwait(errordlg('The table of results is empty', 'Save Error', 'Error'));
            return
        end
    case 'CIE diagram'
        if handles.counter ~= 0
            [filename, pathname, indx] = uiputfile({'*.jpg';'*.png';'*.pdf';'*.*'}, 'Save as');
            if isequal(filename,0) == 0 || isequal(pathname,0) == 0;
                path_file=fullfile(pathname,filename);
                fopen(path_file,'wt');
                fclose('all');
                if indx == 4
                    uiwait(errordlg('Wrong file type', 'File Error', 'Error'));
                    return
                end
                leg = handles.leg;
                legendstr=get(leg,'String');
                legendloc=get(leg,'Location');
                fignew = figure('Visible','off');
                newAxes = copyobj(handles.CIEdiagram,fignew);
                set(newAxes,'Position',get(groot,'DefaultAxesPosition'));
                legend(newAxes,legendstr,'Location',legendloc);
                set(fignew,'CreateFcn','set(gcbf,''Visible'',''on'')');
                saveas(fignew,path_file);
                delete(fignew);
            end
        else
            uiwait(errordlg('There is no data points in the CIE diagram',...
                'Save Error', 'Error'));
            return
        end
end
