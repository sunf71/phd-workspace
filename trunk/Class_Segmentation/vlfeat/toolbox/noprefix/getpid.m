function varargout = getpid(varargin)
% VL_GETPID  Get MATLAB process ID
%   VL_GETPID() returns MATLAB process ID. 
%
%   Algorithm:: VL_GETPID() returns the result of getpid() (UNIX) or
%     GetCurrentProcessID() (Windows) system functions.
%
%   Author:: Andrea Vedaldi
[varargout{1:nargout}] = vl_getpid(varargin{:});
