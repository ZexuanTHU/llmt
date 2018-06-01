function [pp1s, pp2s] = mapping_points(p1s, p2s, dist_thres)
%% MAPPING_POINTS find correspondence between two point sets

% Input
% p1s: point set 1, dim: m x 6, [x0, y0, sigma, mag, z0, exitflag]
% p2s: point set 2, dim: n x 6, [x0, y0, sigma, mag, z0, exitflag]
% thres: if the distance is larget than thres, the pair couldn not have 
% been a true pair

num1 = size(p1s,1);
num2 = size(p2s,1);

pairs = zeros(num1, 4);
pairs(:,1:2) = p1s(:,1:2);

dist_mat = ones(num1, num2)*dist_thres;

% distance calculation
for i = 1:num1
    for j = 1:num2
        dist_mat(i,j) = (p1s(i,1)-p2s(j,1))^2 + (p1s(i,2)-p2s(j,2))^2;
    end
end

k = 0;
pp1s = [];
pp2s = [];

for i = 1:num1
    [min_value, idx] = min(dist_mat(i,:));
    if min_value >= dist_thres^2
        pairs(i,3) = 0.0;
        pairs(i,4) = 0.0;
    else
        pairs(i,3) = p2s(idx,1);
        pairs(i,4) = p2s(idx,2);
        k = k+1;
        pp1s(k,:) = p1s(i,:);
        pp2s(k,:) = p2s(idx,:);
    end
end
