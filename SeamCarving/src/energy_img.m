function energyImg = energy_img(im)

gim = cast(rgb2gray(im), "double");

x_filter = [-1 1];
y_filter = [-1 1]';

dx = imfilter(gim, x_filter);
dy = imfilter(gim, y_filter);

energyImg = sqrt(dx.^2+dy.^2);
end