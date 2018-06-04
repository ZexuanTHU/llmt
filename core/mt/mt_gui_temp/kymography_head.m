function head_profiles = kymography_head(img, params, half_len, np)
%% KYMOGRAPHY_HEAD extracts the head profiles

% Input:
% img: the image to be profiled
% params: the output of fitted parameters of filament ends
% half_len: the half length of the profiling line
% np: number of points of the inside the profiling line

% Output:
% head_profiles: size: n * (2*np+1)

[h, w, n] = size(img);
head_profiles = zeros(n, (2*np+1));
x = zeros(2,1);
y = zeros(2,1);

for j = 1:n
    x0 = params(j,1);
    y0 = params(j,2);
    theta = params(j,4);
    x(1) = x0 - half_len*cos(theta);
    y(1) = y0 - half_len*sin(theta);
    x(2) = x0 + half_len*cos(theta);
    y(2) = y0 + half_len*sin(theta);
    sigma = params(j,3);
    % % line_half_width 1
    % line_half_width = sigma-1;
    % if(line_half_width<0)
    %     line_half_width = 0;
    % end
    % line_half_width 2
    line_half_width = 0; % 
    head_profiles(j,:) = my_line_profile(img(:,:,j), x, y, ...
                                         line_half_width, ...
                                         (2*np+1));
end