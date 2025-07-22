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

function UggPyramid(_x, _y, _z, _xSize, _ySize, _zSize, _color = UGG_DEFAULT_DIFFUSE_COLOR)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumePyramid    = _global.__volumePyramid;
    static _wireframePyramid = _global.__wireframePyramid;
    static _staticMatrix     = matrix_build_identity();
    
    _staticMatrix[@  0] = _xSize;
    _staticMatrix[@  5] = _ySize;
    _staticMatrix[@ 10] = _zSize;
    _staticMatrix[@ 12] = _x;
    _staticMatrix[@ 13] = _y;
    _staticMatrix[@ 14] = _z;
    
    matrix_stack_push(_staticMatrix);
    matrix_set(matrix_world, matrix_stack_top());
    
    if (_global.__wireframe)
    {
        shader_set(__shdUggWireframe);
        shader_set_uniform_f(_shdUggWireframe_u_vColor, color_get_red(  _color)/255,
                                                        color_get_green(_color)/255,
                                                        color_get_blue( _color)/255);
        vertex_submit(_wireframePyramid, pr_linelist, -1);
        shader_reset();
    }
    else
    {
        shader_set(__shdUggVolume);
        shader_set_uniform_f(_shdUggVolume_u_vColor, color_get_red(  _color)/255,
                                                     color_get_green(_color)/255,
                                                     color_get_blue( _color)/255);
        vertex_submit(_volumePyramid, pr_trianglelist, -1);
        shader_reset();
    }
    
    matrix_stack_pop();
    matrix_set(matrix_world, matrix_stack_top());
}