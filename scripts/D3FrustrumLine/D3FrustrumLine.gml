// Feather disable all

/// Returns a line segment determined by a ray shot through a frustrum. You must use normalised x/y
/// values to indicate where the ray should be directed. An x/y value of `-1, -1` is the top-left
/// corner and `+1, +1` is the bottom-right corner. The x and y position should both be zero for
/// the centre of the frustrum which is usually what you want.
/// 
/// This function returns a struct contains `x1` `y1` `z1`, the origin of the line segment, and `x2`
/// `y2` `z2`, the ending coordinate of the line segment.
/// 
/// @param viewMatrix
/// @param projMatrix
/// @param [xNorm=0]
/// @param [yNorm=0]

function D3FrustrumLine(_viewMatrix, _projMatrix, _x = 0, _y = 0)
{
    static _result = {
        x1: 0,
        y1: 0,
        z1: 0,
        x2: 0,
        y2: 0,
        z2: 0,
    };
    
    with(_result)
    {
        var _vpMatrixInverse = matrix_inverse(matrix_multiply(_viewMatrix, _projMatrix));
        
        var _vector = matrix_transform_vertex(_vpMatrixInverse, _x, -_y, 0, 1);
        var _w = _vector[3];
        x1 = _vector[0] / _w;
        y1 = _vector[1] / _w;
        z1 = _vector[2] / _w;
        
        var _vector = matrix_transform_vertex(_vpMatrixInverse, _x, -_y, 1, 1);
        var _w = _vector[3];
        x2 = _vector[0] / _w;
        y2 = _vector[1] / _w;
        z2 = _vector[2] / _w;
    }
    
    return _result;
}