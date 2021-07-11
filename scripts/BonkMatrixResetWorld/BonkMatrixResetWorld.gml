global.__bonkIdentityMatrix = matrix_build_identity();

function BonkMatrixResetWorld()
{
    matrix_set(matrix_world, global.__bonkIdentityMatrix);
}