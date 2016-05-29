function [Q, Pmn, prjModelPts] = calcQFcn(param, state, w)
% Compute the object function.
% 
% Input:
%   param	The parameters to optimize, where param(1:3) are Eular angles and
%         param(4:6) are translations.
%   state	
%     state.ImgPts:   Feature points detected in the image
%     state.ModelPts: Model points
%     state.Sigma:    Covariance matrix of Gaussian
%   w     Weight of the outlier term
% 
%	Output:
% 	Q:            Value of the surrogate function
% 	Pmn:          Correspondence map
%   prjModelPts:  Projected model points
% 
% 
% Copyright (c) 2016 Xin (Ben) Kang
%

ImgPts   = state.ImgPts;    % Image contour/points
ModelPts = state.ModelPts;  % 3D fiducials on the model
Sigma    = state.Sigma(1);	% Gaussian
K        = state.K;         % intrinsic

T_w2c = buildTransfMtx(param(1:6)');  % SE(3) transformation matrix

%% project the 3D points & their out normals if required
D = 2;
prjModelPts = PerspProject(ModelPts, T_w2c, K );	% coordinates

%% Compute the obj fnc (after projecting the outer normals if needed)
[Q, Pmn] = calcQFcn_mex(ImgPts(:,1:D), prjModelPts(:,1:D), Sigma, w);

%% EOF
