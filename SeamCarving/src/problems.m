%% 3
im = imread("inputSeamCarvingPrague.jpg");
eim = energy_img(im);

c1 = cumulative_min_energy_map(eim, "HORIZONTAL");
c2 = cumulative_min_energy_map(eim, "VERTICAL");

figure;
p1 = imagesc(eim);
colormap gray;
colorbar;
title("Energy");
saveas(p1, "outputEnergyPrague.png");

figure;
pc1 = imagesc(c1);
colormap default;
colorbar;
title("Horizontal Min Cumulative Energy");
saveas(pc1, "outputHEnergyPrague.png");

figure;
pc2 = imagesc(c2);
colorbar;
title("Vertical Min Cumulative Energy");
saveas(pc2, "outputVEnergyPrague.png");

%% 4
pc3 = imshow(im);
hold on;

hs = find_horizontal_seam(c1);
vs = find_vertical_seam(c2);

plot(vs, 1:size(im, 1), "red");
plot(1:size(im, 2), hs, "green");

title("Optimal Vertical and Horizontal Seams");
hold off;
saveas(pc3, "outputOptimalSeams.png");

%% 5
pc4 = imshow(im);
hold on;

gim = cast(rgb2gray(im), "double");

x_filter = fspecial('prewitt');
y_filter = x_filter';

dx = imfilter(gim, x_filter);
dy = imfilter(gim, y_filter);

eim = sqrt(dx.^2+dy.^2);

c1 = cumulative_min_energy_map(eim, "HORIZONTAL");
c2 = cumulative_min_energy_map(eim, "VERTICAL");

hs2 = find_horizontal_seam(c1);
vs2 = find_vertical_seam(c2);

plot(vs2, 1:size(im, 1), "red");
plot(1:size(im, 2), hs2, "green");

title("Optimal Vertical and Horizontal Seams (Prewitt)");
hold off;
saveas(pc4, "outputOptimalSeamsPrewitt.png");

%% 6

im = imread("skull.jpg");
eim = energy_img(im);
[a,b] = decrease_width(im, eim);
for i = 1:99
    [a,b] = decrease_width(a, b);
end

image1 = figure;
subplot(1,3,1);
imshow(im);
title("Original");
subplot(1,3,2);
imshow(a);
title("Carving");
subplot(1,3,3);
imshow(imresize(im, [size(a,1) size(a,2)]));
title("Resize");
saveas(image1, "image1.png")

%%
im = imread("torii.jpg");
eim = energy_img(im);
[a,b] = decrease_width(im, eim);
for i = 1:99
    [a,b] = decrease_width(a, b);
end
for i = 1:100
    [a,b] = decrease_height(a, b);
end

image2 = figure;
subplot(1,3,1);
imshow(im);
title("Original");
subplot(1,3,2);
imshow(a);
title("Carving");
subplot(1,3,3);
imshow(imresize(im, [size(a,1) size(a,2)]));
title("Resize");
saveas(image2, "image2.png")

%%
im = imread("ny.jpg");
eim = energy_img(im);
[a,b] = decrease_width(im, eim);
for i = 1:99
    [a,b] = decrease_width(a, b);
end
for i = 1:100
    [a,b] = decrease_height(a, b);
end

image3 = figure;
subplot(1,3,1);
imshow(im);
title("Original");
subplot(1,3,2);
imshow(a);
title("Carving");
subplot(1,3,3);
imshow(imresize(im, [size(a,1) size(a,2)]));
title("Resize");
saveas(image3, "image3.png")


