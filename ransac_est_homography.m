function [H, inlier_ind] = ransac_est_homography(y1, x1, y2, x2, thresh, iter, im1, im2, verbose)
% RANSAC_EST_HOMOGRAPHY estimates the homography between two corresponding
% feature points through RANSAC. im2 is the source and im1 is the destination.

% INPUT
% y1,x1,y2,x2 = corresponding point coordinate vectors Nx1
% thresh      = threshold on distance to see if transformed points agree
% iter        = iteration number for multiple image stitching
% im1, im2    = images

% OUTPUT
% H           = the 3x3 matrix computed in final step of RANSAC
% inlier_ind  = nx1 vector with indices of points that were inliers

% Written by Qiong Wang at University of Pennsylvania
% Nov. 9th, 2013

if nargin < 9
   verbose = false; 
end

% Initialize
N        = size(y1, 1);
roundNum = 1000;
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
    ok{t} = ((x1 - x1Est).^2 + (y1 - y1Est).^2) <= thresh^2;
    score(t) = sum(ok{t}) ;
end

% Find the best score
[~, best]  = max(score);
ok         = ok{best};
inlier_ind = find(ok)';
H          = est_homography(x1(ok),y1(ok),x2(ok),y2(ok));

% Plot the verbose details
if ~verbose
    return
end

dh1 = max(size(im2,1)-size(im1,1),0);
dh2 = max(size(im1,1)-size(im2,1),0);

h = figure(1); 

% Original Matches
subplot(2,1,1);
imshow([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]);
delta = size(im1,2);
line([x1'; x2' + delta], [y1'; y2']);
title(sprintf('%d Original matches', N));
axis image off;

% Inlier Matches
subplot(2,1,2);
imshow([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]);
delta = size(im1,2);
line([x1(inlier_ind)'; x2(inlier_ind)' + delta], [y1(inlier_ind)'; y2(inlier_ind)']);
title(sprintf('%d (%.2f%%) inliner matches out of %d', sum(ok), 100*sum(ok)/N, N));
axis image off;
drawnow;

% Save the figures
p = mfilename('fullpath');
funcDir = fileparts(p);
outputDir = fullfile(funcDir, '/results');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end
fileString = fullfile(outputDir, ['matches', num2str(iter,'%02d')]);
fig_save(h, fileString, 'png');
end