function [pp1, pp2] = extract_roi_from_2p(p1, p2, b)
%% EXTRACT_ROI_FROM_2P obtains 2d roi from an image img.

% Input:
% p1, p2: the roi rectangle
% b: the expanding border around p1 and p2 

% Output: return final crop coord
% pp1: the point near the origin
% pp2: the other point

% !Note:
% line pp1-pp2 could be diagonal to line p1-p2

p1 = round(p1);
p2 = round(p2);

x1 = min(real(p1), real(p2));
x2 = max(real(p1), real(p2));
y1 = min(imag(p1), imag(p2));
y2 = max(imag(p1), imag(p2));

x1 = x1 - b;
x2 = x2 + b;
y1 = y1 - b;
y2 = y2 + b;

pp1 = x1 + y1*sqrt(-1);
pp2 = x2 + y2*sqrt(-1);

end