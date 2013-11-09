function mosaicedIm = mosaicing(im1, im2)
% MOSIACING stitches two images into one

% INPUT
% im1, im2     = input rgb images

% OUTPUT
% mosaicedIm = stitched color image between original two color images

% Written by Qiong Wang at University of Pennsylvania
% Nov. 9th, 2013

% Parameters
max_pts       = 200;
geometricBlur = false;
threshRANSAC  = 6;

% Parsing images
I1 = rgb2gray(im1);
I2 = rgb2gray(im2);

% Corner detection
cimg1 = cornermetric(I1);
cimg2 = cornermetric(I2);

% Adaptive non-maximum supression
[y1, x1, rmax1] = anms(cimg1, max_pts);
[y2, x2, rmax2] = anms(cimg2, max_pts);

% Feature descriptors
p1 = feat_desc(I1, y1, x1, geometricBlur);
p2 = feat_desc(I2, y2, x2, geometricBlur);

% Feature matching
m = feat_match(p1,p2);

% Estimate homography by RANSAC
[H, inlier_ind] = ransac_est_homography(y1, x1, y2, x2, threshRANSAC);

end 