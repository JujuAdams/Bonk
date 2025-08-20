// Feather disable all

/// Returns a ray shot through a frustrum. You must use normalised x/y values to indicate where
/// the ray should be directed relative to the frustrum. An x/y value of `-1, -1` is the top-left
/// corner and `+1, +1` is the bottom-right corner. The x and y position should both be zero for
/// the centre of the frustrum which is usually what you want.
/// 
/// This function returns a struct contains `x` `y` `z`, the origin of the ray, and `dX` `dY` `dZ`,
/// the direction of the ray.
/// 
/// @param viewMatrix
/// @param projMatrix
/// @param [xNorm=0]
/// @param [yNorm=0]

function D3FrustrumRay(_viewMatrix, _projMatrix, _x = 0, _y = 0)
{
    static _result = {
        x: 0,
        y: 0,
        z: 0,
        dX: 0,
        dY: 0,
        dZ: 0,
    };
    
    with(_result)
    {
        var _vpMatrixInverse = matrix_inverse(matrix_multiply(_viewMatrix, _projMatrix));
        
        var _vector = matrix_transform_vertex(_vpMatrixInverse, _x, -_y, 0, 1);
        var _w = _vector[3];
        x = _vector[0] / _w;
        y = _vector[1] / _w;
        z = _vector[2] / _w;
        
        var _vector = matrix_transform_vertex(_vpMatrixInverse, _x, -_y, 1, 1);
        var _w = _vector[3];
        var _x2 = _vector[0] / _w;
        var _y2 = _vector[1] / _w;
        var _z2 = _vector[2] / _w;
        
        var _dX = _x2 - x;
        var _dY = _y2 - y;
        var _dZ = _z2 - z;
        var _distance = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
        dX = _dX / _distance;
        dY = _dY / _distance;
        dZ = _dZ / _distance;
    }
    
    return _result;
}