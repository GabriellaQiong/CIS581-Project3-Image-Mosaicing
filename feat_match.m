function m = feat_match(p1,p2)
% FEAT_MATCH matches feature descriptors

% INPUT
% p1, p2 = 64xn1 matrix of double values same as feat_desc's p

% OUTPUT
% m = n1x1 integer vector where m(i) points to the index of the descriptor in p2 that 
% matches with the descriptor p1(:,i). m(i) = -1 means no match.

% Written by Qiong Wang at University of Pennsylvania
% Nov. 9th, 2013

% Initialize
n1     = size(p1, 2);
m      = -ones(n1, 1);
thresh = 0.5;

for i = 1 : n1
    % Compute SSD between all pairs of descriptors
    SSD = sum(bsxfun(@minus, p1(:, i), p2).^2, 1);
    % Find the 2 nearest neighbors
    [SSD, idx] = sort(SSD, 2);
    ratio = SSD(1)/ SSD(2);
    % Determine whether it is a good match
    if ratio < thresh
        m(i) = idx(1);
    end
end

end