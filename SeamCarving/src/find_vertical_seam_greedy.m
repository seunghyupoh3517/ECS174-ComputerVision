function verticalSeam = find_vertical_seam_greedy(energyImg)
    %finding horizontal seam of energyImg' is the same as finding vertical
    %seam of energyImg.
    verticalSeam = find_horizontal_seam_greedy(energyImg');