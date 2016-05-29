function Sigma = estimateSigma(X, Y_prj, Pmn, mode)
% Estimate $$\Sigma$$
%
% Copyright (c) 2016 Xin (Ben) Kang
%

if nargin < 4
	mode = 1;
end;

[M, N] = size(Pmn);

% pair-wise Euclidean distance
d1 = bsxfun(@minus, X(:,1)', Y_prj(:,1)); % M by N matrix
d2 = bsxfun(@minus, X(:,2)', Y_prj(:,2));
dst = d1.^2 + d2.^2;  % pair-wise Euclidean distance

switch mode
	case 1
		% =================================================================== %
		%  all Gaussian components share a common isotropic covariance matrix
		% =================================================================== %		
		% $$.5 *
		% \frac
		%	{ \sum_{m=1}^{M} \sum_{n=1}^{N} p_{mn} ||X_{n} - Yprj_{m}||^2 }
		% { \sum_{m=1}^{M} \sum_{n=1}^{N} p_{mn} }$$
		Pmn = Pmn(:)';
		if all(Pmn == 0), Pmn = eps * ones(size(Pmn)); end;
		Sigma = .5 * Pmn * dst(:) / sum(Pmn, 'double');
		Sigma = Sigma * eye(2);
	case 3
		% =================================================================== %
		% all Gaussian components share a common anisotropic covariance matrix
		% =================================================================== %
		Sigma = zeros(2,2);
		for m = 1:M
			for n = 1:N
				d = (X(n,:) - Y_prj(m,:))';
				% anisotropic covariance matrix
				Sigma = Sigma + Pmn(m,n) * (d * d');
			end;
		end;
		Sigma = Sigma / sum(Pmn(:) + eps) + .5 * eye(2);
	otherwise
		error('Unknown parameter!');
end;

%% EOF
