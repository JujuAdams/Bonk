DotobjSetTransformOnLoad(true);
DotobjSetReverseTriangles(true);
model = DotobjModelLoadFile("cube.obj");

//matrix = matrix_multiply(matrix_build(0,0,0,   0,0,0,   100, 1, 100), matrix_build(0,0,0,   30, 30, 45,   1,1,1));
matrix = matrix_build(0,0,0,    30, 30, 30,   100, 100, 100);

shape = (new BonkStructMesh(x, y, 0,   30, 30, 30))
        .SetMatrix(matrix)
        .AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat(), false);