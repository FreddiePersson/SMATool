%%%%%%%%%%%%%%%%%%
% Main functions %
% ============== %
%%%%%%%%%%%%%%%%%%
function LengthDriftDistributions(varargin)
	
	% Load data struct
	data = guidata(findobj('Tag','hSMAT'));
	
	% Dimensions
	ah = 220;
	aw = 320;
	
	
	brh = 47;
	
	bw = 80;
	bh = 25;
	
	ew = 50;
	eh = 25;
	
	tw = 80;
	th = 20;
	
	x1 = 30;
	x2 = x1 + aw + 30;
	
	
	y1 = brh + 10;
	y2 = y1 + 4*th + 10;
	y3 = y2 + ah + 10;
	
	w = 30 + aw + 30 + aw + 30;
	h = brh + 10 + 4*th + 10 + ah + 10 + th + 20;
	
	% Figure
	hFig = figure(...
	  	'Units','pixels',...
		'MenuBar','none',...
		'Toolbar','none',...
		'NumberTitle','off',...
		'Visible','off',...
		'Position',[0 0 w h],...
		'Resize','off',...
		'Name','SMATool(TME) - Length and Drift Distribution');
	
	% Button row
	hButtonPanel = uibuttongroup(...
		'Parent',hFig,...
		'Tag','MainGUI_ButtonPane',...
		'Units','pixels',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'visible','on',...
		'BorderType','none',...
		'Position',[x1 0 w-20 brh]);
	
	uicontrol(...
		'Parent',hButtonPanel,...
		'Units','pixels',...
		'Style','pushbutton',...
		'String','Close',...
		'Position',[w-20-(bw+30) 10 bw bh],...
		'Callback',{@CloseFig,hFig});
	
	% Number of bins in graph
	uicontrol(...
		'Parent',hButtonPanel,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',10,...
		'String','Number of bins in graphs: ',...
	   'Position',[0  12 150 th]);
	
	hNBins = uicontrol(...
		'Parent',hButtonPanel,...
		'Style','edit',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'Units','pixels',...
		'FontSize',10,...
		'String','40',...
	   'Position',[150  10 ew eh]);
		
	% Drift Axes
	hDriftAxes = axes(...
		'Parent',hFig,...
		'Units','pixels',...
		'Position',[x1 y2 aw ah],...
		'Visible','on');
	uicontrol(...
		'Parent',hFig,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','center',...
		'Units','pixels',...
		'FontSize',12,...
		'String','Drift Distribution (pixels)',...
	   'Position',[x1 y3 aw th]);
	axis(hDriftAxes,'off',[1 200 0 1])
	
	% Length Axes
	hLengthAxes = axes(...
		'Parent',hFig,...
		'Units','pixels',...
		'Position',[x2 y2 aw ah],...
		'Visible','on');
	uicontrol(...
		'Parent',hFig,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','center',...
		'Units','pixels',...
		'FontSize',12,...
		'String','Length Distribution (pixels)',...
	   'Position',[x2 y3 aw th]);
	axis(hLengthAxes,'off','tight')
	
	% Bar graphs
	hDriftBar = bar(hDriftAxes,[0 0]);
	
	% Get molecule meta data
	Lx = data.tme.moleculeLength;
	x0 = data.tme.moleculeCenter;
	
	% Drift dist. calc
	x = 1:length(x0);
	b = robustfit(x,x0);
	[mx0,sx0] = normfit(x0-(b(1)+b(2)*x));
	Yx0 = x0-(b(1)+b(2)*x);
	% Display drift data labels
	uicontrol(...
		'Parent',hFig,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',10,...
		'String','Average drift:',...
	   'Position',[x1 y1+2*th 150 th]);
	uicontrol(...
		'Parent',hFig,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',10,...
		'String',sprintf('%0.3g pixels',b(2)),...
	   'Position',[x1+150 y1+2*th aw th]);
	uicontrol(...
		'Parent',hFig,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',10,...
		'String','Relative mean drift:',...
	   'Position',[x1 y1+th 150 th]);
	uicontrol(...
		'Parent',hFig,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',10,...
		'String',sprintf('%0.3g pixels',mx0),...
	   'Position',[x1+150 y1+th aw th]);
	uicontrol(...
		'Parent',hFig,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',10,...
		'String','Standard deviation:',...
	   'Position',[x1 y1 150 th]);
	uicontrol(...
		'Parent',hFig,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',10,...
		'String',sprintf('%0.3g pixels',sx0),...
	   'Position',[x1+150 y1 aw th]);
	
	% Drift graph
	hist(Yx0,40,'Parent',hDriftAxes);
	h2 = findobj(hDriftAxes,'Type','patch');
	set(h2,'FaceColor','b','EdgeColor','w');
	
	% Length dist. calc.
	[mLx,sLx] = normfit(Lx);
	YLx = Lx;
	% Display length data labels
	uicontrol(...
		'Parent',hFig,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',10,...
		'String','Mean length:',...
	   'Position',[x2 y1+2*th 150 th]);
	uicontrol(...
		'Parent',hFig,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',10,...
		'String',sprintf('%0.3g pixels',mLx),...
	   'Position',[x2+150 y1+2*th aw th]);
	uicontrol(...
		'Parent',hFig,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',10,...
		'String','Standard deviation:',...
	   'Position',[x2 y1+th 150 th]);
	uicontrol(...
		'Parent',hFig,...
		'Style','text',...
		'BackgroundColor',get(findobj('Tag','hTME'),'Color'),...
		'HorizontalAlignment','left',...
		'Units','pixels',...
		'FontSize',10,...
		'String',sprintf('%0.3g pixels',sLx),...
	   'Position',[x2+150 y1+th aw th]);
	
	
	% Length graph
	hist(YLx,40,'Parent',hLengthAxes);
	h1 = findobj(hLengthAxes,'Type','patch');
	set(h1,'FaceColor','r','EdgeColor','w');
	
	% Set callback for nBins editbox
	set(hNBins,'Callback',{@ChangeNBins,[hLengthAxes hDriftAxes],YLx,Yx0})
		
	if false
		
		debug.Lx = Lx;
		debug.x0 = x0;
		debug.y0 = b(1);
		debug.k = b(2);
		debug.mLx = mLx;
		debug.sLX = sLx;
		debug.mx0 = mx0;
		debug.sx0 = sx0;
	
		disp(debug)

	end
	
	% Move and make visible.
	movegui(hFig,'north')
	set(hFig,'Visible','on');
	
end

%%%%%%%%%%%%%%%%%%%%%%
% Callback functions %
% ================== %
%%%%%%%%%%%%%%%%%%%%%%
function ChangeNBins(hObject,eventdata,hAxes,y1,y2)
	
	nBins = str2num(get(hObject,'String'));
	
	% Create graphs
	hist(y1,nBins,'Parent',hAxes(1));
	hist(y2,nBins,'Parent',hAxes(2));
	
	% Set color
	h1 = findobj(hAxes(1),'Type','patch');
	set(h1,'FaceColor','r','EdgeColor','w');
	h2 = findobj(hAxes(2),'Type','patch');
	set(h2,'FaceColor','b','EdgeColor','w');
	
end
function CloseFig(hObject,handles,varargin)
	
	close(varargin{1:end});
	
end
	
	
%%%%%%%%%%%%%%%%%%%
% Other functions %
% =============== %
%%%%%%%%%%%%%%%%%%%
function y = gaussianFcn(p,x)
	
	% Rename params
	nBells = size(p,2);
	
	s = p(1,:);
	m = p(2,:);
	
	c = s;
	b = m;
	a = 1 ./ (c.*sqrt(2*pi));
	
	y = zeros(size(x));
	for i = 1:nBells
		
		y = a(i) .* exp(- (x-b(i)).^2 ./ (2.*c(i).^2) );
	
	end
	
end

