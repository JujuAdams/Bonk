// Feather disable all

/// Draws a small point at the given coordinates. The size of the point is given by the
/// `UGG_POINT_RADIUS` macro.
/// 
/// @param x
/// @param y
/// @param z
/// @param [color]
/// @param [wireframe]

function UggPoint(_x, _y, _z, _color = UGG_DEFAULT_DIFFUSE_COLOR, _wireframe = undefined)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumePoint    = _global.__volumePoint;
    static _wireframePoint = _global.__wireframePoint;
    static _nativePoint    = _global.__nativePoint;
    
    static _staticMatrix = [UGG_POINT_RADIUS, 0, 0, 0,
                            0, UGG_POINT_RADIUS, 0, 0,
                            0, 0, UGG_POINT_RADIUS, 0,
                            0, 0, 0, 1];
    
    _staticMatrix[@ 12] = _x;
    _staticMatrix[@ 13] = _y;
    _staticMatrix[@ 14] = _z;
    
    matrix_stack_push(_staticMatrix);
    matrix_set(matrix_world, matrix_stack_top());
    
    if (_wireframe ?? __UGG_WIREFRAME)
    {
        __UGG_WIREFRAME_SHADER
        vertex_submit(_wireframePoint, pr_linelist, -1);
    }
    else 
    {
        __UGG_VOLUME_SHADER
        vertex_submit(__UGG_USE_SHADERS? _volumePoint : _nativePoint, pr_trianglelist, -1);
    }
    
    __UGG_RESET_SHADER
    
    matrix_stack_pop();
    matrix_set(matrix_world, matrix_stack_top());
}