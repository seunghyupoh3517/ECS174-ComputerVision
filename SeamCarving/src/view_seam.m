function view_seam(im,seam,seamDirection)
imshow(im);
hold on;
if seamDirection == "VERTICAL"
    t = "Optimal Vertical Seam";
    plot(seam, 1:size(im, 1), "red");
else
    t = "Optimal Horizontal Seam";
    plot(1:size(im, 2), seam, "red");
end
title(t);
hold off;
end