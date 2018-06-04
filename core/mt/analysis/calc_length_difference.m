function dL = calc_length_difference(p1, phi1, p2, phi2)
%% CALC_LENGTH_DIFFERENCE calculates the length difference
% between two line segment.
% The two line segments are specificed by p1, phi1, p2, phi2.
% The intersection of two lines is calculated first, then 
% the two segments are specified by two points, which can be
% used to calculate the length and projection.

% Input:
% p1,p2: complex point
% phi1, phi2: angles in rad


% Output:
% dL: length difference

N = numel(p1);
dL = nan(N,1);

for jj = 1:N
    if isnan(p1(jj)) || isnan(p2(jj)) ...
        || isnan(phi1(jj)) || isnan(phi2(jj))
        continue;
    end
    x1 = real(p1(jj));
    x2 = real(p2(jj));
    y1 = imag(p1(jj));
    y2 = imag(p2(jj));
    theta1 = phi1(jj);
    theta2 = phi2(jj);
    if abs(theta1-theta2)<(pi/36)
        dL(jj) = abs(p1(jj)-p2(jj))...
        *abs(cos(angle(p1(jj)-p2(jj))-theta1/2-theta2/2));
        continue;
    end
    A = [-sin(theta1), cos(theta1); ...
    -sin(theta2), cos(theta2)];
    b = [-sin(theta1)*x1 + cos(theta1)*y1; ...
    -sin(theta2)*x2 + cos(theta2)*y2];
    c = A\b;
    p0 = c(1)+sqrt(-1)*c(2);
    l1 = abs(p1(jj)-p0);
    l2 = abs(p2(jj)-p0);
    dL(jj) = abs(l2 - l1);
end

end
