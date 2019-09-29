function seam_carving_decrease_width()
im = imread('inputSeamCarvingPrague.jpg');
eim = energy_img(im);

[a,b] = decrease_width(im, eim);
for i = 1:99
    [a,b] = decrease_width(a, b);
end

p1 = imshow(a);
title("Reduced Width (100px)");
saveas(p1, "outputReduceWidthPrague.png");



im = imread('inputSeamCarvingMall.jpg');
eim = energy_img(im);

[a,b] = decrease_width(im, eim);
for i = 1:99
    [a,b] = decrease_width(a, b);
end

p2 = imshow(a);
title("Reduced Width (100px)");
saveas(p2, "outputReduceWidthMall.png");

end
