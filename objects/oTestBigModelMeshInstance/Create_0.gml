DotobjSetTransformOnLoad(true);
DotobjSetReverseTriangles(true);
model = DotobjModelLoadFile("FoxyBar.obj");

matrix = matrix_build(x, y, 0,    0,0,0,   3,3,3);

BonkSetupMesh(30, 30, 30);
SetMatrix(matrix);
AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat());