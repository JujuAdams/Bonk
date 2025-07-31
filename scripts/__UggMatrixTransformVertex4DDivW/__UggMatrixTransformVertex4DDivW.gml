// Feather disable all

function __UggMatrixTransformVertex4DDivW(_matrix, _x, _y, _z, _w)
{
    var _vector = matrix_transform_vertex(_matrix, _x, _y, _z, _w);
    
    _w = _vector[3];
    _vector[@ 0] /= _w;
    _vector[@ 1] /= _w;
    _vector[@ 2] /= _w;
    _vector[@ 3]  = (_w == 0)? 0 : 1;
    
    return _vector;
}