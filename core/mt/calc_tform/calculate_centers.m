function [red_output, green_output] = calculate_centers(fname, crop_radius, target_radius, dist_thres, sigma_thres, mag_thres)
%% CALCULATE_OFFSETS localizes the beads in red and green images

% Input
% fname: the image file name, should contain at least two channels
% crop_radius: the radius of cropping circle, in pixel
% target_radius: the radius of target circle, in pixel
% thres: the binarization threshold

% Output:
% red_output = [x0, y0, sigma, mag, z0, exitflag]
% green_output = [x0, y0, sigma, mag, z0, exitflag]

if nargin == 1
    crop_radius = 5;
    target_radius = 3;
    dist_thres = 3.0;
    sigma_thres = 2.0;
    mag_thres = 0.8;
end

info = imfinfo(fname);
num_images = numel(info);
red = imread(fname,1);
red = double(red);
red = red/max(red(:));
green = imread(fname,2);
green = double(green);
green = green/max(green(:));
% blue = imread(fname,3);

% centers
red_output = bead_localize(red, crop_radius, target_radius);
green_output = bead_localize(green, crop_radius, target_radius);
[p1s,p2s] = mapping_points(red_output, green_output, dist_thres);

% filtering: sigma
num_points = size(p1s, 1);
j = 0;
pp1s = [];
pp2s = [];
tmp_sigma_thres = 0.3 * sigma_thres;
for i = 1:num_points
    if (abs(p1s(i,3)-sigma_thres)<tmp_sigma_thres) ...
            && (abs(p2s(i,3)-sigma_thres)<tmp_sigma_thres)
        j = j+1;
        pp1s(j,:) = p1s(i,:);
        pp2s(j,:) = p2s(i,:);
    end
end

% filtering: intensity
p1s = pp1s;
p2s = pp2s;
num_points = size(p1s, 1);
j = 0;
pp1s = [];
pp2s = [];
for i = 1:num_points
    if p1s(i,4)>mag_thres ...
            && p2s(i,4)>mag_thres
        j = j+1;
        pp1s(j,:) = p1s(i,:);
        pp2s(j,:) = p2s(i,:);
    end
end

red_output = pp1s;
green_output = pp2s;

end
