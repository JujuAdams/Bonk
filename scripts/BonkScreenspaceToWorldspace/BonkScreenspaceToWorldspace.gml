/// Returns the point in worldspace on the far clipping plane that lies under the given screenspace coordinates
/// 
/// @param x
/// @param y
/// @param [width]
/// @param [height]
/// @param [inverseViewProjectionMatrix]

function BonkScreenspaceToWorldspace(_x, _y, _width, _height, _inverseMatrix)
{
    if ((_width == undefined) || (_height == undefined))
    {
        var _surface = surface_get_target();
    }
    
    if (_width  == undefined) _width  = (_surface < 0)? display_get_gui_width()  : surface_get_width( _surface);
    if (_height == undefined) _height = (_surface < 0)? display_get_gui_height() : surface_get_height(_surface);
    
    _x = 2*(_x/_width ) - 1;
    _y = 2*(_y/_height) - 1;
    
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