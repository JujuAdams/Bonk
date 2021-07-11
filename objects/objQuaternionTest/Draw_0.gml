matrix_set(matrix_world, BonkMatrixTranslate(x, y, 0, BonkQuatGetRotationMatrix(quaternion)));
BonkDebugDrawAABB(0, 0, 0, 100, 150, 200, c_white);
BonkMatrixResetWorld();