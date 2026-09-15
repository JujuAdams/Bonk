CreateHeightmap();
shape = new BonkStructHeightmap(funcGetHeight, 0, 0, 0, cellCountX, cellCountY, xScale, yScale, zScale);
vbuffVolume = BuildHeightmapVolume(vertexHeightGrid, xScale, yScale, zScale);