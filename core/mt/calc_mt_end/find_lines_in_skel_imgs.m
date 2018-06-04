function lines = find_lines_in_skel_imgs(skel_imgs)
%% FIND_LINES_IN_SKEL_IMGS finds lines in skeleton image
% series
% A particular application is to extract information of 
% microtubule from images obtained in in-vitro assay.
% The input images is of low complexity.
% Future extension: find curvilinear structures, e.g., 
% cytoskeletal strucutres in cells.

% Input:
% skel_imgs: skeletonized image series
% Output:
% lines: n*1 cells
% each cell is an n*5 matrix
% n: number of lines found
% 5: (center) x0, y0, theta, length, r2

% some ad-hoc params
min_pixel = 5; % if the component is too short, skip
f_cross = 2; % assume that the overlapping segments for each
             % connected component are no more than 2
ransac_iter = 40; % ransac
ransac_thres = 1; % ransac, dist thres is extra small here
ransac_num = 4; % ransac
ransac_ratio = 0.2; % ransac
min_pt_num = 5; % ignore point set with less than 5 pts
min_in_num = ransac_num; % ignore inlier set with less than 3 pts

[M,N,L] = size(skel_imgs);
lines = cell(L,1); % all lines

for ii = 1:L
    img = skel_imgs(:,:,ii);
    % find the connected components
    CC = bwconncomp(img);
    num_CC = CC.NumObjects;
    l = nan(num_CC*f_cross, 5); % pre-allocation memory
    curr_idx = 0;
    % resolve overlapping segements, if existed
    for jj = 1:num_CC
        % no more than num_CC*f_cross lines
        if curr_idx >= num_CC*f_cross
            break;
        end
        % ignore components with less than 5 points
        tmp_ind = CC.PixelIdxList{jj};
        [tmpy, tmpx] = ind2sub([M,N], tmp_ind);
        outs = [tmpx, tmpy];
        % make sure point set contains more than 5 points:)
        while (size(outs,1) > min_pt_num)
            [A, ins, outs] = simple_ransac(outs, ...
                                           ransac_iter, ...
                                           ransac_thres, ...
                                           ransac_num, ...
                                           ransac_ratio);
            if size(ins,1)<min_in_num
                continue;
            end
            % re-evaluate the linear model
            [a,b,c,r2] = linear_fit_3( ins(:,1), ins(:,2) );
            % rotation
            theta = atan(-a/b);
            rot_ins = ins*[cos(theta),-sin(theta);...
                           +sin(theta),cos(theta)];
            % find ends
            [min_x,min_ind] = min(rot_ins(:,1));
            [max_x,max_ind] = max(rot_ins(:,1));
            % find length
            len = max_x - min_x;
            % find center
            u = ins(min_ind,1);
            v = ins(min_ind,2);
            p_min_x = b*(b*u-a*v)-a*c;
            p_min_y = -a*(b*u-a*v)-b*c;
            u = ins(max_ind,1);
            v = ins(max_ind,2);
            p_max_x = b*(b*u-a*v)-a*c;
            p_max_y = -a*(b*u-a*v)-b*c;
            x0 = 0.5*(p_min_x + p_max_x);
            y0 = 0.5*(p_min_y + p_max_y);
            
            % update current line
            curr_idx = curr_idx + 1;
            l(curr_idx,1) = x0;
            l(curr_idx,2) = y0;
            l(curr_idx,3) = theta;
            l(curr_idx,4) = len;
            l(curr_idx,5) = r2;
        end
    end
    tmp_ind = ~(isnan(l(:,1)));
    l = l(tmp_ind,:);
    lines{ii} = l;
end

end