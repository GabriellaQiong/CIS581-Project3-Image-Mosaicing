% outImgBuff = cylindrical(inImgBuff,f)
% input
%   inImgBuff - the input image buffer to be reprojected to cylindrical
%   coordinates
%   f - the focal length
% output
%   outImgBuff - the cylindrical image buffer

function outImgBuff = cylindrical(inImgBuff, f)

% initialize the output image buffer
[nRows, nCols, nChnls] = size(inImgBuff);
outImgBuff = zeros(nRows,nCols,nChnls);

% set R and Z
R = f;
Z = f;

% construct the transformation matrices between [x,y] coordinates and [r,c]
% indices. [r, c] are row and column numbers starting from 1. [x, y]
% originates from the center point of the image. x increases along the
% right direction and y increases along the up direction.
rc2xy = [0,-1;1,0;-round(nCols/2),round(nRows/2)];
xy2rc = [0,1;-1,0;round(nRows/2),round(nCols/2)];

% inverse warping
% Find/Generate the depth values for each pixel in the output image by
% looking up the corresponding scene point in the input image.
for r = 1:nRows
    for c = 1:nCols
        % the cylinder coordinates
        xy_cyl = [r,c,1]*rc2xy;

        % the cylinder coordinates in theta and h
        theta = xy_cyl(1)/R;
        h = xy_cyl(2);

        % the unwarped imgage plane coordinates
        x = tan(theta)*Z;
        y = h/R*sqrt(x^2+Z^2);

        % the positions of the unwarped coordinates
        % note: these two position indices are doubles
        rc_in = [x,y,1]*xy2rc;
        
        % inverse warping using biliniar interperation
        [depths, flag] = interpolateDepths(inImgBuff, rc_in(1), rc_in(2));
        outImgBuff(r,c,:) = [depths, flag];
    end
end

% reformat the image buffer
outImgBuff = uint8(outImgBuff);
end

