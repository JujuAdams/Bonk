DotobjSetTransformOnLoad(true);
DotobjSetReverseTriangles(true);
model = DotobjModelLoadFile("cube.obj");

shape = (new BonkStructMesh(30, 30, 30))
        .SetMatrix(matrix_build(0, 0, 0,   0, 0, 0,   100, 1, 100))
        .AddVertexBuffer(model.GetVertexBufferArray(), DotobjGetVertexFormat());

var _matrix = matrix_multiply(matrix_build(0,0,0,   0,0,0,   100, 1, 100), matrix_build(0,0,0,   30, 30, 45,   1,1,1));
    _matrix = matrix_multiply(_matrix, matrix_build(x, y, 0,   0,0,0,   1,1,1));
shape.SetMatrix(_matrix);