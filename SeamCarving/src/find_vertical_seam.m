function verticalSeam = find_vertical_seam(cumulativeEnergyMap)
% Initialize seam
[n,m] = size(cumulativeEnergyMap);
verticalSeam = zeros(n,1);

% Find min index of last row for traceback
[~,y] = min(cumulativeEnergyMap(end,:));
verticalSeam(n) = y;

% Track column indices during traceback
for i = n-1 : -1 : 1
        [~,y2] = min([borderV(cumulativeEnergyMap, i, y-1, m), borderV(cumulativeEnergyMap, i, y, m), borderV(cumulativeEnergyMap, i, y+1, m)]);
        y = y + y2 - 2;
        verticalSeam(i) = y;
end
end