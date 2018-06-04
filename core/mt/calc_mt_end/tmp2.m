tmptmp2 = 0.5;
LmaxF = Lmax<(lmax_m-tmptmp2*lmax_s); % 0.9-sigma
tmptmp = LmaxF; % different strategy for binarization
for jj = 1:num_frames
    skel(:,:,jj) = skeleton_zslw(tmptmp(:,:,jj));
end


for jj = 1:num_frames
    str = strcat('/home/image/temp/temp/skel_',num2str(jj),'.tif');
    imwrite(skel(:,:,jj),str,'TIFF','Compression','none');
end
