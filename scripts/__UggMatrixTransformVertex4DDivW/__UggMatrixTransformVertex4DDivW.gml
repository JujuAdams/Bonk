// Feather disable all

function __UggMatrixTransformVertex4DDivW(_matrix, _x, _y, _z, _w)
{
    var _w_result = _matrix[3]*_x + _matrix[7]*_y + _matrix[11]*_z + _matrix[15]*_w;
    
    return [
        (_matrix[0]*_x + _matrix[4]*_y + _matrix[ 8]*_z + _matrix[12]*_w) / _w_result,
        (_matrix[1]*_x + _matrix[5]*_y + _matrix[ 9]*_z + _matrix[13]*_w) / _w_result,
        (_matrix[2]*_x + _matrix[6]*_y + _matrix[10]*_z + _matrix[14]*_w) / _w_result,
        (_w_result == 0)? 0 : 1,
    ];
}