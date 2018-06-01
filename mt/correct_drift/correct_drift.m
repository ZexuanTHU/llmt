function out = correct_drift(in, tf_file)
%% CORRECT_DRIFT is corrects drift with transformation matrix
% calculated by ImageJ/MultiStackReg plugin.
% The program is used for 2D images

% Input: 
% in: input image (h*w*num_frames)
% tf_file: the transformation matrix obtained by ImageJ plutin
% MultiStackReg 

% Output:
% out: output image

[h, w, num_frames] = size(in);
out = zeros(h,w,num_frames);

%% read the tf_file
imagej_tf = read_imagej_tf(tf_file);

num_tf = numel(imagej_tf);

for jj = 1:num_tf
    tf_type = imagej_tf(jj).type;
    src_p = imagej_tf(jj).src_p;
    tar_p = imagej_tf(jj).tar_p;
    frame = imagej_tf(jj).src_f;
    mat = eye(3,3);
    tx = tar_p(1,1) - src_p(1,1);
    ty = tar_p(1,2) - src_p(1,2);
    phi = 0;
    if(strcmp(tf_type, 'RIGID_BODY'))
        src_phi = angle(src_p(3,1)-src_p(2,1) + ...
                        i*(src_p(3,2)-src_p(2,2)));
        tar_phi = angle(tar_p(3,1)-tar_p(2,1) + ...
                        i*(tar_p(3,2)-tar_p(2,2)));
        phi = tar_phi - src_phi;
    end
    A = [cos(phi), -sin(phi), 0;
        sin(phi), cos(phi), 0;
        0,0,1];
    A = A*[1,0,tx; 0,1,ty; 0,0,1];
    % maketform transforms a vector by left matrix multiplication,
    % e.g., v = u*A', contrary to the conventional form v = A*u
    TF = maketform('affine',A');
    out(:,:,frame) = imtransform(in(:,:,frame), TF, ...
                                 'XData', [1 w], ...
                                 'YData', [1 h]);
end

out(:,:,imagej_tf(1).tar_f) = in(:,:,imagej_tf(1).tar_f);

%% Correction

end