ps = gb_mt_lines(1).line(1);
pe = gb_mt_lines(1).line(2);
x0 = round(real(ps));
y0 = round(imag(ps));
x1 = round(real(pe));
y1 = round(imag(pe));
img_crop = gb_mt_imgs(y0:y1,x0:x1,:);

mt_sigma = 2.0; % suppose this is correct
gabor_f = gabor_fn(3*mt_sigma,mt_sigma,angle(pe-ps),0);

%% step 1 image input
[M,N,L] = size(gb_mt_imgs);
imgs = double(gb_mt_imgs);

%% step 2 image renormalization
% Normalizing images
% Skip this step if the quality of the images are good
BG_SUBTRACT_R = 11; % radius
Q_NORMALIZATION = 0.8; % suppose that the object fraction < 0.8
imgs = bg_subtract(imgs,BG_SUBTRACT_R);
for i = 1:L
    tmp = imgs(:,:,i);
    tmp = reshape(tmp,M*N,1);
    tmpm = mean(tmp);
    tmpq = quantile(abs(tmp),Q_NORMALIZATION);
    imgs(:,:,i) = (imgs(:,:,i)-tmpm)/tmpq;
end

GAUSSIAN_SIGMA = 2; % 2 is the optimal choice for now
[Dx,Dy] = img_1st_derivative(imgs,GAUSSIAN_SIGMA);
[Dxx,Dxy,Dyy] = img_2nd_derivative(imgs,GAUSSIAN_SIGMA);

[H, G, Lmax, Lmin, theta] = img_curvature(Dx, Dy, Dxx, Dxy, Dyy);

% Quantile Thresholding; calculated once, used repeatedly
% Q_INTENSITY = 0.9; % 10% of pixels belong to MT in intensity image
Q_LMAX = 0.05; % 5% of pixels belong to the ridge of MT in lmax
% intensity
% largest curvature
% direction ensemble

tmp = Lmax(:,:,1);
q = quantile(tmp(:),Q_LMAX);
LmaxF = Lmax<q; % filtered Lmax
LmaxF = logical(LmaxF);

% remove the small patches
t_cc = 20; % threshold
LmaxFF = zeros(size(LmaxF)); % small patches removed
for i = 1:L
    tmp = logical(zeros(M,N));
    CC = bwconncomp(LmaxF(:,:,i));
    CC_stats = regionprops(CC,'Area');
    for j = 1:(CC.NumObjects)
        if CC_stats(j).Area > t_cc
            tmp(CC.PixelIdxList{j}) = 1;
        end
    end
    LmaxFF(:,:,i) = tmp;
end


% LmaxSK = zeros(size(LmaxF));
% for i = 1:L
%     LmaxSK(:,:,i) = skeleton_zslw(LmaxF(:,:,i));
% end
% LmaxSK = logical(LmaxSK);