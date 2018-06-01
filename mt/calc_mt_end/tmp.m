img = tif_img_reader('/home/image/temp/temp/original.tif');

Lmax = zeros(size(img)); % large curvetures
Lmin = zeros(size(img)); % small curvatures
theta = zeros(size(img)); % principal directions
LmaxF = logical(zeros(size(img))); % filtered Lmax
LminF = logical(zeros(size(img))); % filtered Lmin
skel = logical(zeros(size(img))); % filtered Lmin

% image info
[img_h, img_w, num_frames] = size(img);

% Ad hoc params
BG_SUBTRACT_R = 11; % radius for bg subtraction
Q_NORMALIZATION = 0.8; % suppose that the object fraction < 0.8
GAUSSIAN_SIGMA = 2; % 2 is the optimal choice for now
T_CC_LMAX = 20;
T_CC_LMIN = 3;
T_CC_SKEL = 10;

%% preprocessing
% image renormalization
% Normalizing images
% Skip this step if the quality of the images are good
normed_img = bg_subtract(img,BG_SUBTRACT_R);
for jj = 1:num_frames
    tmptmp = normed_img(:,:,jj);
    tmptmp = reshape(tmptmp, img_h*img_w, 1);
    tmpm = mean(tmptmp);
    tmpq = quantile(abs(tmptmp),Q_NORMALIZATION);
    normed_img(:,:,jj) = (normed_img(:,:,jj)-tmpm)/tmpq;
end

[Dx,Dy] = img_1st_derivative(normed_img,GAUSSIAN_SIGMA);
[Dxx,Dxy,Dyy] = img_2nd_derivative(normed_img,GAUSSIAN_SIGMA);
[~, ~, Lmax, Lmin, theta] = img_curvature(Dx, Dy, Dxx, Dxy, Dyy);


% Quantile thresholding is less effective than mean-std thresholding
% Quantile Thresholding; calculated once, used repeatedly
% Q_LMAX = 0.05; % 5% of pixels belong to the ridge of MT in lmax

tmptmp = Lmax(:,:,1);
lmax_m = mean(tmptmp(:));
lmax_s = std(tmptmp(:));
LmaxF = Lmax<(lmax_m-0.9*lmax_s); % 0.9-sigma
tmptmp = Lmin(:,:,1);
lmin_m = mean(tmptmp(:));
lmin_s = std(tmptmp(:));
LminF = Lmin<(lmin_m-2*lmin_s); % 2-sigma

% remove the small patches for Lmax
for jj = 1:num_frames
    tmptmp = LmaxF(:,:,jj);
    CC = bwconncomp(tmptmp);
    CC_stats = regionprops(CC,'Area');
    for kk = 1:(CC.NumObjects)
        if CC_stats(kk).Area < T_CC_LMAX
            tmptmp(CC.PixelIdxList{kk}) = 0;
        end
    end
    LmaxF(:,:,jj) = tmptmp;
    %    LmaxF(:,:,jj) = bwmorph(tmptmp,'dilate');
end

% skeleton
% tmptmp = blurF .* LmaxF;
tmptmp = LmaxF; % different strategy for binarization
for jj = 1:num_frames
    skel(:,:,jj) = skeleton_zslw(tmptmp(:,:,jj));
end

% remove the small patches for skel
for jj = 1:num_frames
    tmptmp = skel(:,:,jj);
    CC = bwconncomp(tmptmp);
    CC_stats = regionprops(CC,'Area');
    for kk = 1:(CC.NumObjects)
        if CC_stats(kk).Area < T_CC_SKEL
            tmptmp(CC.PixelIdxList{kk}) = 0;
        end
    end
    skel(:,:,jj) = tmptmp;
    %    LmaxF(:,:,jj) = bwmorph(tmptmp,'dilate');
end



for jj = 1:num_frames
    str = strcat('/home/image/temp/temp/skel_',num2str(jj),'.tif');
    imwrite(skel(:,:,jj),str,'TIFF','Compression','none');
end