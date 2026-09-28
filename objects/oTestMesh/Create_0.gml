DotobjSetTransformOnLoad(true);
DotobjSetReverseTriangles(true);
model = DotobjModelLoadFile("cube.obj");

matrix = matrix_build(x, y, 0,    30, 30, 30,   100, 100, 100);

shape = new BonkStructMesh(30, 30, 30).AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat(), matrix);