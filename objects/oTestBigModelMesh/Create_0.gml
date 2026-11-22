DotobjSetTransformOnLoad(true);
DotobjSetReverseTriangles(true);
model = DotobjModelLoadFile("FoxyBar.obj");

meshData = new BonkMeshData(10, 10, 10);
meshData.AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat());

shape = new BonkStructMesh(matrix_build(x, y, 0,    0,0,45,   3,3,3), meshData);