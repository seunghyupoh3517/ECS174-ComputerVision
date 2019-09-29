function cumulativeEnergyMap = cumulative_min_energy_map(energyImg, seamDirection)
[n,m] = size(energyImg);
M = zeros(n,m);
if seamDirection == "HORIZONTAL"
   % Initialize map
    M(:,1) = energyImg(:,1);

    for j = 2 : m
        for i = 1 : n
            M(i,j) = energyImg(i,j) + min([borderH(M, i-1, j-1, n), borderH(M, i, j-1, n), borderH(M, i+1, j-1, n)]);
        end
    end

else
    % Initialize map
    M(1,:) = energyImg(1,:);

    for i = 2 : n
        for j = 1 : m
            M(i,j) = energyImg(i,j) + min([borderV(M, i-1, j-1, m), borderV(M, i-1, j, m), borderV(M, i-1, j+1, m)]);
        end
    end

end

cumulativeEnergyMap = M;
end

