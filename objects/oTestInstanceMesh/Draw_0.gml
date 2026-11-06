MatrixApplyWithTranslation(x, y, z, GetMatrix());
UggSetShader();
model.Submit();
shader_reset();
MatrixReset();

//DebugDraw(c_ltgray);