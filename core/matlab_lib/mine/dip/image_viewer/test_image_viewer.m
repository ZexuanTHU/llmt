test_img = tif_img_reader('syl.tif');
[img_h,img_w,num_frames] = size(test_img);
imgroi2 = struct;
imgroi2.p = rand(2,1,num_frames);
imgroi2.p(1,1,:) = imgroi2.p(1,1,:)*img_w;
imgroi2.p(2,1,:) = imgroi2.p(2,1,:)*img_h;
imgroi2.r = zeros(4,1,num_frames);
imgroi2.r(1,1,:) = rand(1,1,num_frames)*img_w;
imgroi2.r(2,1,:) = rand(1,1,num_frames)*img_h;
imgroi2.r(3,1,:) = rand(1,1,num_frames)*img_w/2;
imgroi2.r(4,1,:) = rand(1,1,num_frames)*img_h/2;
image_viewer(test_img,imgroi2);