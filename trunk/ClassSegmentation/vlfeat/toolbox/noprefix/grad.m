function varargout = grad(varargin)
% VL_GRAD  Gradient
%   [Fx,Fy] = VL_GRAD(F) returns the finite differences gradient of the
%   function F. The function uses central differences and for all
%   but the boundaries pixels, for which it uses forward/backward
%   differences as appropriate.
%
%   VL_GRAD(F,'forward') uses only forward differences (except on the
%   lower and right boundaries, where backward difference is used).
%   Similarly, VL_GRAD(F,'backward') uses only backward differences.
%  
%   See also:: GRADIENT(), VL_HELP().
[varargout{1:nargout}] = vl_grad(varargin{:});
