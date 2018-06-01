function [x0,y0] = point_localize_by_weight(img)
%% POINT_LOCALIZE_BY_WEIGHT localizes the center of a gaussian 
% distribution in an image and returns the coordinate of the center in 
% the local coordinate system.

% img = double(img);
% img = img./max(img(:));
[m,n] = size(img);

sum_x = 0.0;
sum_y = 0.0;
sum = 0.0;

for i = 1:m
    for j = 1:n
        sum_x = sum_x + img(i,j)*j;
        sum_y = sum_y + img(i,j)*i;
        sum = sum + img(i,j);
    end
end

x0 = sum_x/sum;
y0 = sum_y/sum;
