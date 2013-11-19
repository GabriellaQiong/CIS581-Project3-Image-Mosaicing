% Run Script of CIS 581 Project 3 Image Mosaicing
% Written by Qiong Wang at University of Pennsylvania
% Nov.16th, 2013

% Clear up
clc;
close all;

% Parameters
testFlag = false;        % Whether to use test image data
randFlag = false;        % Whether images in random order
verbose  = true;         % Whether show stitching details

% Path
p         = mfilename('fullpath');
scriptDir = fileparts(p);
inputDir  = fullfile(scriptDir, '/images');
inputFile = fullfile(inputDir, 'images.mat');
if testFlag
    inputDir  = fullfile(inputDir, '/test');
    inputFile = fullfile(inputDir, 'images_test.mat');
end
outputDir = fullfile(scriptDir, '/results');

% Load Images
if ~exist(inputFile, 'file')
    cd(inputDir);
    imgInfo = dir();
    imgInfo([imgInfo.isdir]) = []; 
    imgNum  = numel(imgInfo);
    images  = cell(imgNum, 1);
    for i = 1 : imgNum
        images{i} = imread(imgInfo(i).name);
        images{i} = imresize(images{i}, 1/7);
%         images{i} = imrotate(images{i}, -90);
        images{i} = flipdim(images{i}, 2);
        images{i} = flipdim(images{i}, 1);
    end
    cd(scriptDir);
    save(inputFile, 'images');
else
    load(inputFile);
end

% Mosaicing
imgMosaic = mymosaic(images, randFlag, verbose);
h = figure(3);
imshow(imgMosaic); axis image off;
title('Final Result of Mosaic');
fig_save(h, fullfile(outputDir,'Mosaic'), 'png');