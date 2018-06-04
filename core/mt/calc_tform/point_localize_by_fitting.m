function output = point_localize_by_fitting(img, xx0, yy0, sigma0, mag0, zz0)
%% POINT_LOCALIZE_BY_WEIGHT localizes the center of a single point in an 
% image and returns the coordinate of the center in the local coordinate 
% system.

% Input:
% img: input image
% xx0: initial x0
% yy0: initial y0

% Output:
% output = [x0, y0, sigma, mag, z0, exitflag]

output = zeros(6,1);

[m,n] = size(img);

param0 = zeros(5,1);
param0(1) = xx0;
param0(2) = yy0;
param0(3) = sigma0; % sigma
param0(4) = mag0; % magnitude
param0(5) = zz0; % baseline

[X,Y] = meshgrid(1:n, 1:m);

xdata = zeros(m,n,2);
xdata(:,:,1) = X;
xdata(:,:,2) = Y;


% [param, resnorm, residual, exitflag] = ...
%%    lsqcurvefit(@gaussian_2d, param0, xdata, img);

% To turn off the warning
OPTIONS_0 = optimoptions('lsqcurvefit', ...
    'Algorithm','levenberg-marquardt');
OPTIONS_1 = optimoptions('lsqcurvefit', ...
    'Algorithm', 'levenberg-marquardt', ...
    'Display','off');
OPTIONS_2 = optimoptions('lsqcurvefit', ...
    'Algorithm', 'levenberg-marquardt', ...
    'MaxIter', 2000, ...
    'TolFun', 1e-8, ...
    'TolX', 1e-8, ...
    'Display','off');
[param, resnorm, residual, exitflag] = ...
    lsqcurvefit(@gaussian_2d, param0, xdata, img, [], [], OPTIONS_1);

x0 = param(1);
y0 = param(2);
sigma = param(3);
mag = param(4);
z0 = param(5);

output(1) = x0;
output(2) = y0;
output(3) = sigma;
output(4) = mag;
output(5) = z0;
output(6) = exitflag;

%{
% Debug
Z = gaussian_2d(param, xdata);
surf(X, Y, Z);
hold on;
plot3(X, Y, img, 'ro');
hold off;
%}