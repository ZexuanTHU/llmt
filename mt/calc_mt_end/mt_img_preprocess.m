function mt_img_preprocess
%% PREPROCESSING calculates the curvatures and obtains normalized
%% and blurred mt images
    global gb_mt_imgs;
    global gb_is_preprocessed;
    global gb_Lmax gb_Lmin gb_theta
    global gb_normed_mt_imgs;
    global gb_blurred_mt_imgs;
    global gb_LmaxF gb_LminF gb_blurF;
    global gb_skel;
    global gb_skel_lines;
    
    gb_Lmax = zeros(size(gb_mt_imgs)); % large curvetures
    gb_Lmin = zeros(size(gb_mt_imgs)); % small curvatures
    gb_theta = zeros(size(gb_mt_imgs)); % principal directions
    gb_normed_mt_imgs = zeros(size(gb_mt_imgs)); % normalized images
    gb_blurred_mt_imgs = zeros(size(gb_mt_imgs)); % blurred images
    gb_LmaxF = logical(zeros(size(gb_mt_imgs))); % filtered Lmax
    gb_LminF = logical(zeros(size(gb_mt_imgs))); % filtered Lmin
    gb_blurF = logical(zeros(size(gb_mt_imgs))); % filtered Lmin
    gb_skel = logical(zeros(size(gb_mt_imgs))); % filtered Lmin

    % image info
    [img_h, img_w, num_frames] = size(gb_mt_imgs);
    
    % Ad hoc params
    BG_SUBTRACT_R = 11; % radius for bg subtraction
    Q_NORMALIZATION = 0.8; % suppose that the object fraction < 0.8
    GAUSSIAN_SIGMA = 2; % 2 is the optimal choice for now
    T_CC_BLURRED = 20; % threshold for connected components
    T_CC_LMAX = 20;
    T_CC_LMIN = 3;
    
    %% preprocessing
    % image renormalization
    % Normalizing images
    % Skip this step if the quality of the images are good
    gb_normed_mt_imgs = bg_subtract(gb_mt_imgs,BG_SUBTRACT_R);
    for jj = 1:num_frames
        tmp = gb_normed_mt_imgs(:,:,jj);
        tmp = reshape(tmp, img_h*img_w, 1);
        tmpm = mean(tmp);
        tmpq = quantile(abs(tmp),Q_NORMALIZATION);
        gb_normed_mt_imgs(:,:,jj) = (gb_normed_mt_imgs(:,:,jj)-tmpm)/tmpq;
    end

    gb_blurred_mt_imgs = filter_gauss_2d(gb_normed_mt_imgs, GAUSSIAN_SIGMA);
    [Dx,Dy] = img_1st_derivative(gb_normed_mt_imgs,GAUSSIAN_SIGMA);
    [Dxx,Dxy,Dyy] = img_2nd_derivative(gb_normed_mt_imgs,GAUSSIAN_SIGMA);
    [~, ~, gb_Lmax, gb_Lmin, gb_theta] = img_curvature(Dx, Dy, Dxx, Dxy, Dyy);

    % Quantile thresholding is less effective than mean-std thresholding
    % Quantile Thresholding; calculated once, used repeatedly
    % Q_LMAX = 0.05; % 5% of pixels belong to the ridge of MT in lmax

    tmp = gb_blurred_mt_imgs(:,:,1);
    blur_m = mean(tmp(:));
    blur_s = std(tmp(:));
    gb_blurF = gb_blurred_mt_imgs>(blur_m+2*blur_s); % 2-sigma
    tmp = gb_Lmax(:,:,1);
    lmax_m = mean(tmp(:));
    lmax_s = std(tmp(:));
    gb_LmaxF = gb_Lmax<(lmax_m-2*lmax_s); % 2-sigma
    tmp = gb_Lmin(:,:,1);
    lmin_m = mean(tmp(:));
    lmin_s = std(tmp(:));
    gb_LminF = gb_Lmin<(lmin_m-2*lmin_s); % 2-sigma

    % remove the small patches for blurred
    for jj = 1:num_frames
        tmp = gb_blurF(:,:,jj);
        CC = bwconncomp(tmp);
        CC_stats = regionprops(CC,'Area');
        for kk = 1:(CC.NumObjects)
            if CC_stats(kk).Area < T_CC_BLURRED
                tmp(CC.PixelIdxList{kk}) = 0;
            end
        end
        %       gb_blurF(:,:,jj) = tmp;
        gb_blurF(:,:,jj) = bwmorph(tmp,'dilate');
    end


    % remove the small patches for gb_Lmax
    for jj = 1:num_frames
        tmp = gb_LmaxF(:,:,jj);
        CC = bwconncomp(tmp);
        CC_stats = regionprops(CC,'Area');
        for kk = 1:(CC.NumObjects)
            if CC_stats(kk).Area < T_CC_LMAX
                tmp(CC.PixelIdxList{kk}) = 0;
            end
        end
        %        gb_LmaxF(:,:,jj) = tmp;
        gb_LmaxF(:,:,jj) = bwmorph(tmp,'dilate');
    end

    % remove the small patches for gb_Lmin
    for jj = 1:num_frames
        tmp = gb_LminF(:,:,jj);
        CC = bwconncomp(tmp);
        CC_stats = regionprops(CC,'Area');
        for kk = 1:(CC.NumObjects)
            if CC_stats(kk).Area < T_CC_LMIN
                tmp(CC.PixelIdxList{kk}) = 0;
            end
        end
        %        gb_LminF(:,:,jj) = tmp;
        gb_LminF(:,:,jj) = bwmorph(tmp,'dilate');
    end
    
    % skeleton
    % tmp = gb_blurF .* gb_LmaxF;
    tmp = gb_LmaxF; % different strategy for binarization
    for jj = 1:num_frames
        gb_skel(:,:,jj) = skeleton_zslw(tmp(:,:,jj));
    end
    
    % lines in skeleton
    % num_frames * 1 cells; each cell is a n*5 matrix:
    % x0, y0, theta, length, r2
    gb_skel_lines = find_lines_in_skel_imgs(gb_skel);
    
    gb_is_preprocessed = 1;
end