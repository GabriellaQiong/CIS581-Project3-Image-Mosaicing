CIS581-Project3-Image-Mosaicing
===============================

Course Project for CIS 581 Computer Vision and Photography at University of Pennsylvania


In [script_mosaicing.m](https://github.com/GabriellaQiong/CIS581-Project3-Image-Mosaicing/blob/master/script_mosaicing.m) , you can modify these parameters when implementing the codes

```
testFlag = false;        % Whether to use test image data
randFlag = false;        % Whether images in random order
verbose  = true;         % Whether show stitching details
```

For mosaicing details, you can edit these parameters in [mosaicing.m](https://github.com/GabriellaQiong/CIS581-Project3-Image-Mosaicing/blob/master/mosaicing.m) for adaptive non-maximum supression, RANSAC, blending, blur kernel and detail display.
```
% Parameters
max_pts       = 400;
threshRANSAC  = 5;
blendFrac     = 0.5;
geometricBlur = false;
verbose       = true;
```
Here the test images source is a rotated April Tag board, and source images are 10 images taken in GRASP lab. You can use from the folder [images](https://github.com/GabriellaQiong/CIS581-Project3-Image-Mosaicing/tree/master/images) directly.

In this project, I finished all the basic features along with alpha blending and geometry blurring.


**What to do next?**

* Pyrimid Blending
* Random Order Determination
* Wrong Source Image Determination
* Cylindrical Projection.

I might finish these features in the winnter vacation, hopefully : )
