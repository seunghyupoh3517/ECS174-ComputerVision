function seam_carving_decrease_height_greedy()
    im = imread('inputSeamCarvingPrague.jpg');
    eim = energy_img(im);

    [a,b] = decrease_height_greedy(im, eim);
    for i = 1:49
        [a,b] = decrease_height_greedy(a, b);
    end

    p1 = imshow(a);
    title("Reduced Height (50px)");
    saveas(p1, "outputReduceHeightPragueGreedy.png");



    im = imread('inputSeamCarvingMall.jpg');
    eim = energy_img(im);

    [a,b] = decrease_height_greedy(im, eim);
    for i = 1:49
        [a,b] = decrease_height_greedy(a, b);
    end

    p2 = imshow(a);
    title("Reduced Height (50px)");
    saveas(p2, "outputReduceHeightMallGreedy.png");
    end