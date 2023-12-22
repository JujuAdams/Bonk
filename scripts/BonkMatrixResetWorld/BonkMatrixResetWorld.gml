function BonkMatrixResetWorld()
{
    __BONK_GLOBAL
    
    matrix_set(matrix_world, _global.__bonkIdentityMatrix);
}