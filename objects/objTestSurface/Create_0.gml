CreateHeightmap();

vertexHeightGrid[# 0, 0] = 2;
ds_grid_add_region(vertexHeightGrid, cellCountX-1, 0, cellCountX, cellCountY, 1);

shape = new BonkStructHeightmap(funcGetHeight, 100, 100, 0, cellCountX, cellCountY, xScale, yScale, zScale);

testX = 130;
testY = 130;
testZ = 100;

vbuffVolume = BuildHeightmapVolume(vertexHeightGrid, xScale, yScale, zScale);