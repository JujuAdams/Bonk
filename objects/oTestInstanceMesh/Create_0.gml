DotobjSetTransformOnLoad(true);
DotobjSetReverseTriangles(true);
model = DotobjModelLoadFile("cube.obj");

matrix = matrix_build(0,0,0,    30, 30, 30,   100, 100, 100);

BonkSetupMesh(x, y, 0,   30, 30, 30);
SetMatrix(matrix);
AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat());