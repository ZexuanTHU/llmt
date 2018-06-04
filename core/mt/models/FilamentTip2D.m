function I = FilamentTip2D(params, xdata)

x = xdata(:,:,1);
y = xdata(:,:,2);

% params:
x0 = params(1);
y0 = params(2);
sigma = params(3);
theta = params(4);
H = params(5); % amplitude
b = params(6); % baseline

f = -(x-x0).*sin(theta-pi/2) + (y-y0).*cos(theta-pi/2) + 0.5;
f( f < 0 ) = 0;
f( f > 1 ) = 1;
A = 1/(2*sigma^2);
I = H*( f .*exp( -A*( ( x-x0 ).^2 + ( y-y0 ).^2 ) ) + ...
        (1-f).*exp( -A*(-( x-x0 )*sin(theta) + ( y-y0 )*cos(theta)).^2) ) + ...
    b;
end
