CreateHeightmap();
shape = new BonkStructHeightmap(funcGridZ, 0, 0, 0, gridWidth-1, gridHeight-1, xScale, yScale, zScale);
vbuffVolume = BuildHeightmapVolume(grid, xScale, yScale, zScale);