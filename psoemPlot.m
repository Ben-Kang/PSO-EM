function psoemPlot(state, options, flag, PlotInfo)
% Visualize the optimization procedure
%
%	
% Copyright (c) 2016 Xin (Ben) Kang
%
	
% value of the objective function
if (state.Generation == 0)
  fval = state.fGlobalBest(1);
  
  % Make a figure for better screenshot
  figPos = get(state.hfigure, 'Position');
  % sz = [384 36];	% tiny, no display
%   sz = [988 530];	% small
  sz = [1250 656];	% large
  if all( figPos(3:4) < sz )
    figPos(3:4) = sz;
    set(state.hfigure, 'Position', figPos);
  end;
else
  fval = state.fGlobalBest(state.Generation);
end

PlotInfo.Itr		= state.Generation;
PlotInfo.param	= state.xGlobalBest;	% rotation & translation
PlotInfo.Sigma	= state.Sigma(1);     % $\Sigma$ for mixture of Gaussians
PlotInfo.Q = fval;
PlotInfo.Pmn	 = state.pmnGlobalBest;		% correspondence probabilities
PlotInfo.Y_prj = state.yprjGlobalBest;	% projected apparent contour pts
PlotInfo.ImgPts	= state.ImgPts;

set(0, 'CurrentFigure', state.hfigure);
switch flag
  case {'init', 'iter'}
    if (options.Verbosity == 2)
      fprintf('#%d %.4f (%.4f, %.4f, %.4f, %.4f, %.4f, %.4f)\n', ...
              state.Generation, fval, state.xGlobalBest(1:6));
    else
      fprintf(1, '%d, ', state.Generation);
    end;
    PlotInfo.done	= false;
    if PlotInfo.Viz
      drawIteration( state.hfigure, PlotInfo );
    end;
  case 'done'
    PlotInfo.done	= true;
    fprintf(1, '%d\n', state.Generation);
    if PlotInfo.Viz
      drawIteration( state.hfigure, PlotInfo );
    end;
end;

%% EOF 
