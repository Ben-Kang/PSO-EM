function state = psoemPostIterate(state, options, flag)
% Perform EM after each PSO iteration
%
%	
% Copyright (c) 2016 Xin (Ben) Kang
%

% Estimate Sigma
% -------------------------------------------------------------------------
style = 1;	% Common, Isotropic covariance matrix (the best)
% 	style = 3;	% Common, Anisotropic covariance matrix
state.Sigma = estimateSigma(state.ImgPts(:,1:2), ...
                            state.yprjGlobalBest(:,1:2), ...
                            state.pmnGlobalBest, style);
% -------------------------------------------------------------------------

% E-step:
% Estimate corresponding probabilities, $p_{mn}$
% -------------------------------------------------------------------------
[~, state.pmnGlobalBest, state.yprjGlobalBest] = state.fitnessfcn(state.xGlobalBest, state);

%% EOF
