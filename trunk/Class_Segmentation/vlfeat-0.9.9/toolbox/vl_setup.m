function path = vl_setup(varargin)
% VL_SETUP Add VLFeat Toolbox to the path
%   PATH = VL_SETUP() adds the VLFeat Toolbox to MATLAB path and
%   returns the path PATH to the VLFeat package.
%
%   VL_SETUP('NOPREFIX') adds aliases to each function that do not
%   contain the VL_ prefix. For example, with this option it is
%   possible to use SIFT() instead of VL_SIFT().
%
%   VL_SETUP('TEST') or VL_SETUP('XTEST') adds VLFeat unit test
%   function suite. See also VL_TEST().
%
%   VL_SETUP('QUIET') does not print the greeting message.
%
%   See also:: VL_HELP(), VL_'/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9'().
%   Authors:: Andrea Vedaldi and Brian Fulkerson

% AUTORIGHTS
% Copyright (C) 2007-10 Andrea Vedaldi and Brian Fulkerson
%
% This file is part of VLFeat, available under the terms of the
% GNU GPLv2, or (at your option) any later version.

noprefix = false ;
quiet = false ;
xtest = false ;
demo = false ;

for ai=1:length(varargin)
  opt = varargin{ai} ;
  switch lower(opt)
    case {'noprefix', 'usingvl'}
      noprefix = true ;
    case {'test', 'xtest'}
      xtest = true ;
    case {'demo'}
      demo = true ;
    case {'quiet'}
      quiet = true ;
    otherwise
      error('Unknown option ''%s''.', opt) ;
  end
end

if exist('octave_config_info')
  bindir = 'octave' ;
else
  bindir = mexext ;
  if strcmp(bindir, 'dll'), bindir = 'mexw32' ; end
end
bindir = fullfile('mex',bindir) ;

[a,b,c] = fileparts(mfilename('fullpath')) ;
[a,b,c] = fileparts(a) ;
path = a ;

pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox')) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','aib')) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','geometry')) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','imop')) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','kmeans')) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','misc')) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','mser')) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','plotop')) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','quickshift')) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','sift')) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','special')) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','mex','mexa64')) ;

if noprefix
  pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','noprefix')) ;
end

if xtest
  pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','xtest')) ;
end

if demo
  pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat-0.9.9','toolbox','demo')) ;
end

if ~quiet
  fprintf('VLFeat %s ready.\n', vl_version) ;
end

if nargout == 0
  clear path ;
end
