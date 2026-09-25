matrix_set(matrix_world, matrix);
UggSetShader();
model.Submit();
shader_reset();
matrix_set(matrix_world, matrix_build_identity());