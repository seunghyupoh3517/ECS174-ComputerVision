function [warpIm, mergeIm] = warpImage(inputIm, refIm, H)
    %first need to get bounding box by doing a forward warp
   [n,m, ~] = size(inputIm);
   %[X,Y] = meshgrid(1:n, 1:m);
   A = zeros(n, m);
   B = zeros(n, m);
   for i=1:m
       for j=1:n
           ijw = H * [i j 1]';
           tuple = ijw(1:2) / ijw(3);  % divide by the w to get (x', y')
           A(i,j) = tuple(1);  % x' coordinates 
           B(i,j) = tuple(2);  % y' coordinates 
       end
   end
   
   
   %collect corners of bounding from A, B vectors and refIm dimensions
   topleft = [min(min(min(B)),1), min(min(min(A)), 1)];  % min of (x',y') values and the four corners of refIm?
   bottomright = [max(max(max(B)), n), max(max(max(A)), m)];
   topright = [min(min(min(B)), 1), max(max(max(A)), m)];
   bottomleft = [max(max(max(B)), n), min(min(min(A)), 1)]; 
   
   boundingbox = zeros(abs(floor(topleft(1) - bottomleft(1))), abs(floor(bottomright(2) - bottomleft(2))), 3);  % get size of bounding box / allocate space
   warpIm = zeros(abs(floor(topleft(1) - bottomleft(1))), abs(floor(bottomright(2) - bottomleft(2))), 3);

   miny = min(min(min(B)), 1);
   minx = min(min(min(A)), 1);
   
  
   % loop over pixels in bounding box
   [inputRows, inputCols, ~] = size(inputIm);
   
   [refRows, refCols, ~] = size(refIm);
   for i = 1:refRows
    for j = 1:refCols
        boundingbox(i+ceil(abs(miny)),j+ceil(abs(minx)),:) = refIm(i,j,:);
    end
   end
   
   for i = floor(topleft(2)):floor(topright(2))
       for j = floor(topleft(1)):floor(bottomleft(1))
           ijw = H \ [i; j; 1];  % use \ operator b/c faster than doing inv(H) and *
           tuple = ijw(1:2) / ijw(3);  % divide by the w to get back (x, y)
         
           if tuple(1) <= inputCols && tuple(1) >=1 && tuple(2) <= inputRows && tuple(2) >=1  % make sure it's in bounds
             %need to interpolate here
             a = tuple(1) - floor(tuple(1));  % x distance to nearest pixel on left
             b = tuple(2) - floor(tuple(2));  % y distance to nearest pixel on bottom
             
             for color=1:3 
                val = (1-a)*(1-b)*inputIm(floor(tuple(2)), floor(tuple(1)),color) + a*(1-b)*inputIm(floor(tuple(2)), floor(tuple(1)) + 1, color) + a*b*inputIm(floor(tuple(2)) + 1, floor(tuple(1)) + 1, color) + (1-a)*b *inputIm(floor(tuple(2)) + 1, floor(tuple(1)), color); 
                boundingbox(j + round(abs(miny)) + 1, i + round(abs(minx)) + 1,color) = val; % changed ceil to floor, not sure if safe
                warpIm(j + round(abs(miny)) + 1, i + round(abs(minx)) + 1,color) = val;
             end
           end
       end
   end
   warpIm = uint8(warpIm);
   mergeIm = uint8(boundingbox);
   
   
   imshow(mergeIm);

end



