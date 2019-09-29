hallway = imread("tile.jpg");
[numRows, numCols, ~] = size(hallway);

imshow(hallway);
t1 = ginput(4);
t2 = double([1, 1; 1, numRows; numCols, 1; numCols, numRows]);

H = computeH(t1, t2);
[frontoparallelIm, mergefrontoparallelIm] = warpImage(hallway, hallway, H);