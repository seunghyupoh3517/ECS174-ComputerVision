function H = computeH(t1, t2)
t1 = t1';
t2 = t2';

% Preallocate space
A = zeros(2 * size(t1,1), 9);

for i = 1:size(t1,1)
    h = [t1(i,:) 1];
    rhs = -t2(i,:)' * h;
    lhs = vertcat([h zeros(1,3)], [zeros(1,3) h]);
    % Skip every other row
    A((i-1)*2 + 1:(i-1)*2 + 2,:) = [lhs rhs];
end

% Solve for H's
[V,D] = eig(A'*A);
[~,ind] = min(diag(D));
h9 = V(:,ind);

H = reshape(h9, [3, 3])';

end
