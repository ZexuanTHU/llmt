function imgs_out = correct_internal(imgs_in, varargin)
%% CORRECT_INTERNAL applies tform on imgs_in and returns imgs_out

[M, N, L] = size(imgs_in);
imgs_out = zeros(M, N, L);

xdata = [1 N];
ydata = [1 M];

for i = 1:L
    imgs_out(:,:,i) = imtransform( ...
        imgs_in(:,:,i), ...
        varargin{:}, ...
        'XData', xdata, ...
        'YData', ydata);
end

end