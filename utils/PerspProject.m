function x2d_img = PerspProject(x3d_w, Rbt_w2c, K, homo)
% PERSPPROJECT  Perform perspective projection.
% 
%		x2d_h_img = PerspProject(x3d_w, Rbt_w2c, K) perspectively projects the 3D
%		points (non-homogeneous coordinates) onto 2D image plane, 
%		given the 4x4 or 3x4 transformation matrix, Rbt_w2c, from WCS to CCS
%		and the 3x3 camera intrinsic matrix, K.
%	
%   Copyright (c) 2016 Xin (Ben) Kang
%

% Return homogeneous coordinates?
if nargin < 4, homo = false; end;

% each column represent one 3D point (column vector)
% for computational convenience
transp = false;
if size(x3d_w, 2) == 3
	transp = true;
	x3d_w = x3d_w';
end;

% The homogeneous 3D coords in Camera Coord. System
x3d_h_c = Rbt_w2c * [x3d_w; ones(1,size(x3d_w,2))];

% Use the pinhole camera model for projection.
% Devided by the third row to construct homogeneous 2D coords
% and thus the depth information is completely lost.
if nargin < 3 % Rbt_w2c is the projection matrix
	x2d_img = [x3d_h_c(1,:)./x3d_h_c(3,:)
							 x3d_h_c(2,:)./x3d_h_c(3,:)
							 x3d_h_c(3,:)./x3d_h_c(3,:)];
else
	% Construct the image in terms of pixels using intrinsic parameters
	x2d_img = K * [x3d_h_c(1,:)./x3d_h_c(3,:)
                 x3d_h_c(2,:)./x3d_h_c(3,:)
                 x3d_h_c(3,:)./x3d_h_c(3,:)];
end;

% Return homogeneous coordinates?
if ~homo,
	x2d_img = x2d_img(1:2,:);
end;

if transp
	x2d_img = x2d_img';
end;


%% EOF %%
