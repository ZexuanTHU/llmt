function sigma = estimate_sigma(mt_img, p)

NUM_IMG_TO_ESTIMATE = 4;

for i = 1:NUM_IMG_TO_ESTIMATE
    img = mt_img(:,:,i);
end

end