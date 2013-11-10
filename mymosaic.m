function img_mosaic = mymosaic(img_input, randOrder, verbose)
% MOSIACING stitches two images into one

% INPUT
% img_input  = cell array of color images (HxWx3 uint8 values in [0,255])
% randOrder  = flag whether original images in random order

% OUTPUT
% img_mosaic =output mosaic HxWx3 array of uint8 values in the range [0,255]

% Written by Qiong Wang at University of Pennsylvania
% Nov. 10th, 2013

% Handle inputs
if nargin < 2
    randOrder = false;
end
if nargin < 3
    verbose = false;
end

% Initialize
imgNum       = numel(img_input);
centerImgIdx = ceil(imgNum / 2);

if verbose
    h = figure(1);
    p = mfilename('fullpath');
    funcDir = fileparts(p);
    outputDir = fullfile(funcDir, '/results');
end

% Resort the image order if they are in random order
if randOrder
    img_input = sort_images(img_input);
end

% Start stitching from the center
img_mosaic = img_input{centerImgIdx};

for i = 1 : imgNum
    if i <= centerImgIdx - 1
        img_mosaic = mosaicing(img_mosaic, img_input{centerImgIdx - i}, i); 
    elseif i > centerImgIdx
        img_mosaic = mosaicing(img_mosaic, img_input{i}, i);
    else
        continue;
    end
    if verbose
        clf;
        imagesc(img_mosaic); axis image off;
        title(sprintf('Mosaiced Image in iteration %d', i));
        fileString = fullfile(outputDir, ['matches', num2str(iter,'%02d')]);
        fig_save(h, fileString, 'png');
    end
end

end