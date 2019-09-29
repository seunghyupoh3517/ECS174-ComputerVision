load kMeans.mat;
framesdir = './frames/';
siftdir = './sift/';
addpath('./provided_code/');
fnames = dir([siftdir '/*.mat']);

%get the 3 pictures
file1name = "friends_0000004503.jpeg";
file2name = "friends_0000000394.jpeg";

im1name = [framesdir '/friends_0000004503.jpeg']; 
im1 = imread(im1name);
im2name = [framesdir '/friends_0000000394.jpeg']; 
im2 = imread(im2name);

images = [im1; im2];
fileNames = [file1name; file2name];

%Idea: attach descriptors from 3 chosen frames to kMeans clusters, count
%how many of each cluster appear in each frame, use histogram, then 
for i = 1:2
  % load that file
    fname = [siftdir+"/"+fileNames(i)+".mat"];
    load(fname, 'imname', 'descriptors', 'deepFC7');

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
        compareDescs = load(comparename, 'descriptors', 'deepFC7');
        deepFC7match = compareDescs.('deepFC7');
        compareDescs = compareDescs.('descriptors');
        
        %compute histogram
        distances = distSqr(compareDescs', kMeans'); %gets distances from descriptors to clusters
        [~, compareAssignments] = min(distances,[], 2);
        [compBinCounts(j, :), ~] = histc(compareAssignments, 1:size(kMeans(:, 1)));
        
        %find normalized scalar products of histograms
        normScalarProducts(j) = corr(bincounts, compBinCounts(j, :)', 'Type', 'Pearson');
        FC7normScalarProducts(j) = corr(deepFC7', deepFC7match', 'Type', 'Pearson');
    
    end
    
    %find closest images
    normScalarProducts(isnan(normScalarProducts)) = 0;  % set NaN's to 0's
    FC7normScalarProducts(isnan(FC7normScalarProducts)) = 0;  % set NaN's to 0's
    [FC7bestscores, FC7bestindices] = maxk(FC7normScalarProducts, 10);
    [bestscores, bestindices] = maxk(normScalarProducts, 10);  % get 10 best scores / indices
    
    %display query image
    figure;
    hold on;
    subplot(3,4,1);
    imshow(im);
    title("Query Image");
    
    %display closest images with regular BOW
    for p = 2:11
        index = bestindices(p-1);
        fnameclose = [siftdir '/' fnames(index).name];
        closestName = load(fnameclose, 'imname');
        closestName = closestName.('imname');
        closestName = [framesdir '/' closestName];
        closestImage = imread(closestName);
        subplot(3,4,p);
        imshow(closestImage);
        title("Closest Image # " + int2str(p-1));
    end
    hold off;
    
    
   %display closest images with deepFC7
    figure;
    hold on;
    subplot(3,4,1);
    imshow(im);
    title("Query Image");
    
    for p = 2:11
        index = FC7bestindices(p-1);
        fnameclose = [siftdir '/' fnames(index).name];
        closestName = load(fnameclose, 'imname');
        closestName = closestName.('imname');
        closestName = [framesdir '/' closestName];
        closestImage = imread(closestName);
        subplot(3,4,p);
        imshow(closestImage);
        title("Closest Image # " + int2str(p-1));
    end
    hold off;
   
    
    

end