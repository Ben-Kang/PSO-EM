function state = psocreationuniform(options, nvars, option)
% Generates uniformly distributed swarm based on options.PopInitRange.

if nargin < 3, option = 2; end;

n = options.PopulationSize ;
itr = options.Generations ;

% Gets the initial population (if any) defined by the options structure.
[state, nbrtocreate] = psogetinitialpopulation(options,n,nvars) ;

% Ben 11/15/2011
% Initialize particle positions 
switch option
	case 1																	% uniformly random independent
		initVals = repmat(rand(nbrtocreate,1), 1, nvars);
	case 2																	% uniformly random dependent
		initVals = rand(nbrtocreate, nvars);
	otherwise																% uniform, equal space
		initVals = repmat(linspace(0,1,nbrtocreate)', 1, nvars);
end;

state.Population(n-nbrtocreate+1:n,:) = ...
    repmat(options.PopInitRange(1,:), nbrtocreate, 1) + ...
    repmat(options.PopInitRange(2,:) - options.PopInitRange(1,:), ...
					 nbrtocreate, 1) .* initVals;
         
% Initial particle velocities are zero by default (should be already set in
% PSOGETINTIALPOPULATION).

% Initialize the global and local fitness to the worst possible
state.fGlobalBest = ones(itr,1)*inf ; % Global best fitness score
state.fLocalBests = ones(n,1)*inf ;   % Individual best fitness score

% Initialize global and local best positions
state.xGlobalBest = ones(1,nvars)*inf ;
state.xLocalBests = ones(n,nvars)*inf ;
state.xGlobalBests = ones(itr,nvars)*inf ;  % Ben 11/15/2011