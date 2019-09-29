addpath('./provided_code/');
load twoFrameData.mat;
%allow user to select region
onInds = selectRegion(im1, positions1);

%Match those descriptors to descriptors in im2 using Euclidean Distance
[onIndsRows, onIndsCols] = size(onInds(:, 1));
relevantDescriptors = zeros(onIndsRows, 128);
for i = 1:size(onInds(:,1))
    relevantDescriptors(i, :) = descriptors1(onInds(i), :);
end

%compute distances from relevant descriptors to all descriptors in 2nd
%image
distances = dist2(relevantDescriptors, descriptors2);
%find min distance of each relevant descriptor
[minDists,minPositions] = min(distances, [], 2);

%want to threshold to only show n closest descriptors
[sortedDists, transform] = sort(minDists);
sortedPositions = minPositions(transform);
n = 30; %NOTE: Change this number to raise/lower the threshold
if length(sortedPositions(:, 1)) >= n
    thresholdedPositions = sortedPositions(1:n, :);
else
    thresholdedPositions = sortedPositions;
end

%display results
%need to get the matched positions, scales, and orients
matchedPositions = positions2(thresholdedPositions, :);
matchedScales = scales2(thresholdedPositions, :);
matchedOrients = orients2(thresholdedPositions, :);

figure;
imshow(im2);
displaySIFTPatches(matchedPositions, matchedScales, matchedOrients, im2);
