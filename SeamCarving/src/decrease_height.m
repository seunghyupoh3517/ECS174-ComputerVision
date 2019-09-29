function [reducedColorImg,reducedEnergyImg] = decrease_height(im,energyImg)
m = size(energyImg, 2);
cem = cumulative_min_energy_map(energyImg, "HORIZONTAL");
hs = find_horizontal_seam(cem);

% Move the contents of im and energyImg up one space vertically to fill in seam
% Append a placeholder number (0) to get chopped off the image later
for j = 1 : m
    energyImg(hs(j):end,j) = vertcat(energyImg(hs(j)+1:end,j), 0);
    im(hs(j):end,j, :) = vertcat(im(hs(j)+1:end,j, :), zeros(1,1,3));
end

% Crop placeholder row off of the bottom side of the image
reducedEnergyImg = energyImg(1:end-1,:);
reducedColorImg = im(1:end-1, :, :);
end