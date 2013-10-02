function y = rescaleVar(x,int)
	% RESCALEVAR Rescales vector values to specified intervall.
	%
	% Syntax:
	%
	%   y = rescaleVar(x,int)
	%
	% Description:
	%
	%   rescaleVar(x,int) rescales the one dimensional vector x
	%   to the intervall defined in int.
	%
	
	y = x .* (max(int) - min(int));
	y = y + min(int);
	
end
