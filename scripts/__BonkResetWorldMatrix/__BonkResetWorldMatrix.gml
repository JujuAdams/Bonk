function __BonkResetWorldMatrix()
{
    static _identityMatrix = matrix_build_identity();
    matrix_set(matrix_world, _identityMatrix);
}