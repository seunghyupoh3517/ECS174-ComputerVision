function horizontalSeam = find_horizontal_seam(cumulativeEnergyMap)
% Initialize seam
[n,m] = size(cumulativeEnergyMap);
horizontalSeam = zeros(1,m);

% Find min index of last column for traceback
[~,y] = min(cumulativeEnergyMap(:,end));
horizontalSeam(m) = y;

% Track column indices during traceback
for j = m-1 : -1 : 1
        [~,y2] = min([borderH(cumulativeEnergyMap, y-1, j, n), borderH(cumulativeEnergyMap, y, j, n), borderH(cumulativeEnergyMap, y+1, j, n)]);
        y = y + y2 - 2;
        horizontalSeam(j) = y;
end
end