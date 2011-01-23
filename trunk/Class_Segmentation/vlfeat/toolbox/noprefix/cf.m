function varargout = cf(varargin)
% VL_CF  Copy figure
%   H=VL_CF() creates a duplicate of the current figure.
%
%   H=VL_CF(H0) creates a duplicate of the figure whose handle is H0.
%
%   See also:: VL_HELP().
[varargout{1:nargout}] = vl_cf(varargin{:});
