// Feather disable all

/// Draws a cone. The `x` `y` `z` parameters define the centre of the base of the cone.
/// 
/// @param x
/// @param y
/// @param z
/// @param height
/// @param radius
/// @param [color]
/// @param [wireframe}

function UggCone(_x, _y, _z, _height, _radius, _color = UGG_DEFAULT_DIFFUSE_COLOR, _wireframe = undefined)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumeCone    = _global.__volumeCone;
    static _wireframeCone = _global.__wireframeCone;
    static _nativeCone    = _global.__nativeCone;
    static _staticMatrix  = matrix_build_identity();
    
    _staticMatrix[@  0] = _radius;
    _staticMatrix[@  5] = _radius;
    _staticMatrix[@ 10] = _height;
    _staticMatrix[@ 12] = _x;
    _staticMatrix[@ 13] = _y;
    _staticMatrix[@ 14] = _z;
    
    matrix_stack_push(_staticMatrix);
    matrix_set(matrix_world, matrix_stack_top());
    
    if (_wireframe ?? __UGG_WIREFRAME)
    {
        __UGG_WIREFRAME_SHADER
        vertex_submit(_wireframeCone, pr_linelist, -1);
    }
    else
    {
        __UGG_VOLUME_SHADER
        vertex_submit(__UGG_USE_SHADERS? _volumeCone : _nativeCone, pr_trianglelist, -1);
    }
    
    __UGG_RESET_SHADER
    
    matrix_stack_pop();
    matrix_set(matrix_world, matrix_stack_top());
}