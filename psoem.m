function [Transform, Crspd, Sigma] = psoem(varargin)
% ECMGMM The feature-based 3D-2D registration using Particle Swarm.
%
%   Input
%   ------------------ 
%		  ImgPts	2D point set
%		ModelPts	3D point set
%				 opt	A structure of options. See details in the code.
%
%   Output
%   ------------------ 
%   Transform		A structure of the estimated transformation parameters:
%         	.R	Rotation angles
%           .t	Translations
%   Crspd		Correspondance, such that ModelPts corresponds to ImgPts(Crspd,:).
% 					Crspd.Index has N elements, where N is the beads detected in the image.
% 					It means that the n-the beads detected in the ImagePts-ray corresponds to the
% 					Crspd.Index(n) beads on the FTRAC, while their matching score is in the
% 					Crspd.Score.  
% 					If the Crspd.Index(n) > M (the total number of the beads on FTRAC),
% 					the n-th bead detected in the image is classified as an outlier, iTrial.e.,
% 					corresponding to none of the beads on FTRAC.
%   Sigma   Final Sigma^2
%
%	
% Copyright (c) 2016 Xin (Ben) Kang
% 

[ImgPts, ModelPts, opt] = parse_inputs(varargin{:});

%% setup visualization options
PlotInfo = psoemPlotInfo; % structure w/ defaults
% visualization configurations
PlotInfo.Viz          = opt.Viz;
PlotInfo.Image        = opt.Image;  % Image w/ detected contours, for display
PlotInfo.DrawCrrpMap  = true;

%% Initial guess and inputs
initval.Sigma = opt.Sigma;

% Constants for calculating the objective function
initval.ImgPts = ImgPts;
initval.ModelPts = ModelPts;
initval.K = opt.K;

%% Set original PSO options
psoopt = psooptimset( ...
    'ConstrBoundary', 'soft', ...
    'InitialPopulation', opt.InitVal', ...
    'TolFun', opt.Tol, ...
    'TolCon', opt.Tol, ...
    'PopulationSize', opt.PopulationSize, ...
    'Generations', opt.MaxItr, ...
    'InitFcn', @(x1,x2,x3)psoemInit(x1,x2,x3,initval), ...
    'PostIterateFcn', @psoemPostIterate, ...
    'FinalFcn', @psoemFinal, ...
    'PlotFcns', @(x1,x2,x3)psoemPlot(x1,x2,x3, PlotInfo), ...
    'PlotInterval', opt.VizInterval, ...
		'UseParallel', 'never', ...
    'Vectorized', 'off', ...
    'PopInitRange', [opt.LB, opt.UB]' );

%% Perform Particle Swarm Optimization (PSO)
[param, ~, flag, output] = ...
    pso(@(x,state)calcQFcn(x, state, opt.Outliers), ...
        6, [], [], [], [], opt.LB', opt.UB', [], psoopt );

% Display why exit the optimization
fprintf(1, 'Exit flag: %d\n', flag);

%% Calculate final registered point set & correspondences
Transform.R	= param(1:3)';
Transform.t	= param(4:6)';
Sigma = output.Sigma;

%% Try to determine point-to-point correspondences
% MAP correspondences
M = size(ModelPts, 1);
N	= size(ImgPts,1);	% number of image points
Crspd = struct('Score', [], 'Index', []); % define output variable

Crspd.Pmn = output.Pmn;  % the corresponding probability matrix
[Crspd.Score, Crspd.Index] = max(Crspd.Pmn(:,1:N));
% ensure one-to-one correspondence
for iCnt = 1:M
	tmp = find( Crspd.Index == iCnt );
	if numel(tmp) > 1
		[~, idx] = max( Crspd.Score(tmp) );
		Crspd.Index( tmp ) = M + 1;
		Crspd.Index( tmp(idx) ) = iCnt;
	end;
end;
Crspd.Y = ModelPts;


function [ImgPts, ModelPts, opt] = parse_inputs(varargin)
% Check the input options and set the defaults
if numel(varargin) < 2
	error('No enough input parameters.'); 
end;

ImgPts = double( varargin{1} );
ModelPts = varargin{2};

% default values
opt = struct(...
	'Image', [], ...
	'InitVal', [], ...			% initial guess of the camera pose wrt the 3D model
	'Sigma', [], ...        % Gaussian model
	'Range', [], ...,				% capture ranges
	'K', eye(3), ...				% intrinsic matrix
	'Outliers', 0.01, ...   % percentage of Outliers
	'MaxItr', 828, ...			% max. number of iterations (PSO generations)
	'Tol', 1e-5, ...				% function tolerence
	'PopulationSize', 50, ...    % PSO population
	'Viz', 1, ...						% visualize each iteration
	'VizInterval', 1 ...
	);

if (numel(varargin) > 2)
	ParamNames = fieldnames(opt);
	
	% Find out the valid parameters
	params = varargin{3};
	param_idx = find(isfield(params, ParamNames) == 1);
	for i = 1:numel(param_idx)
		param = ParamNames(param_idx(i));
		opt.(param{1}) = params.(param{1});
	end;

	% Find out the invalid parameters and just give out warning message.
	params = rmfield(params, ParamNames(param_idx));
	names = fieldnames(params);
	for i = 1:numel(names)
		warning('ECMGMM:invalidOption', ...
            'Warning: ''%s'' is not a valid option.\r', names{i});
	end;
end;

% opt.Range is the half capture Range
% LB & UB defined according to capture ranges.
opt.Range = abs(opt.Range);
opt.LB = opt.InitVal(1:6) - opt.Range;
opt.UB = opt.InitVal(1:6) + opt.Range;
	
%% EOF
