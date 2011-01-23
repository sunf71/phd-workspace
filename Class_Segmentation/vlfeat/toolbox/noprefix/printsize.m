function varargout = printsize(varargin)
% VL_PRINTSIZE  Set the print size of a figure
%   VL_PRINTSIZE(R) set the print size of a figure so that the width is
%   the R fraction of the current paper size width.
%
%   VL_PRINTSIZE(R,A) sets also the aspect ratio to A (the aspect ratio
%   is the width divided by the height)
%
%   This command is useful to resize figures before printing them so
%   that elements are scaled to match the final figure size in print.
%
%   See also:: VL_HELP().
[varargout{1:nargout}] = vl_printsize(varargin{:});
