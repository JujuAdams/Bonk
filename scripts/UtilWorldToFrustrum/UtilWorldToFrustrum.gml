// Feather disable all

/// Returns the position on the frustrum where the position in world space would appear. The output
/// position may be be out of the bounds of the screen. The input coordinates should be in world
/// space. You must provide a view and projection matrix but you do not have to provide a world
/// matrix (use `undefined` to not use a world matrix).
/// 
/// This function returns a struct that contains `x` and `y` which is the projected coordinate on
/// the frustrum. An x/y value of `-1, -1` is the top-left corner and `+1, +1` is the bottom-right
/// corner. The struct also contains a `z` coordinate which is a normalized coordinate where a
/// value of `0` is at the z-near clipping plane and a value of `1` is that the z-far clipping
/// plane (a value outside of the range `0` to `1` is therefore not visible).
/// 
/// @param x
/// @param y
/// @param [worldMatrix]
/// @param viewMatrix
/// @param projMatrix

function UtilWorldToFrustrum(_x, _y, _z, _worldMatrix = undefined, _viewMatrix, _projMatrix)
{
    static _result = {};
    
    static _vectorStatic = array_create(4, 0);
    var _vector = _vectorStatic;
    
    with(_result)
    {
        if (_worldMatrix != undefined)
        {
            matrix_transform_vertex(_worldMatrix, _x, _y, _z, 1, _vector);
            matrix_transform_vertex(_viewMatrix, _vector[0], _vector[1], _vector[2], 1, _vector);
        }
        else
        {
            matrix_transform_vertex(_viewMatrix, _x, _y, _z, 1, _vector);
        }
        
        matrix_transform_vertex(_projMatrix, _vector[0], _vector[1], _vector[2], 1, _vector);
        
        var _w = _vector[3];
        x = _vector[0] / _w;
        y = _vector[1] / _w;
        z = _vector[3] / _w;
    }
    
    return _result;
}