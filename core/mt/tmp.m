% tmpl = find_lines_in_skel_imgs(skel_imgs(:,:,1:10));
figure('units','normalized','outerposition',[0 0 0.5 0.5]);
num_frames = size(gb_mt_imgs,3);
tmpl = gb_skel_lines;

for jj = 1:num_frames
    %    close(gcf);
    ll = tmpl{jj};
    imshow(gb_skel(:,:,jj),[]);hold on;
    for ii = 1:size(ll,1)
        x0=ll(ii,1);
        y0=ll(ii,2);
        x1=x0+0.5*ll(ii,4)*cos(ll(ii,3));
        x2=x0-0.5*ll(ii,4)*cos(ll(ii,3));
        y1=y0+0.5*ll(ii,4)*sin(ll(ii,3));
        y2=y0-0.5*ll(ii,4)*sin(ll(ii,3));
        plot(x0,y0,'y*','MarkerFaceColor','y','MarkerSize',10);
        plot([x1,x2],[y1,y2],'ro-','MarkerFaceColor','r','MarkerSize',10);
    end
    hold off;
    drawnow;
    pause(0.5);
end
