function [t1, t2] = correspondences(im1, im2, N)
if N < 4
    fprintf("Using 4 points instead\n");
    N = 4;
end

im1 = imread(im1);
im2 = imread(im2);

imshow(im1);
[X1,Y1] = ginput(N);
t1 = [X1,Y1]';
imshow(im2);
[X2,Y2] = ginput(N);
t2 = [X2,Y2]';

end
