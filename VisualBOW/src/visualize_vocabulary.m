framesdir = './frames/';
siftdir = './sift/';
addpath('./provided_code/');

%Main Idea: Randomly choose descriptors from random frames and use KMeans
%to cluster them

%select random frames
N = 300; % specifies how many frames to randomly sample
fnames = dir([siftdir '/*.mat']);
randInd = randperm(length(fnames), N);  

count = 1;
for i =1:length(randInd)
     % load that file
    fname = [siftdir '/' fnames(randInd(i)).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    %randomly pull descriptors
    numDescriptors = size(descriptors(:, 1));

    randDescripts(count:count+numDescriptors(1)-1, :) = descriptors;
    randDescriptsFiles(count:count+numDescriptors(1)-1) = randInd(i); % keep track of which file our descriptors come from
    randDescriptsInd(count:count+numDescriptors(1)-1) = 1:numDescriptors; % keep track of which descriptor exactly it is
    count = count + numDescriptors;
    
end

%cluster them
K = 1500;
[membership, means, rms] = kmeansML(K, randDescripts');

%pick 2 random words
randWords = randperm(length(membership), 2);

%get 25 members of the two words
[target1DescriptorsIndex, target1FileInds] = getPatches(randWords, randDescriptsFiles, membership, randDescriptsInd, 1);
[target2DescriptorsIndex, target2FileInds] = getPatches(randWords, randDescriptsFiles, membership, randDescriptsInd, 2);

%Display the patches
showPatches(target1DescriptorsIndex, target1FileInds, fnames);
showPatches(target2DescriptorsIndex, target2FileInds, fnames);



function [targetDescriptorsIndex, targetFileInds] = getPatches(randWords, randDescriptsFiles, membership, randDescriptsInd, randInd)
    %get 25 members of a word
    membershipInds = find(membership == membership(randWords(randInd)));
    membershipInds = membershipInds(1:25);
    targetDescriptorsIndex = randDescriptsInd(membershipInds);
    targetFileInds = randDescriptsFiles(membershipInds);

end

function showPatches(targetDescriptorsIndex, targetFileInds, fnames)
    framesdir = './frames/';
    siftdir = './sift/';
    figure;
    hold on;
    for i = 1:25
        file = [siftdir '/' fnames(targetFileInds(i)).name];
        load(file, 'imname', 'positions', 'scales', 'orients');  % need to know which number descriptor in the file it is
        imname = [framesdir '/' imname]; % add the full path
        im = imread(imname);
        %make image grayscale
        im = rgb2gray(im);
        subplot(5,5, i);
        imshow(getPatchFromSIFTParameters(positions(targetDescriptorsIndex(i), :), scales(targetDescriptorsIndex(i)), orients(targetDescriptorsIndex(i)), im));
    end
    hold off;
end

