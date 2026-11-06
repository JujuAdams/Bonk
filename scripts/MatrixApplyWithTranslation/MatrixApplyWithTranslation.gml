/// @param x
/// @param y
/// @param z
/// @param matrix

function MatrixApplyWithTranslation(_x, _y, _z, _matrix)
{
    static _staticMatrix = matrix_build_identity();
    
    var _modifiedMatrix = _staticMatrix;
    array_copy(_modifiedMatrix, 0, _matrix, 0, 16);
    _modifiedMatrix[@ 12] += _x;
    _modifiedMatrix[@ 13] += _y;
    _modifiedMatrix[@ 14] += _z;
    
    matrix_set(matrix_world, _modifiedMatrix);
}