function z = gaussian_2d(param, xdata)
%% GAUSSIAN_2D calculates the value for a symmetric 2d gaussian function.

% Input:
% param: the parameters, [x0, y0, sigma, a, b]
% xdata: x and y
% z = b + a*exp(((x-x0)^2+(y-y0)^2)/sigma);

% param(1): x0
% param(2): y0
% param(3): sigma
% param(4): magnitude
% param(5): baseline

z = param(5) + param(4) .* exp(-((xdata(:,:,1)-param(1)).^2+(xdata(:,:,2)-param(2)).^2)/(2*param(3)^2));
