% 
% Copyright (c) 2016 Xin (Ben) Kang
%

%%
clear;
clc;

%% add path for general functions
addpath('./psopt');
addpath('./utils');

%% load demo data
% load('demo_10.mat');
load('demo_3.mat');

%% Random error factor of the initial guess
nTrials = size(rnd, 2);

%% Set (half) capture range
cr_angles = [20; 20; 20];
cr_t = [50; 50; 100];	% @TODO: data-dependent

%% Setup basic options
opt.PopulationSize = 500;
opt.MaxItr         = 200; % max number of iterations
opt.K              = K;   % intrinsic matrix

opt.Viz            = 1;   % Visualize the estimation procedure
opt.VizInterval    = 1;

%% Add additional artifical random outliers?
addNoise = true;
% addNoise = false;

%% Main loop for each view
for iView = 1:1:size(images, 3);
	% Setup options
	fprintf(1, 'Testing on image #%d ...\n', iView);

	opt.Image	= images(:,:,iView)';
  ImagePts = XY_BB{iView}';
	
  %% Add additional artifical random outliers
  if addNoise
    nOutliers = 60;	% the number of random outliers
    outliers = rand(nOutliers, 2);
    outliers(:,1) = outliers(:,1) * size(images, 1);
    outliers(:,2) = outliers(:,2) * size(images, 2);
    ImagePts = [ImagePts; outliers];  % w/ random outliers
  end;
  
	%% 50 random initial guess per view
% 	for iTrial = 1:nTrials
	iTrial = 1;
		fprintf(1, '  Trial %d of %d on #%d view \n', iTrial, nTrials, iView);

		%% 0. Set the initial guess of camera pose wrt the WCS
		% ... and make the GT within the capture range
		angles = angles_gt(:,iView);
		angles = angles + [cr_angles(1); 0; 0] * rnd(1,iTrial);
		angles = angles + [0; cr_angles(2); 0] * rnd(2,iTrial);
		angles = angles + [0; 0; cr_angles(3)] * rnd(3,iTrial);
    t = [0; 0; -Source2Detector/2];

		% Record the ground truth and the error of initial guess
		T_init = buildTransfMtx([angles; t]);
		
		% Setup optional parameters
		opt.InitVal	= [angles(:); t(:)];        % Initial guess
    opt.Sigma   = max(size(opt.Image))/4;   % Initial $\sigma^2$ for GMM
		opt.Range		= [cr_angles(:);	cr_t(:)]; % Searching range	

		%% Display the initial guess
    % Detected fiducials, initialization and groud-truth projected model
    PtsInit     = PerspProject(ModelPts, T_init, opt.K);	% project 3D points
    prjModelPts = PerspProject(ModelPts, T_f2c(:,:,iView), opt.K);

    figure(10)
    imshow(opt.Image, [], 'InitialMagnification', 'fit'); hold on
    scatter(ImagePts(:,1), ImagePts(:,2), 'b+'); 
		scatter(PtsInit(:,1), PtsInit(:,2), 'y*');
    scatter(prjModelPts(:,1), prjModelPts(:,2), 'r+'); hold off
		drawnow;

		%% Perform GMMECM
		tic
		[Transf, Crspd] = psoem(ImagePts, ModelPts, opt);
		RunTime = toc;

		%% Registration errors
		EstErr = [Transf.R - angles_gt(:,iView); Transf.t - t_gt(:,iView)];
		
		% Print out the errors of initial guess and registration result
		fprintf(1, 'Elapsed time: %.3f seconds\n', RunTime);
		fprintf(1, 'Init err:\n %f %f %f (deg.)\n %f %f %f\n', ...
            angles - angles_gt(:,iView), t - t_gt(:,iView));
		fprintf(1, 'Est. err:\n %f %f %f (deg.)\n %f %f %f\n', EstErr);

		fprintf(1, '\n');
%     pause;
% 	end; % for iTrial
end; % for iView

fprintf(1, '%d images done!\n', iView);


%% EOF
