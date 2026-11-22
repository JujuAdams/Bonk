DotobjSetTransformOnLoad(true);
DotobjSetReverseTriangles(true);
model = DotobjModelLoadFile("FoxyBar.obj");

BonkSetupMesh(matrix_build(x, y, 0,    0,0,45,   3,3,3), 10, 10, 10);
AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat());