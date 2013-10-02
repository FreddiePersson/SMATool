function y = scaleToUnity(x,varargin)
	% SCALETOUNITY Scale one dimensional vector to unity intervall
	%   
	% Syntax:
	%   
	%   y = scaleToUnity(x)
	%   y = scaleToUnity(x,int)
	%   
	% Description:
	%   
	%   scaleToUnity(x) scales the one dimensional vector x to the
	%   unity intervall with min(x) == 0 and max(x) == 1.
	%   
	%   scaleToUnity(x,int) uses int as reference for scaling with
	%   min(int) == 0 and max(int) == 1.
	%   
	
	% Get input
	if (nargin == 2)
		int = varargin{1};
	else
		int = [min(x) max(x)];
	end
	
	% Scale
	y = x - min(int);
	y = y ./ (max(int)-min(int));
	
end
