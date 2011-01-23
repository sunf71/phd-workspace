function varargout = figaspect(varargin)
% VL_FIGASPECT  Set figure aspect ratio
%   VL_FIGASPECT(A) sets the current figure aspect ratio to A. It
%   leaves the shortest side unaltered.
%
%   Author:: Andrea Vedaldi
[varargout{1:nargout}] = vl_figaspect(varargin{:});
