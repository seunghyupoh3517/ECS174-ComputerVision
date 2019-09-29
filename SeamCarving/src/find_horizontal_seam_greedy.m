function horizontalSeam = find_horizontal_seam_greedy(energyImg)
% Initialize seam
[numRows,numCols] = size(energyImg);
horizontalSeam = zeros(1,numCols);

% Find min index of first column for tracing forwards
[~,y] = min(energyImg(:,1));
horizontalSeam(1) = y;

% Track column indices during trace forward
for j = 2 : 1 : numCols
        [~,y2] = min([borderH(energyImg, y-1, j, numRows), borderH(energyImg, y, j, numRows), borderH(energyImg, y+1, j, numRows)]);
        y = y + y2 - 2;
        horizontalSeam(j) = y;
end
end