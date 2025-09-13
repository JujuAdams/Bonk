matrix_set(matrix_world, matrix_build(x, y, 0,    0,0,0,   1,1,1));
UggSetShader();
model.Submit();
shader_reset();
matrix_set(matrix_world, matrix_build_identity());