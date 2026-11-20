DotobjSetTransformOnLoad(true);
DotobjSetReverseTriangles(true);
model = DotobjModelLoadFile("FoxyBar.obj");

matrix = matrix_build(x, y, 0,    0,0,0,   3,3,3);

shape = new BonkStructMesh(10, 10, 10);
shape.AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat());
shape.SetMatrix(matrix);