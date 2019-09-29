inputIm = imread("catsmall.jpg");
refIm = imread("billboardsmall.jpg");
[numRows, numCols, ~] = size(inputIm);
t1 = double([1, 1; 1, numRows; numCols, 1; numCols, numRows]);
imshow(refIm);
t2 = ginput(4);
H = computeH(t1, t2);
[warpIm, mergeIm] = warpImage(inputIm, refIm, H);
imshow(uint8(warpIm));