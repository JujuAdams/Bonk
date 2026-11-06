MatrixApplyWithTranslation(shape.x, shape.y, shape.z, shape.GetMatrix());
UggSetShader();
model.Submit();
shader_reset();
MatrixReset();