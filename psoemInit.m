function state = psoemInit(state, options, flag, initval)
% Initialize 3D-to-2D registration specific parameters
%
%	
% Copyright (c) 2016 Xin (Ben) Kang
%

state.Sigma  = initval.Sigma;   % Gaussian (co)variance
state.ImgPts = initval.ImgPts;  % image feature
state.K = initval.K;            % intrinsic
state.ModelPts = initval.ModelPts;

state.Generation = 0;

%% Evaluate the objective function using the initialization
[state.fGlobalBest(1), state.pmnGlobalBest, state.yprjGlobalBest] = ...
    state.fitnessfcn(state.Population(1,:), state);

%% Visualize the initialization
if (options.Verbosity > 0) && ~isempty(options.PlotFcns) && ...
	 ~isempty(state.hfigure)	
	options.PlotFcns(state, options, flag);
	drawnow
end % if ~isempty

%% EOF
