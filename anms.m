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
cornerIdx   = find(cimg);
[y, x]      = ind2sub(size(cimg), cornerIdx);
cornerCoord = [y, x];
cornerNum   = size(cornerCoord, 1);

% Loop to find maximum radius
radius = Inf(cornerNum, 1);
for i = 1 : cornerNum
   for j = 1 : cornerNum
       if cimg(cornerCoord(j, :)) <= cimg(cornerCoord(i, :))
           continue
       end
       radius(i) = min(norm(cornerCoord(i, :) - cornerCoord(j, :)), radius(i));
   end
end

% Sort by radius in decreasing order to find max_pts corner points
[radius, radiusIX] = sort(radius, 'descend');
y    = y(radiusIX(1 : max_pts));
x    = x(radiusIX(1 : max_pts));
rmax = radius(1 : max_pts);
end