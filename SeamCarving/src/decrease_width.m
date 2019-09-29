function [reducedColorImg,reducedEnergyImg] = decrease_width(im,energyImg)
n = size(energyImg, 1);
cem = cumulative_min_energy_map(energyImg, "VERTICAL");
vs = find_vertical_seam(cem);

% Move the contents of im and energyImg back one space horizontally to fill in seam
% Append a placeholder number (0) to get chopped off the image later
for i = 1 : n
    energyImg(i,vs(i):end) = [energyImg(i,vs(i)+1:end) 0];
    im(i,vs(i):end, :) = [im(i,vs(i)+1:end, :) zeros(1,1,3)];
end

% Crop placeholder column off of the right side of the image
reducedEnergyImg = energyImg(:,1:end-1);
reducedColorImg = im(:,1:end-1, :);
end