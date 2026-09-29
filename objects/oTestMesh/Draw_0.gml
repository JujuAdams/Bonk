matrix_set(matrix_world, shape.GetMatrix());
UggSetShader();
model.Submit();
shader_reset();
matrix_set(matrix_world, matrix_build_identity());

shape.DrawNeighborhoodForShape(oTestPlayer.shape, c_red);