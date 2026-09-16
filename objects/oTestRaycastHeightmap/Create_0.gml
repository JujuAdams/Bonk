// Feather disable all

CreateHeightmap();
shape = new BonkStructHeightmap(funcGetHeight, 100, 100, 0, cellCountX, cellCountY, xScale, yScale, zScale);

line = new BonkLine(0.5*cellCountX*xScale, 0.5*cellCountY*yScale, 200, 60, 70, 0);
raycast = new BonkRay(0, 0, 0,   0, 0, 0);

alarm[0] = 30;
manual = false;