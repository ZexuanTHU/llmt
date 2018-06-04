function imagej_tf = read_imagej_tf(tf_file)
%% READ_IMAGEJ_TF reads the transformation matrix file obtained by
% ImageJ Plugin MultiStackReg and returns a struct imagej_tf

% Input:
% tf_file: the transformation matrix file

% Output:
% imagej_tf: a struct, see below.

imagej_tf = struct('type',{}, ... % type, RIGID_BODY or TRANSLATION
                   'src_f', {}, ... % Source frame
                   'tar_f', {}, ... % Target frame
                   'src_p', {}, ... % Three source points, 3*2
                   'tar_p', {} ... % Three target points, 3*2
                   );

% open the transformation file
fid = fopen(tf_file, 'r');

% check the first three line
line = fgets(fid);
if(strcmp(line(1:end-1),'MultiStackReg Transformation File')~=1)
    return;
end
line = fgets(fid);
if(strcmp(line(1:end-1),'File Version 1.0')~=1)
    return;
end
line = fgets(fid);

% read the remaining part
lines = {};
while(~feof(fid))
    lines{end+1} = fgets(fid);
end
fclose(fid);

lines_per_part = 10;
num_tf = round(numel(lines)/lines_per_part);

for jj = 1:num_tf
    idx = (jj-1)*lines_per_part;
    line = lines{idx+1};
    imagej_tf(jj).type = sscanf(line, '%s');
    line = lines{idx+2};
    frames = sscanf(line, 'Source img: %d Target img: %d');
    imagej_tf(jj).src_f = frames(1);
    imagej_tf(jj).tar_f = frames(2);
    mat1 = zeros(3,2);
    mat2 = zeros(3,2);
    vec = zeros(2,1);
    vec = sscanf(lines{idx+3}, '%f\t%f');
    mat1(1,1:2) = vec';
    vec = sscanf(lines{idx+4}, '%f\t%f');
    mat1(2,:) = vec';
    vec = sscanf(lines{idx+5}, '%f\t%f');
    mat1(3,:) = vec';
    vec = sscanf(lines{idx+7}, '%f\t%f');
    mat2(1,:) = vec';
    vec = sscanf(lines{idx+8}, '%f\t%f');
    mat2(2,:) = vec';
    vec = sscanf(lines{idx+9}, '%f\t%f');
    mat2(3,:) = vec';
    imagej_tf(jj).src_p = mat1;
    imagej_tf(jj).tar_p = mat2;
end

end