function kymo = get_kymograph(imgs, x, y, d, n)
%% GET_KYMOGRAPH returns the kymography
% The kymograph is specified by: x, y, d, n

% Input:
% imgs: 2D image series 
% x,y: 2x1 vector, defining the start and end points
% d: the half width of the profiling line
% n: the length of the returning vector
    
    [img_h, img_w, num_imgs] = size(imgs);
    kymo = zeros(num_imgs, n);

    for i = 1:num_imgs
        kymo(i,:) = my_line_profile(imgs(:,:,i), x, y, d, n);
    end

end