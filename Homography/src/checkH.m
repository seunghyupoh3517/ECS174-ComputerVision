function checkH(im2, t1, H)
Ht1 = H * [t1' ones(size(t1,2), 1)]';
Ht1(1,:) = Ht1(1,:) ./ Ht1(3,:);
Ht1(2,:) = Ht1(2,:) ./ Ht1(3,:);
Ht1 = Ht1(1:2,:)';
imshow(im2);
hold on;
plot(Ht1(:,1), Ht1(:,2), "ro");
hold off;
end