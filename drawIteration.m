function drawIteration( hFig, PlotInfo )
% DRAWITERATION  Draw each iteration.
%	
% Copyright (c) 2016 Xin (Ben) Kang
%

Itr	= PlotInfo.Itr;

X			= PlotInfo.ImgPts;
Y_prj = PlotInfo.Y_prj;
Pmn		= PlotInfo.Pmn;

% [M, N] = size(Pmn);
M = size(Y_prj,1);	% number of model points
N = size(X,1);			% number of image points

%% 1. Detected & virtual 2D points and projections of 3D point
offset = 10;
if max(M, N) < 100
	AxesPos = [.01 .30 .36 .66];
else
	AxesPos = [.01 .04 .36 .86];
end;

hImageAxes = getappdata(hFig, 'hImageAxes');
if isempty(hImageAxes) || (Itr == 0)
	hImageAxes = axes(...
			'Parent', hFig,...
			'Units', 'Normalized', ...
			'Position', AxesPos, ...
			'NextPlot', 'replace', ...
			'Tag', 'ImageShow', ...
			'Visible', 'off');
	setappdata(hFig, 'hImageAxes', hImageAxes);  % store for later use
end;

hold on
% draw image w/ extracted contour only once
if ~isempty(PlotInfo.Image) && (Itr == 0)
	imshow(PlotInfo.Image, [], 'Parent', hImageAxes, 'InitialMagnification', 'fit');
	% use multiple color map
	freezeColors(hImageAxes); % <== @HERE
	% draw 2D points in the image
	pattern = 'b+';
	% draw detected 2D points
	scatter(hImageAxes, X(:,1), X(:,2), 28, pattern);	
	% Display order number of the points
	if PlotInfo.ShowPointNumber
		if max(M,N) < 10
			text(X(:,1)+offset, X(:,2)-offset, num2str( (1:N)' ), ...
				'Color', 'k', 'FontSize', 11);
		end;
	end;
end;

%------------------------------------------------------------------------------

% draw projected 3D points
hModelPts = getappdata(hFig, 'hModelPts');
if M > 100
	if isempty(hModelPts) || (Itr == 0)
		hModelPts = scatter(hImageAxes, Y_prj(:,1), Y_prj(:,2), 8, 'ro', 'filled');
		setappdata(hFig, 'hModelPts', hModelPts);  % store for later use
	else
		set(hModelPts, 'XData', Y_prj(:,1), 'YData', Y_prj(:,2));
	end;
else
	% Display projected points w/ number labels
	if isempty(hModelPts) || (Itr == 0)
		% Simple visualization
		hModelPts = scatter(hImageAxes, Y_prj(:,1), Y_prj(:,2), 28, 'ro');
		setappdata(hFig, 'hModelPts', hModelPts);  % store for later use
		
		% Display order number of the points
		if PlotInfo.ShowPointNumber
			hModelPtsLabel = text(Y_prj(:,1)-offset, Y_prj(:,2)+offset, num2str((1:M)'), 'FontSize', 11);
      colors = parula(M);
			for i = 1:M
				set(hModelPtsLabel(i), 'Color', colors(i,:));
			end;
			setappdata(hFig, 'hModelPtsLabel', hModelPtsLabel);  % store for later use
		end; % display order number
	else
		set(hModelPts, 'XData', Y_prj(:,1), 'YData', Y_prj(:,2));
		% Display order number of the points
		if PlotInfo.ShowPointNumber
			hModelPtsLabel = getappdata(hFig, 'hModelPtsLabel');
			for i = 1:M
				set(hModelPtsLabel(i), 'Position', Y_prj(i,:)+offset*[-1 1]);
			end;
		end;  % display order number
	end; % hModelPts
end; % if M
  
%------------------------------------------------------------------------------

if (Itr == 0) && PlotInfo.DrawLegend
	Legends = {'Image Points', 'Model Projections'};
	hLegend = legend( hImageAxes, Legends, 'Location', 'NorthWest', ...
										'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold', ...
										'TextColor', 'K', 'Color', 'none');
	set(hLegend, 'Box', 'off')
end;
hold off
axis ij; axis equal;

%% 2. Correspondence Map (below the image)
if PlotInfo.DrawCrrpMap ( (max(M, N) < 100) && ~isempty(Pmn) )
	title_ = 'Correspondence Map (Soft)  ';

	P_outlier = 1 - sum(Pmn);
	Pmn = [Pmn; P_outlier];
	if (nargin > 6) && (PlotInfo.done)
		% Find the correspondence, such that Y corresponds to X(C,:)
		[~, idx] = max(Pmn);
		Pmn(:) = 0;
		for n = 1:N, Pmn(idx(n),n) = 1; end;
		title_ = 'Correspondence Map (Hard)';
	end;

	hCrrpdAxes = getappdata(hFig, 'hCrrpdAxes');
	if (Itr == 0)
		hCrrpdAxes = axes(...
				'Parent', hFig, ...
				'Units', 'Normalized', ...
				'Position', [.025 .065 .360 .200], ...		% below the image
				'XAxisLocation', 'bottom', ...
				'NextPlot', 'replace', ...
				'Tag', 'CorrespMap', ...
				'Visible', 'on');
		setappdata(hFig, 'hCrrpdAxes', hCrrpdAxes);
	end;
	
	imagesc(Pmn, 'Parent', hCrrpdAxes); colormap(parula);
	set(hCrrpdAxes, 'XLim', [0,size(Pmn,2)+1], ...
									'YLim', [0,size(Pmn,1)+1]);
	ylabel(hCrrpdAxes, 'Vertices on 3D model', 'FontSize', 10); 
	xlabel(hCrrpdAxes, 'Points detected in image', 'FontSize', 10); 
  set(hCrrpdAxes, 'YTick', [], 'XTick', []);
	axis equal; axis tight;
	hcbar = colorbar();  caxis([0,1]);
	set(hcbar, 'YTick', [0.0 .5 1]);
	title(title_, 'FontSize', 11, 'FontWeight', 'Bold');
end;

%% 3. Optimization insights
str{1} = sprintf(' Rotation (deg.) : (%.2f, %.2f, %.2f)', round2(PlotInfo.param(1:3), .02));
str{2} = sprintf(' Translation (mm) : (%.2f, %.2f, %.2f)', round2(PlotInfo.param(4:6), .01));
str{3} = sprintf(' Q function : %.6f', round2(PlotInfo.Q, 1e-6));
str{4} = sprintf(' Sigma : %.4f', sqrt(PlotInfo.Sigma));

hText = getappdata(hFig, 'hText');
if isempty(hText) || (Itr == 0)
	hText = uicontrol( hFig, ...
			'Style', 'Text', ...
			'String', '', ...
			'Units', 'Normalized', ...
			'Position', [.40 .02 .26 .15], ...
			'FontName', 'Book Antiqua', ...
			'FontSize', 12, ...
			'FontAngle', 'italic', ...
			'FontWeight', 'Bold', ...
			'HorizontalAlignment', 'Left', ...
			'BackgroundColor', [1 1 1], ...
			'Tag', 'ParamDisplay', ...
			'Interruptible', 'off');
	setappdata(hFig, 'hText', hText);
end;
set(hText, 'String', str);


%% EOF
