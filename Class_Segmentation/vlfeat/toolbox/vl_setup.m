function path = vl_setup(varargin)
% VL_SETUP Add VLFeat Toolbox to the path
%   PATH = VL_SETUP() adds the VLFeat Toolbox to MATLAB path and
%   returns the path PATH to the VLFeat package.
%
%   VL_SETUP('NOPREFIX') adds aliases to each function that do not
%   contain the VL_ prefix. For example, with this option it is
%   possible to use SIFT() instead of VL_SIFT().
%
%   VL_SETUP('TEST') adds VLFeat test functions.
%
%   VL_SETUP('QUIET') does not print the greeting message.
%
%   See also:: VL_HELP(), VL_ROOT().
%   Authors:: Andrea Vedaldi and Brian Fulkerson

% AUTORIGHTS
% Copyright (C) 2007-09 Andrea Vedaldi and Brian Fulkerson
%
% This file is part of VLFeat, available under the terms of the
% GNU GPLv2, or (at your option) any later version.

noprefix = false ;
quiet = false ;
test = false ;
demo = false ;

for ai=1:length(varargin)
  opt = varargin{ai} ;
  switch lower(opt)
    case {'noprefix', 'usingvl'}
      noprefix = true ;
    case {'test'}
      test = true ;
    case {'demo'}
      demo = true ;
    case {'quiet'}
      quiet = true ;
  end
end

bindir = mexext ;
if strcmp(bindir, 'dll'), bindir = 'mexw32' ; end

[a,b,c] = fileparts(mfilename('fullpath')) ;
[a,b,c] = fileparts(a) ;
path = a ;

root = vl_root ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox'             )) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','aib'       )) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','geometry'  )) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','imop'      )) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','kmeans'    )) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','misc'      )) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','mser'      )) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','plotop'    )) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','quickshift')) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','sift'      )) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','special'   )) ;
pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','mexa64'      )) ;

if noprefix
  pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','noprefix')) ;
end

if test
  pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','test')) ;
end

if demo
  pctRunOnAll addpath(fullfile('/home/amounir/Codebase/phd-workspace/ClassSegmentation/vlfeat','toolbox','demo')) ;
end


fprintf('** Welcome to the VLFeat Toolbox **\n') ;

if nargout == 0
  clear path ;
end
