/// Returns the point in worldspace on the far clipping plane that lies under the given screenspace coordinates
/// 
/// @param x                               x-coordinate in screenspace
/// @param y                               y-coordinate in screenspace
/// @param [width]                         Width of the screenspace render target. If not provided, the width of th current render target (either a surface or the backbuffer) will be used
/// @param [height]                        Height of the screenspace render target. If not provided, the height of the current render target (either a surface or the backbuffer) will be used
/// @param [inverseViewProjectionMatrix]   The inverse of the view*projection matrix. If not provided, the current view and projection matrix will be used

function BonkScreenspaceToWorldspace(_x, _y, _width, _height, _inverseMatrix)
{
    if ((_width == undefined) || (_height == undefined))
    {
        var _surface = surface_get_target();
    }
    
    if (_width  == undefined) _width  = (_surface < 0)? display_get_gui_width()  : surface_get_width( _surface);
    if (_height == undefined) _height = (_surface < 0)? display_get_gui_height() : surface_get_height(_surface);
    
    _x = -1 + 2*_x/_width;
    _y = -1 + 2*_y/_height;
    
    if (_inverseMatrix == undefined)
    {
        _inverseMatrix = BonkMatrixInverse(matrix_multiply(matrix_get(matrix_view), matrix_get(matrix_projection)));
    }
    
    var _vector = BonkMatrixTransformVertexExt(_inverseMatrix, _x, _y, 1.0, 1.0);
    
    var _inverseW = 1/_vector[3];
    _vector[@ 0] *= _inverseW;
    _vector[@ 1] *= _inverseW;
    _vector[@ 2] *= _inverseW;
    
    return _vector;
}