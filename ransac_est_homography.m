function [H, inlier_ind] = ransac_est_homography(y1, x1, y2, x2, thresh)
% RANSAC_EST_HOMOGRAPHY estimates the homography between two corresponding
% feature points through RANSAC. im2 is the source and im1 is the destination.

% INPUT
% y1,x1,y2,x2 = corresponding point coordinate vectors Nx1
% thresh      = threshold on distance to see if transformed points agree

% OUTPUT
% H           = the 3x3 matrix computed in final step of RANSAC
% inlier_ind  = nx1 vector with indices of points that were inliers


% Written by Qiong Wang at University of Pennsylvania
% Nov. 9th, 2013

% Initialize
N        = size(y1, 1);
roundNum = 500;
score    = zeros(roundNum, 1);
ok       = cell(roundNum, 1);
H        = cell(roundNum, 1);

for t = 1 : roundNum
    % Randomly select groups of points 
    subsets = randperm(N, 4);
    
    % Estimate homography
    H{t} = est_homography(x1(subsets),y1(subsets),x2(subsets),y2(subsets));
    
    % Refine the transform estimate
    [x1Est, y1Est] = apply_homography(H{t}, x2, y2);
    ok{t} = ((x1 - x1Est).^2 + (y1 - y1Est).^2) > thresh^2;
    score(t) = sum(ok{t}) ;
end

% Find the best score
[~, best]  = max(score);
H          = H{best};
inlier_ind = find(ok{best})';
end