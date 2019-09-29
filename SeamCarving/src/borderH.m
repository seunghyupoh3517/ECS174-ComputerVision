function val = borderH(M, i, j, n)
% Function to handle borders
if i >= 1 && i <= n
    val = M(i,j);
else
    val = realmax("double");
end
end