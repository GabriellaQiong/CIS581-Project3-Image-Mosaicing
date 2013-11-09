function p = feat_desc(im, y, x, geometricBlur)
% FEAT_DESC extracts feature descriptor

% INPUT
% im = double HxW array (grayscale image) with values in the range 0-255. 
% y  = nx1 vector representing the row coordinates of corners 
% x  = nx1 vector representing the column coordinates of corners 

% OUTPUT
% p  = 64xn matrix of double values with column i being the 64 dimensional 
%     descriptor (8x8 grid linearized) computed at location (xi,yi) in im

% Written by Qiong Wang at University of Pennsylvania
% Nov. 9th, 2013

% Initialize
if nargin < 4
    geometricBlur = false;
end
n  = size(y, 1);
p  = zeros(64, n);
im = padarray(im, [20, 20]); 

% Function handel to find image patch
patch_img = @(x, y) im(y - 20 : y + 19, x - 20 : x + 19); 

% Isotropic gaussian kernel
kernel = fspecial('gaussian');
for i = 1 : n
    p(: , i) = subsampling(patch_img(x(i) + 20, y(i) + 20), kernel, geometricBlur); 
end

end 

function pCol = subsampling(imPatch, filter, geometricBlur)
% SUBSAMPLING processed the pixels within the 40 by 40 window

imBlurred = imfilter(imPatch, filter, 'same');
if geometricBlur
    kernel    = fspecial('gaussian', [40, 40], 20);
    kernel    =  kernel./ max(kernel(:));
    imBlurred = imBlurred .* kernel;
end
pCol = reshape(imBlurred(1:5:40, 1:5:40), [64, 1]);

% Normalize 8x8 patch to mean 0 and standard deviation of 1 pixel
pCol = pCol - mean(pCol);
pCol = pCol ./ std(pCol, 1);
end