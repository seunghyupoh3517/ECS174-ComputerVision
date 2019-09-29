function val = borderV(M, i, j, m)
% Function to handle borders
if j >= 1 && j <= m
    val = M(i,j);
else
    val = realmax("double");
end
end