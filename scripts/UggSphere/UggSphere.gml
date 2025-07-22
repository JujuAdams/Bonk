// Feather disable all

/// Draws at a sphere at the given coordinates.
/// 
/// @param x
/// @param y
/// @param z
/// @param radius
/// @param [color]
/// @param [wireframe}

function UggSphere(_x, _y, _z, _radius, _color = UGG_DEFAULT_DIFFUSE_COLOR, _wireframe = undefined)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumeSphere    = _global.__volumeSphere;
    static _wireframeSphere = _global.__wireframeSphere;
    static _staticMatrix    = matrix_build_identity();
    
    _staticMatrix[@  0] = _radius;
    _staticMatrix[@  5] = _radius;
    _staticMatrix[@ 10] = _radius;
    _staticMatrix[@ 12] = _x;
    _staticMatrix[@ 13] = _y;
    _staticMatrix[@ 14] = _z;
    
    matrix_stack_push(_staticMatrix);
    matrix_set(matrix_world, matrix_stack_top());
    
    if (_wireframe ?? _global.__wireframe)
    {
        shader_set(__shdUggWireframe);
        shader_set_uniform_f(_shdUggWireframe_u_vColor, color_get_red(  _color)/255,
                                                        color_get_green(_color)/255,
                                                        color_get_blue( _color)/255);
        vertex_submit(_wireframeSphere, pr_linelist, -1);
        shader_reset();
    }
    else 
    {
        shader_set(__shdUggVolume);
        shader_set_uniform_f(_shdUggVolume_u_vColor, color_get_red(  _color)/255,
                                                     color_get_green(_color)/255,
                                                     color_get_blue( _color)/255);
        vertex_submit(_volumeSphere, pr_trianglelist, -1);
        shader_reset();
    }
    
    matrix_stack_pop();
    matrix_set(matrix_world, matrix_stack_top());
}