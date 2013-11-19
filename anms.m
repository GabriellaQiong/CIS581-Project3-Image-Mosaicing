function [y, x, rmax] = anms(cimg, max_pts)
% ANMS implements Adaptive Non-maximum Supression for image corners

% INPUT
% cimg    = corner strength map 
% max_pts = number of corners desired

% OUTPUT 
% [y, x]  = coordinates of corners
% rmax    = suppression radius used to get max_pts corners

% Written by Qiong Wang at University of Pennsylvania
% Nov. 9th, 2013

% Find the corners indices and their coordinates
corners     = imregionalmax(cimg);
cimg        = bsxfun(@times, corners, cimg);
cornerIdx   = find(cimg);
[y, x]      = ind2sub(size(cimg), cornerIdx);
cornerNum   = size(y, 1);

% Loop to find maximum radius
radius = Inf(cornerNum, 1);
for i = 1 : cornerNum
   for j = 1 : cornerNum
       if (cimg(y(j), x(j)) > cimg(y(i), x(i)))
           dist = (y(j) - y(i))^2 + (x(j) - x(i))^2;
           if (dist < radius(i))
              radius(i) = dist; 
           end
       end
   end
end

% Sort by radius in decreasing order to find max_pts corner points
[radius, radiusIX] = sort(radius, 'descend');
if max_pts > size(y,1)
    max_pts = size(y,1);
end
y    = y(radiusIX(1 : max_pts));
x    = x(radiusIX(1 : max_pts));
rmax = sqrt(radius(1 : max_pts));
end