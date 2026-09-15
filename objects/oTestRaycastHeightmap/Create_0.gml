// Feather disable all

CreateHeightmap();
shape = new BonkStructHeightmap(funcGridZ, 100, 100, 0, gridWidth-1, gridHeight-1, xScale, yScale, zScale);

line = new BonkLine(0.5*gridWidth*xScale, 0.5*gridHeight*yScale, 200, 60, 70, 0);

alarm[0] = 30;
manual = false;