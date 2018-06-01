function I = mylog(params,xdata)
x = xdata(:,:,1);
y = xdata(:,:,2);

% params:
x0 = params(1);
y0 = params(2);
sigma = params(3);
H = params(4); % amplitude
b = params(5); % baseline

I = -H*(1-((x-x0).^2+(y-y0).^2)/(2*sigma^2)).*(exp(-((x-x0).^2+(y-y0).^2)/(2*sigma^2)));

end