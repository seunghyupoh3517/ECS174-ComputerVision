load kMeans.mat;
framesdir = './frames/';
siftdir = './sift/';
addpath('./provided_code/');
fnames = dir([siftdir '/*.mat']);

%get the 3 pictures
file1name = "friends_0000000060.jpeg";
file2name = "friends_0000000187.jpeg";
file3name = "friends_0000003363.jpeg";

im1name = [framesdir '/friends_0000000060.jpeg']; 
im1 = imread(im1name);
im2name = [framesdir '/friends_0000000187.jpeg']; 
im2 = imread(im2name);
im3name = [framesdir '/friends_0000003363.jpeg']; 
im3 = imread(im3name);

images = [im1; im2; im3];
fileNames = [file1name; file2name; file3name];

%Idea: attach descriptors from 3 chosen frames to kMeans clusters, count
%how many of each cluster appear in each frame, use histogram, then 
for i = 1:3
  % load that file
    fname = [siftdir+"/"+fileNames(i)+".mat"];
    load(fname, 'imname', 'descriptors');

    %get image
    imname = [framesdir '/' imname]; 
    im = imread(imname);

    
    
    distances = distSqr(descriptors', kMeans'); %gets distances from descriptors to clusters
    
    [~, clusterAssignments] = min(distances,[], 2);  % asssign each descriptor to a cluster/word
    
    %compute histogram
    [bincounts, ~] = histc(clusterAssignments, 1:size(kMeans(:, 1)));
    
    %compare histogram to histogram of every other frame.
    compBinCounts = zeros(length(fnames), 1500);
    
    for j=1:length(fnames) 
        % load that file
        comparename = [siftdir '/' fnames(j).name];
        compareDescs = load(comparename, 'descriptors');
        compareDescs = compareDescs.('descriptors');
        
        %compute histogram
        distances = distSqr(compareDescs', kMeans'); %gets distances from descriptors to clusters
        [~, compareAssignments] = min(distances,[], 2);
        [compBinCounts(j, :), ~] = histc(compareAssignments, 1:size(kMeans(:, 1)));
        
        %find normalized scalar products of histogram
        normScalarProducts(j) = corr(bincounts, compBinCounts(j, :)', 'Type', 'Pearson');
    
    end
    
    %find closest images
    normScalarProducts(isnan(normScalarProducts)) = 0;  % set NaN's to 0's
    [bestscores, bestindices] = maxk(normScalarProducts, 5);  % get 5 best scores / indices
    
    %display query image
    figure;
    hold on;
    subplot(2,3,1);
    imshow(im);
    title("Query Image");
    
    %display closest images
    for p = 2:6
        index = bestindices(p-1);
        fnameclose = [siftdir '/' fnames(index).name];
        closestName = load(fnameclose, 'imname');
        closestName = closestName.('imname');
        closestName = [framesdir '/' closestName];
        closestImage = imread(closestName);
        subplot(2,3,p);
        imshow(closestImage);
        title("Closest Image # " + int2str(p-1));
        
        
    end
    

end