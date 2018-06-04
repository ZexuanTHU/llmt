figure;

red=double(gb_red_cropped);
green=double(gb_green_cropped);
blue = zeros(size(red,1),size(red,2));

for i = 1:80
    red(:,:,i) = red(:,:,i)/max(max(red(:,:,i)));
    green(:,:,i) = green(:,:,i)/max(max(green(:,:,i)));
    img = cat(3, ...
        red(:,:,i), ...
        green(:,:,i),...
        blue);
    imshow(img,[]);
    drawnow;
    pause(0.1);
end