/// Transforms a vec4 by the given 4x4 matrix and returns the resulting vec4
/// This is an improvement of GameMaker's native matrix_transform_vertex() as this function allows an input w-component to be specified and returns a vec4
/// 
/// @param matrix   Matrix to use for the transformation
/// @param x        x-component of the input vec4
/// @param y        y-component of the input vec4
/// @param z        z-component of the input vec4
/// @param w        w-component of the input vec4

function BonkMatrixTransformVertexExt(_matrix, _x_in, _y_in, _z_in, _w_in)
{
    var _x = _x_in*_matrix[0] + _y_in*_matrix[4] + _z_in*_matrix[ 8] + _w_in*_matrix[12];
    var _y = _x_in*_matrix[1] + _y_in*_matrix[5] + _z_in*_matrix[ 9] + _w_in*_matrix[13];
    var _z = _x_in*_matrix[2] + _y_in*_matrix[6] + _z_in*_matrix[10] + _w_in*_matrix[14];
    var _w = _x_in*_matrix[3] + _y_in*_matrix[7] + _z_in*_matrix[11] + _w_in*_matrix[15];
    
    return [_x, _y, _z, _w];
}