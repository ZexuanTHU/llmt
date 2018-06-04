function inv_correct_red
%% CORRECT_RED inversely corrects the red channel by using the gb_tform
% Input: gb_map_imgs, gb_tform
% Output: gb_map_imgs
    global gb_map_imgs;
    global gb_tform;
    inv_tform = gb_tform;
    inv_tform.tdata.T = gb_tform.tdata.Tinv;
    inv_tform.tdata.Tinv = gb_tform.tdata.T;
    imgs_tmp = correct_internal(gb_map_imgs, inv_tform);
    gb_map_imgs = imgs_tmp;
end
