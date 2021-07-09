/// @param matrix
/// @param x
/// @param y
/// @param z
/// @param w

function BonkMatrixTransformVertexExt(_matrix, _x_in, _y_in, _z_in, _w_in)
{
    var _x = _x_in*_matrix[0] + _y_in*_matrix[4] + _z_in*_matrix[ 8] + _w_in*_matrix[12];
    var _y = _x_in*_matrix[1] + _y_in*_matrix[5] + _z_in*_matrix[ 9] + _w_in*_matrix[13];
    var _z = _x_in*_matrix[2] + _y_in*_matrix[6] + _z_in*_matrix[10] + _w_in*_matrix[14];
    var _w = _x_in*_matrix[3] + _y_in*_matrix[7] + _z_in*_matrix[11] + _w_in*_matrix[15];
    
    return [_x, _y, _z, _w];
}