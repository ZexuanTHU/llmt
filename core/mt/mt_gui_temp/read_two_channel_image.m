function [red, green] = read_two_channel_image(img_filename)

    num_channels = 2;
    img_info = imfinfo(img_filename);
    num_frames = numel(img_info)/num_channels;
    img_width = img_info(1).Width;
    img_height = img_info(1).Height;
    red = zeros(img_height, img_width, num_frames);
    green = zeros(img_height, img_width, num_frames);

    for i = 1:num_frames
        red(:,:,i) = imread(img_filename, 2*i-1);
        green(:,:,i) = imread(img_filename, 2*i);
    end
