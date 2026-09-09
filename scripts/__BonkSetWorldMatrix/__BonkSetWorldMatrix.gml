/// @param x
/// @param y
/// @param z

function __BonkSetWorldMatrix(_x, _y, _z)
{
    static _matrix = matrix_build_identity();
    
    _matrix[@ 12] = _x;
    _matrix[@ 13] = _y;
    _matrix[@ 14] = _z;
    
    matrix_set(matrix_world, _matrix);
}