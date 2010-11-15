function varargout = argparse(varargin)
% VL_ARGPARSE  Parse option arguments
%   CONF = VL_ARGPARSE(CONF, PAR1, VAL1, ... PARN, VALN) updates the
%   structure CONF based on the specified parameter-value pairs. The
%   function produces an error if an uknown parameter is passed in.
%
%   [CONF, ARGS] = VL_ARGPARSE(...) copies unkown parameters to ARGS
%   instead of producing an error.
%
%   Exampe:: The function can be used to quickly parse a variable list
%     of arguments passed to a MATLAB functions:
%
%      conf = vl_argparse(conf, varargin{:})
%
%   See also:: VL_HELP().
%   Authors:: Andrea Vedaldi
[varargout{1:nargout}] = vl_argparse(varargin{:});
