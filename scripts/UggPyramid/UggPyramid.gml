// Feather disable all

/// Draws a rectangle-based pyramid. The `x` `y` `z` parameters define the centre of the base of
/// the pyramid.
/// 
/// @param x
/// @param y
/// @param z
/// @param xSize
/// @param ySize
/// @param zSize
/// @param [color]
/// @param [wireframe]

function UggPyramid(_x, _y, _z, _xSize, _ySize, _zSize, _color = UGG_DEFAULT_DIFFUSE_COLOR, _wireframe = undefined)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumePyramid    = _global.__volumePyramid;
    static _wireframePyramid = _global.__wireframePyramid;
    static _nativePyramid    = _global.__nativePyramid;
    static _staticMatrix     = matrix_build_identity();
    
    _staticMatrix[@  0] = _xSize;
    _staticMatrix[@  5] = _ySize;
    _staticMatrix[@ 10] = _zSize;
    _staticMatrix[@ 12] = _x;
    _staticMatrix[@ 13] = _y;
    _staticMatrix[@ 14] = _z;
    
    matrix_stack_push(_staticMatrix);
    matrix_set(matrix_world, matrix_stack_top());
    
    if (_wireframe ?? __UGG_WIREFRAME)
    {
        __UGG_WIREFRAME_SHADER
        vertex_submit(_wireframePyramid, pr_linelist, -1);
    }
    else
    {
        __UGG_VOLUME_SHADER
        vertex_submit(__UGG_USE_SHADERS? _volumePyramid : _nativePyramid, pr_trianglelist, -1);
    }
    
    __UGG_RESET_SHADER
    
    matrix_stack_pop();
    matrix_set(matrix_world, matrix_stack_top());
}