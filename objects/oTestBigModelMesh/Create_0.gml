DotobjSetTransformOnLoad(true);
DotobjSetReverseTriangles(true);
model = DotobjModelLoadFile("FoxyBar.obj");

matrix = matrix_build(0,0,0,    0,0,0,   3,3,3);

shape = new BonkStructMesh(x, y, 0,   30, 30, 30);
shape.SetMatrix(matrix);
shape.AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat());