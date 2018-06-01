function p = get_points_from_frames(img)
%% GET_POINTS_FROM_FRAMES extract one point from each frame by
% clicking through the frames.

[h,w,n] = size(img);
p = ones(n,1)*(1+1i);

% window size adjustment
scrsize = get(0,'screensize');
mag_vec = [floor(scrsize(3)/w); floor(scrsize(4)/h); 4];
mag = min(mag_vec)*100;

h_fig = figure;
set(h_fig, ...
    'position', get(0,'screensize'), ...
    'Toolbar','none',...
    'Menubar','none');

% point picker
for i = 1:n
    imshow(img(:,:,i),[],'InitialMagnification',mag);
    pp = ginput(1);
    p(i) = pp(1)+pp(2)*sqrt(-1);
end

close(h_fig);