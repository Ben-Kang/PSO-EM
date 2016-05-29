function output = psoemFinal(state, options, output)
% Compile final optimization results
%
%	
% Copyright (c) 2016 Xin (Ben) Kang
%

output.Sigma = state.Sigma;
output.Y_prj = state.yprjGlobalBest;
output.Pmn   = state.pmnGlobalBest;

%% EOF
