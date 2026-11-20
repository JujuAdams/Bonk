DotobjSetTransformOnLoad(true);
DotobjSetReverseTriangles(true);
model = DotobjModelLoadFile("cube.obj");

matrix = matrix_build(x, y, 0,    30, 30, 30,   100, 100, 100);

BonkSetupMesh(30, 30, 30);
AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat(), matrix);