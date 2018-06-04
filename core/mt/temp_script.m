% Aim:
% 1. to test the influence of the uncertainty of the l0 and the
% sigma on the smoothing process
% 2. to test the influence of the type of noise of the y0 on the
% smoothing process

% erfc model
l0 = 0;
sigma = 1;
H = 1;
b = 0;
params = [l0;sigma;H;b];

% noise model
l0_sigma = 2;
sigma_sigma = 0;
y_sigma = 0;

% simulated data
if(sigma>4)
    x = linspace(-4*sigma,4*sigma,round(8*sigma)+1);
else
    x = linspace(-4*sigma,4*sigma,40);
end
x = x';
y0 = mt_erfc(params,x);
np = numel(x);
num_line = 100;
y = zeros(np,num_line);
real_params_mean = zeros(size(params));
for ii = 1:num_line
    real_l0 = l0 + randn * l0_sigma;
    real_sigma = sigma + randn * sigma_sigma;
    real_params = [real_l0; real_sigma; H; b];
    real_params_mean = real_params_mean + real_params;
    y(:,ii) = mt_erfc(real_params,x) + randn(np,1)*y_sigma;
end
real_params_mean = real_params_mean / num_line;

% smoothing
real_y = mean(y,2);

% fit the smoothed curve
OPTIONS = optimoptions('lsqcurvefit', ...
                       'Algorithm', 'levenberg-marquardt', ...
                       'Display','off');
fit_params_in = [l0, sigma, H, b];
[fit_params_out,b,~,c,~] = lsqcurvefit(@mt_erfc, ...
                                       fit_params_in, ...
                                       x, ...
                                       real_y, ...
                                       [], ...
                                       [], ...
                                       OPTIONS);
fited_y = mt_erfc(fit_params_out,x);

figure;
plot(x,real_y,'ro');
hold on;
plot(x,y0,'k-');
plot(x,fited_y,'b--');
hold off;
str1 = strcat('smooth:  ',sprintf('%.02f  ',real_params_mean));
str2 = strcat('clean:  ',sprintf('%.02f  ',params));
str3 = strcat('fit:  ',sprintf('%.02f  ',fit_params_out));
legend({str1,str2,str3},'FontSize',14);
% params
% real_params
% fit_params_out