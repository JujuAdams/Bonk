DotobjSetTransformOnLoad(true);
DotobjSetReverseTriangles(true);
model = DotobjModelLoadFile("FoxyBar.obj");

matrix = matrix_build(x, y, 0,    0,0,0,   3,3,3);

shape = new BonkStructMesh(30, 30, 30);
shape.SetMatrix(matrix);
shape.AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat());