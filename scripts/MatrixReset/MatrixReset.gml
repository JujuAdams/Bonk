function MatrixReset()
{
    static _staticMatrix = matrix_build_identity();
    matrix_set(matrix_world, _staticMatrix);
}