load kMeans.mat;
framesdir = './frames/';
siftdir = './sift/';
addpath('./provided_code/');
fnames = dir([siftdir '/*.mat']);

%get the 4 pictures
file1name = "friends_0000000109.jpeg";
file2name = "friends_0000000187.jpeg";
file3name = "friends_0000003363.jpeg";
file4name = "friends_0000003363.jpeg";


im1name = [framesdir '/friends_0000000109.jpeg']; 
im1 = imread(im1name);
im2name = [framesdir '/friends_0000000187.jpeg']; 
im2 = imread(im2name);
im3name = [framesdir '/friends_0000003363.jpeg']; 
im3 = imread(im3name);
im4name = [framesdir '/friends_0000003363.jpeg']; 
im4 = imread(im4name);

N = 1; %number of frames


images = [im3];
fileNames = [file3name];

n = zeros(1, 1500);

% calculate n_i
 for j=1:length(fnames) 
    % load that file
    comparename = [siftdir '/' fnames(j).name];
    compareDescs = load(comparename, 'descriptors');
    compareDescs = compareDescs.('descriptors');

    %compute histogram
    distances = distSqr(compareDescs', kMeans'); %gets distances from descriptors to clusters
    [~, compareAssignments] = min(distances,[], 2);
    [bin, ~] = histc(compareAssignments, 1:size(kMeans(:, 1)));
    
    %compute n_i
    add = cast(bin' > 0, 'double'); % does i appear in bin?
    for i = 1:length(n)
        n(i) = n(i) + add(i);
    end
    
 end

% stop list
p = .95;
threshold = quantile(n, p);
n(n > threshold) = 0;
 
%Idea: attach descriptors in user-specified regions from 4 chosen frames to kMeans clusters, count
%how many of each cluster appear in each frame
for i = 1:N
  % load that file
    fname = [siftdir+"/"+fileNames(i)+".mat"];
    load(fname, 'imname', 'descriptors', 'positions');

    %get image
    imname = [framesdir '/' imname]; 
    im = imread(imname);
    
    %get descriptors from a user selected region
    figure;
    onInds = selectRegion(im, positions);
    [onIndsRows, onIndsCols] = size(onInds(:, 1));
    relevantDescriptors = zeros(onIndsRows, 128);
    for h = 1:onIndsRows
        relevantDescriptors(h, :) = descriptors(onInds(h), :);
    end

   
    distances = distSqr(relevantDescriptors', kMeans'); %gets distances from descriptors to clusters
    
    [~, clusterAssignments] = min(distances,[], 2);  % asssign each descriptor to a cluster/word
    
    %compute histogram
    [bincounts, ~] = histc(clusterAssignments, 1:size(kMeans(:, 1)));
    
    %td idf
    for k = 1:length(bincounts)
        bincounts(k) = bincounts(k) / sum(bincounts > 0) * log(N/n(k)); 
    end
    
    %compare histogram to histogram of every other frame.
    compBinCounts = zeros(length(fnames), 1500);
    
    for j=1:length(fnames) 
        normScalarProducts = zeros(1, length(fnames));
        
        % load that file
        comparename = [siftdir '/' fnames(j).name];
        compareDescs = load(comparename, 'descriptors');
        compareDescs = compareDescs.('descriptors');
        
        %compute histogram
        distances = distSqr(compareDescs', kMeans'); %gets distances from descriptors to clusters
        [~, compareAssignments] = min(distances,[], 2);
        [compBinCounts(j, :), ~] = histc(compareAssignments, 1:size(kMeans(:, 1)));
        
        %td idf
        bin = compBinCounts(j,:);
        for k = 1:length(bin)
            bin(k) = bin(k) / sum(bin > 0) * log(N/n(k)); 
        end
    
        %find normalized scalar products of histogram
        normScalarProducts(j) = corr(bincounts, bin', 'Type', 'Pearson');
    
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
    hold off;
    

end