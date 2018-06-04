function output = bead_localize(img, crop_radius, target_radius)
%% BEAD_LOCALIZE localizes beads in img.

% Input
% img: the input image;
% crop_radius: the radius of cropping circle (in pixel), used to 
% fit the Gaussian model;
% target_radius: the radius of target circle (in pixel), used to
% filter the target region;

% Output:
% output = each line: [x0, y0, sigma, mag, z0, exitflag]


if nargin == 1
    crop_radius = 5;
    target_radius = 3;
end

target_area = pi*target_radius^2;
img_height = size(img, 1);
img_width = size(img, 2);

% preprocessing
img_mean = mean(img(:));
img_std = std(img(:));
img_bw = (img > (img_mean + 3*img_std)); % segmentation
% figure;imshow(img_bw);
se = strel('disk',1);
img_bw2 = imopen(img_bw,se);

% coarse centers
CC = bwconncomp(img_bw2);
% props = regionprops(CC, 'Centroid', 'Area', 'MajorAxisLength', ...
%     'MinorAxisLength', 'PixelIdxList');
props = regionprops(CC, img, 'WeightedCentroid', 'Area', 'MajorAxisLength', ...
    'MinorAxisLength', 'PixelIdxList', 'MaxIntensity');
num_obj = numel(props);

obj_area = cat(1, props.Area);
obj_major_len = cat(1, props.MajorAxisLength);
obj_minor_len = cat(1, props.MinorAxisLength);
obj_ellipsity = obj_major_len./obj_minor_len;
obj_max = cat(1, props.MaxIntensity);

% CENTERING method 1
obj_centroid_1 = cat(1, props.WeightedCentroid);

% CENTERING method 2
%{
obj_pixelidxlist = cell(num_obj, 1);
for i = 1:num_obj
    obj_pixelidxlist{i} = props(i).PixelIdxList;
end
obj_centroid_2 = zeros(num_obj, 2);
for i = 1:num_obj
    max_value = obj_max(i);
    tmp_array = obj_pixelidxlist{i};
    tmp_num = length(tmp_array);
    for j = 1:tmp_num
        if img(tmp_array(j)) == max_value
            [tmp_I, tmp_J] = ind2sub([img_height, img_width], tmp_array(j));
            obj_centroid_2(i,1) = tmp_J;
            obj_centroid_2(i,2) = tmp_I;
            break;
        end
    end
end
%}

% to filter connected components
is_target = logical(zeros(num_obj,1));
for i = 1:num_obj
    % if abs(obj_area(i) - target_area)/target_area > 0.3
    if (obj_area(i) - target_area)/target_area < -0.6
        continue;
    end
    if (obj_area(i) - target_area)/target_area > 1.6
        continue;
    end
    if obj_ellipsity > 1.5
        continue;
    end
    is_target(i) = 1;
end

% fine centers
target_centers = obj_centroid_1(is_target,:);
% target_centers = obj_centroid_2(is_target,:);
target_centers_2 = round(target_centers);

num_target = nnz(is_target);
% centers_2 = zeros(num_target, 2);
output_2 = zeros(num_target, 6);
is_real_target = logical(ones(num_target,1));

% to localize the center of each beads
for i = 1:num_target
    x0 = target_centers_2(i, 1);
    y0 = target_centers_2(i, 2);
    if x0 - crop_radius < 1 || ...
            x0 + crop_radius > img_width || ...
            y0 - crop_radius < 1 || ...
            y0 + crop_radius > img_height
        is_real_target(i) = 0;
        continue;
    end
    tmp_patch = img((y0-crop_radius):(y0+crop_radius), ...
        (x0-crop_radius):(x0+crop_radius));
    tmp_bw = img_bw2((y0-crop_radius):(y0+crop_radius), ...
        (x0-crop_radius):(x0+crop_radius));
    [xx0, yy0] = point_localize_by_weight(tmp_patch);
    sigma0 = sqrt(nnz(tmp_bw)/pi);
    mag0 = max(tmp_patch(:));
    output_2(i,:) = point_localize_by_fitting(tmp_patch, xx0, yy0, sigma0, mag0, img_mean);
    output_2(i,1) = output_2(i,1) + x0 - (crop_radius+1);
    output_2(i,2) = output_2(i,2) + y0 - (crop_radius+1);
end

output = output_2(is_real_target,:);

end
