function correct_red
%% CORRECT_RED corrects the red channel by using the gb_tform
% Input: gb_map_imgs, gb_tform
% Output: gb_map_imgs
    global gb_map_imgs;
    global gb_tform;
    imgs_tmp = correct_internal(gb_map_imgs, gb_tform);
    gb_map_imgs = imgs_tmp;
end
