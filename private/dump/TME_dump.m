function LoadMATButton(hObject,eventdata,varargin)
	
	% Get filename and path with "uigetfile"
	[filename, pathname] = uigetfile('*.mat', 'Select MAT-file to load.');
	full_filename = [ pathname, filename ];
	if ( filename == 0 )
		return
	end
	
	load(full_filename);
	
	% Load data struct
	dataOld = guidata(findobj('Tag','hSMAT'));
	selTools = dataOld.tme.selTools;
	
	% Store all GUI data
	dataNew = data;
	data = dataOld;
	data.tme = dataNew.tme;
	data.tme.selTools = selTools;
	guidata(findobj('Tag','hSMAT'),data);
	
	% Update
	AdjustImage;
	UpdateAxes;
	SetAxes;
	UpdateSelectionTools;
	
	% Update axes
	UpdateAxes;
	
	% Set Axes limits
	SetAxes;
	
	% Enable on/off
	set(findobj(get(hObject,'Parent'),'String','Save MAT-file'),'Enable','on');
	set(findobj(get(findobj('Tag','tme_panel_traceMolecule'),'Children'),'Enable','off'),'Enable','on');
	set(findobj(get(findobj('Tag','tme_panel_moleculeFeatures'),'Children'),'Enable','off'),'Enable','on');
	set(findobj(get(findobj('Tag','tme_panel_filtering'),'Children'),'Enable','off'),'Enable','on');
	set(findobj(get(findobj('Tag','tme_panel_buttonRow'),'Children'),'Enable','off'),'Enable','on');
	
end
function SaveMATButton(hObject,eventdata,varargin)
	
	% Load data struct
	data = guidata(findobj('Tag','hSMAT'));
	
	% Get save path and name
	[saveFileName,savePathName,saveFilterIndex] = uiputfile(...
		{'*.mat'},...
		'Save generated data as a MAT-file.',...
		['matlab_data_',strtok(data.tme.filename,'.'),'.mat']);
	if ( saveFileName == 0 )
		return
	end
	
	% Save data
	save([savePathName saveFileName],'data');

end
function SaveTraceButton(hObject,eventdata,varargin)
	
	% Get Data
	data = guidata(findobj('Tag','hSMAT'));
	original = data.tme.currentTT;
	Lx = data.tme.moleculeLength';
	x0 = data.tme.moleculeCenter';
	nFrames = data.tme.nFrames;
	
	% Get save path and name
	[saveFileName,savePathName,saveFilterIndex] = uiputfile(...
		{'*.mat'},...
		'Save generated data.',...
		['SMAT_TME_',strtok(data.tme.filename,'.'),'.tif']);
	if ( saveFileName == 0 )
		return
	end
	
	% Save varabel data
	save([ savePathName, strtok(saveFileName,'.') '.mat'],'x0','Lx');
	
	% Calc. params.
	sel = round([x0-Lx./2 x0+Lx./2]);
	stretchedLength = round(max(Lx));
		
	% Cut trace from map
	for i = 1 : nFrames
		
		stretched(i,:) = stretchSelection(original(i,:),sel(i,:),stretchedLength);
		
	end
	
	% Save tif file of stretched trace
	imwrite(...
		uint16(stretched),...
		[ savePathName, strtok(saveFileName,'.') '.tif'],...
		'WriteMode','overwrite');
	
	
end
function TraceFeaturesButton(varargin)
	
	% Load data struct
	data = guidata(findobj('Tag','hSMAT'));
	
	% Get Data
	original = data.tme.currentTT;
	Lx = data.tme.moleculeLength';
	x0 = data.tme.moleculeCenter';
	nFrames = data.tme.nFrames;
	
	% Calc. params.
	sel = round([x0-Lx./2 x0+Lx./2]);
	stretchedLength = round(max(Lx));
		
	% Cut trace from map
	for i = 1 : nFrames
		
		stretched(i,:) = stretchSelection(original(i,:),sel(i,:),stretchedLength);
		
	end
	
	close(findobj('Tag','hTME'));
	
	TraceFeaturesTool(stretched,Lx,x0);
	
end
function uiMoleculeFeaturesPanel(hObject,eventdata,varargin)
	
	% Dimensions
	pos = get(hObject,'Position');
	
	w = pos(3);
	h = pos(4);
	
	bw = 100;
	bh = 20;
	
	tw = 60;
	th = 25;
	
	ew = 50;
	eh = 23;
	
	x1 = 10;
	x2 = x1 + bw + 5;
	x3 = x2 + bw;
	x4 = x3 + bw;
	
	y1 = h - (25 + th);
	y2 = y1 - th;
	y3 = y2 - th;
	y4 = y3 - th;
	y5 = y4 - th;
	y6 = y5 - th;
	y7 = y6 - th;
	y8 = y7 - th;
	y9 = y8 - th;
	y10 = y9 - th;
	y11 = y10 - th;
	y12 = y11 - th;
	y13 = y12 - th;
	
	% Length and drift distributions of time trace
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
		'String','Distributions',...
		'Position',[x1 y1 bw bh],...
		'Callback',{@LengthDriftDistributions});
	
	uicontrol(...
		'Parent',hObject,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hSMAT'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',8,...
		'String','Length & drift distributions of time trace.',...
	   'Position',[x2 y1-2 w-(x1+bw+10) th]);
	
	% Intensity average of molecule
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
		'String','Intensity',...
		'Position',[x1 y2 bw bh],...
		'Callback',{@IntensityAverage});
	
	uicontrol(...
		'Parent',hObject,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hSMAT'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',8,...
		'String','Intensity average of all frames from stretched and aligned molecule.',...
	   'Position',[x2 y2-2 w-(x1+bw+10) th]);
	
	% Trace features
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
		'String','Trace Features',...
		'Position',[x1 y3 bw bh],...
		'Callback',{@TraceFeaturesButton});
	
	uicontrol(...
		'Parent',hObject,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hSMAT'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',8,...
		'String','Trace Features in Molecule Trace using a new GUI window.',...
	   'Position',[x2 y3-2 w-(x1+bw+10) th]);
	
	% Save metadata
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
		'String','Save Metadata',...
		'Position',[x1 y4 bw bh],...
		'Callback',{@SaveMetadata});

	uicontrol(...
		'Parent',hObject,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hSMAT'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',8,...
		'String','Save metadata in formated text file.',...
	   'Position',[x2 y4-2 w-(x1+bw+10) th]);

end
% Create file id
text_fid = fopen([savePathName saveFileName], 'wt');

% Create text file header
fprintf(text_fid,'%% -----------------------------------\n');
fprintf(text_fid,'%% |                                 |\n');
fprintf(text_fid,'%% | Meta data created with SMATool. |\n');
fprintf(text_fid,'%% | %s                     |\n',date);
fprintf(text_fid,'%% | =============================== |\n');
fprintf(text_fid,'%% | Copyright: 2010                 |\n');
fprintf(text_fid,'%% | Program author: Eric Sandlund   |\n');
fprintf(text_fid,'%% |                                 |\n');
fprintf(text_fid,'%% -----------------------------------\n');
fprintf(text_fid,'\n');
fprintf(text_fid,'%% Filename: %s\n',data.tme.filename);
fprintf(text_fid,'%% \n');
fprintf(text_fid,'%% All lengths are printed in pixels of the original file.\n');
fprintf(text_fid,'%% Position and direction of channel (c1 + c1*x = channel):\n');
fprintf(text_fid,'\n');

%% Center of molecule
fprintf(text_fid,'%% Center of molecule in each frame relative left edge of original frame:\n');
fprintf(text_fid, '%g ',data.tme.moleculeCenter);
fprintf(text_fid,'\n\n');

%% Center of molecule
fprintf(text_fid,'%% Length of molecule in each frame\n');
fprintf(text_fid, '%g ',data.tme.moleculeLength);

% Close file
fclose(text_fid);
