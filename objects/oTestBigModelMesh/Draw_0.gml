matrix_set(matrix_world, shape.GetMatrix());
UggSetShader();
model.Submit();
shader_reset();
MatrixReset();

shape.DrawAABB();