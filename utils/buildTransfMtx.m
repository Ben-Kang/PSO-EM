function T_w2c = buildTransfMtx(param)
% Build tranformation matrix from rotation angles (in degree) and translations
%
%   Copyright (c) 2016 Xin (Ben) Kang
%

Rx = makehgtform('xrotate', pi * param(1)/180);
Ry = makehgtform('yrotate', pi * param(2)/180);
Rz = makehgtform('zrotate', pi * param(3)/180);
t  = makehgtform('translate', param(4:6));
 
% Transformation matrix
T_w2c = t * Rz * Ry * Rx;

%% EOF
