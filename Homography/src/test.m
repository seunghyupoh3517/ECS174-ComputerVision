[t1,t2] = correspondences("crop1.jpg", "crop2.jpg", 3);
im1 = imread("crop1.jpg");
im2 = imread("crop2.jpg");
H = computeH(t1, t2);
warpImage(im1, im2, H);