%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                 %
% SMATool - Single Molecule Analysis Tool         %
% =======================================         %
%                                                 %
%    Developed by: Fredrik Persson				  %
%						and						  %
%				  Eric Sandlund 2010              %
%    Version 1.0                                  %
%                                                 %
% The purpose of the software is to be a tool to  %
% display and analyze data taken from observations%
% of single molecules con?fined in nano-channels. %
%                                                 %
% The software is intended to be general in its   %
% application and not assume any specific type of %
% subject of molecule in the observation.         %
%                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%
% Main functions %
% ============== %
%%%%%%%%%%%%%%%%%%
function varargout = SMATool(hObject,eventdata,varargin)
	
	exitButton;
	
	f1 = figure('Visible','off');
	
	% Figure
	hSMAT = figure(...
	  	'Units','pixels',...
		'MenuBar','none',...
		'Toolbar','none',...
		'NumberTitle','off',...
		'Visible','off',...
		'Position',[0 0 1 1],...
		'Resize','off',...
		'Colormap',hot,...
		'Tag','hSMAT');
		
	drawStartContent(hSMAT);
		
	movegui(hSMAT,'north');
	set(hSMAT,'Visible','on');
	
	close(f1);
		
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw GUI content functions %
% ========================== %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawStartContent(hObject,varargin)
	
	% Set name of window
	set(hObject,'Name','SMAT - Start');
	
	% Dimensions
	% ==========
	% ------------------
	% |       10       |
	% |    --------    |
	% | 10 |  bw  | 10 |
	% |    --------    |
	% .                .
	% .                .
	% .                .
	% |    --------    |
	% |    |      |    |
	% |    --------    |
	% |       10       |
	% ------------------
	
	bw = 150;
	bh = 27;
	
	w = 10 + 150 + 10;
	h = 10 + 5*(bh+10) + 10;
	
	pos = [0 0 w h];
	set(hObject,'Position',pos);
	
	% Extract Time Trace
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
		'String','Extract Time Trace',...
		'Position',[10 h-1*(bh+10) bw bh],...
		'Callback',{@ETTButton});
	
	% Trace Molecule Edges
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
		'String','Trace Molecule Edges',...
		'Position',[10 h-2*(bh+10) bw bh],...
		'Callback',{@TMEButton});
	
	% Trace Features Tool
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
		'String','Trace Features Tool',...
		'Position',[10 h-3*(bh+10) bw bh],...
		'Callback',{@TFTButton});
	
	% Exit
	uicontrol(...
		'Parent',hObject,...
		'Units','pixels',...
		'Style','pushbutton',...
		'String','Exit',...
		'Position',[10 h-4*(bh+10) bw bh],...
		'Callback',{@exitButton,hObject});
	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button callback functions %
% ========================= %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function exitButton(hObject,eventdata,varargin)
	
	close(findobj('Tag','hETT_Filtering'));
	close(findobj('Tag','hETT'));
	close(findobj('Tag','hTME'));
	close(findobj('Tag','hTFT'));
	close(findobj('Tag','hETT_Filtering'));
	close(findobj('Tag','hSMAT'));
	
end
function ETTButton(hObject,eventdata,varargin)
	
	close(findobj('Tag','hETT'));
	
	% Execute sub-routine
	ExtractTimeTrace;
	
end
function TMEButton(hObject,eventdata,varargin)
	
	close(findobj('Tag','hTME'));
	
	% Execute sub-routine
	TraceMoleculeEdges;
	
end
function TFTButton(hObject,eventdata,varargin)
	
	close(findobj('Tag','hTFT'));
		
	% Execute sub-routine
	TraceFeaturesToolFP;
	
end

%%%%%%%%%%%%%%%%%%%%%%
% Callback functions %
% ================== %
%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
% Other functions %
% =============== %
%%%%%%%%%%%%%%%%%%%
function varargout = LoadFile(dataType,varargin)
	
	switch dataType
	case 'TIF Stack'
		
		% Get filename and path with "uigetfile"
		[filename, pathname] = uigetfile('*.tif;*.stk;*.lsm', 'select image file');
		if ( filename == 0 )
			disp('Error! No (or wrong) file selected!')
			filename = 0;
			pathname = 0;
		end
		full_filename = [ pathname, filename ];
		
	case 'TIF Trace'
		
		% Get filename and path with "uigetfile"
		[filename, pathname] = uigetfile('*.tif;*.stk;*.lsm', 'select image file');
		if ( filename == 0 )
			disp('Error! No (or wrong) file selected!')
		elseif (numel(imfinfo([ pathname, filename ])) > 1 );
			disp(true)
			filename = 0;
			pathname = 0;
		end
		full_filename = [ pathname, filename ];
	
	end
	
	varargout(1) = {full_filename};
	varargout(2) = {filename};
	varargout(3) = {pathname};
	
end

