function mosaicedIm = mosaicing(im1, im2, iter)
% MOSIACING stitches two images into one

% INPUT
% im1, im2   = input rgb images, im2 is the source and im1 is the destination
% iter       = iteration number for multiple image stitching

% OUTPUT
% mosaicedIm = stitched color image between original two color images

% Written by Qiong Wang at University of Pennsylvania
% Nov. 10th, 2013

if nargin < 3
   iter = []; 
end

% Parameters
max_pts       = 200;
threshRANSAC  = 6;
blendFrac     = 0.3;
geometricBlur = false;
verbose       = true;

% Parsing images
I1  = rgb2gray(im1);
I2  = rgb2gray(im2);

% Corner detection
cimg1 = cornermetric(I1);
cimg2 = cornermetric(I2);

% Adaptive non-maximum supression
[y1, x1, ~] = anms(cimg1, max_pts);
[y2, x2, ~] = anms(cimg2, max_pts);

% Feature descriptors
p1 = feat_desc(I1, y1, x1, geometricBlur);
p2 = feat_desc(I2, y2, x2, geometricBlur);

% Feature matching
m  = feat_match(p1,p2);
Y1 = y1(m ~= -1);
X1 = x1(m ~= -1);
Y2 = y2(m(m ~= -1));
X2 = x2(m(m ~= -1));

% Estimate homography by RANSAC
[H, ~] = ransac_est_homography(Y1, X1, Y2, X2, threshRANSAC, iter, verbose);

% Handle the bounds for transformed source image
[yDes, xDes]       = size(I1);
[ySrc, xSrc]       = size(I2);
[xBound, yBound]   = apply_homography(H, [1; 1; xSrc; xSrc], [1: ySrc; 1; ySrc]);
minBound           = round(min([xBound, yBound], [], 1));
maxBound           = round(max([xBound, yBound], [], 1));
[xMatrix, yMatrix] = meshgrid(minBound(1) : maxBound(1), minBound(2) : maxBound(2));
xArray             = reshape(xMatrix, [numel(xMatrix), 1]);
yArray             = reshape(yMatrix, [numel(yMatrix), 1]);
[xSrcArr, ySrcArr] = apply_homography(inv(H), xArray, yArray);
xSrcArr            = round(xSrcArr);
ySrcArr            = round(ySrcArr);

% Handle bounds for stitched image
minMosaic   = min([minBound, [1 1]'], [], 2);
maxMosaic   = min([maxBound, [xDes, yDes]'], [], 2);
rangeMosaic = maxMosaic - minMosaic + 1;
mosaicedIm  = zeros(rangeMosaic(2), rangeMosaic(1), 3);
minDes      = 1 - (minMosaic ~= 1) .* minMosaic;
mosaicedIm(minDes(2) : (minDes(2) + yDes - 1), minDes(1) : (minDes(1) + xDes - 1), :) = im1;

% Remove non-effective pixels
effectIdx = xSrcArr >= 1 & xSrcArr <= xSrc & ySrcArr >= 1 & ySrcArr <= ySrc;
xArray    = xArray(effectIdx);
yArray    = yArray(effectIdx);
xSrcArr   = xSrcArr(effectIdx);
ySrcArr   = ySrcArr(effectIdx);

% Stitiching the source image with blending
for i = 1 : length(xArray)
    if all(mosaicedIm(yArray(i), xArray(i), :) == 0)
        mosaicedIm(yArray(i) + minDes(2) - 1, xArray(i) + minDes(1) - 1, :) = im2(ySrcArr(i), xSrcArr(i), :);
    else
        mosaicedIm(yArray(i) + minDes(2) - 1, xArray(i) + minDes(1) - 1, :) = blendFrac * mosaicedIm(yArray(i), xArray(i), :) ...
                                              + (1 - blendFrac) * im2(ySrcArr(i), xSrcArr(i), :);
    end
end
mosaicedIm = im2uint8(mosaicedIm);

end