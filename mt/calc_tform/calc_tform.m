function tform = calc_tform(bead_file_list)
%% CALC_TFORM calculates the 
% tform: ch1 -> ch2 ?

% Input:
% bead_file_list: cell array of bead file name (double channel)

% Output: 
% tform: transformation matrix, transform from red to green
% so you can applined tform to the uncorrected red channel:)

    if ~iscell(bead_file_list)
        return;
    end

    %% calculating transform matrix
    all_red_centers = [];
    all_green_centers = [];
    all_green_red_offsets = [];

    crop_radius = 6.0;
    target_radius = 4.0;
    dist_thres = 5.0;
    sigma_thres = 2.0;
    mag_thres = 0.2;
    img_width = 0;
    img_height = 0;

    num_bead_file = numel(bead_file_list);

    for i = 1:num_bead_file
        fname = bead_file_list{i};
        red = imread(fname,1);
        green = imread(fname,2);
        
        tmp = size(red, 1);
        if tmp > img_height
            img_height = tmp;
        end
        tmp = size(red, 2);
        if tmp > img_width
            img_width = tmp;
        end
        
        red = double(red);
        red = red/max(red(:));
        green = double(green);
        green = green/max(green(:));
        
        [red_centers, green_centers] = calculate_centers(fname, crop_radius, target_radius, dist_thres, sigma_thres, mag_thres);
        
        all_red_centers = cat(1, all_red_centers, red_centers);
        all_green_centers = cat(1, all_green_centers, green_centers);
    end

    % please note the order of the parameters
    test_red_centers = all_red_centers(:,1:2);
    test_green_centers = all_green_centers(:,1:2);
    tform = cp2tform(test_red_centers, test_green_centers, 'affine');

end