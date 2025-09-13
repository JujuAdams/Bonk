// Feather disable all

function __UggMatrixTransformVertex4DDivW(_matrix, _x, _y, _z, _w)
{
    var _vector = matrix_transform_vertex(_matrix, _x, _y, _z, _w);
    _w = _vector[3];
    
    if (_w == 0)
    {
        //Imprecise but we want to avoid NaN and infinity creeping in
        _vector[@ 0] *= 999999;
        _vector[@ 1] *= 999999;
        _vector[@ 2] *= 999999;
        _vector[@ 3]  = 0;
    }
    else
    {
        _vector[@ 0] /= _w;
        _vector[@ 1] /= _w;
        _vector[@ 2] /= _w;
        _vector[@ 3]  = 1;
    }
    
    return _vector;
}