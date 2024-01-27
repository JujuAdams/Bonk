/// @param x
/// @param y
/// @param z
/// @param [color]

function UggPoint(_x, _y, _z, _color = UGG_DEFAULT_DIFFUSE_COLOR)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumePoint    = _global.__volumePoint;
    static _wireframePoint = _global.__wireframePoint;
    
    var _worldMatrix = matrix_get(matrix_world);
    var _matrix = matrix_build(_x, _y, _z,   0, 0, 0,   UGG_POINT_RADIUS, UGG_POINT_RADIUS, UGG_POINT_RADIUS);
        _matrix = matrix_multiply(_matrix, _worldMatrix);
    matrix_set(matrix_world, _matrix);
    
    if (_global.__wireframe)
    {
        shader_set(__shdUggWireframe);
        shader_set_uniform_f(_shdUggWireframe_u_vColor, color_get_red(  _color)/255,
                                                        color_get_green(_color)/255,
                                                        color_get_blue( _color)/255);
        vertex_submit(_wireframePoint, pr_linelist, -1);
        shader_reset();
    }
    else 
    {
        shader_set(__shdUggVolume);
        shader_set_uniform_f(_shdUggVolume_u_vColor, color_get_red(  _color)/255,
                                                     color_get_green(_color)/255,
                                                     color_get_blue( _color)/255);
        vertex_submit(_volumePoint, pr_trianglelist, -1);
        shader_reset();
    }
    
    matrix_set(matrix_world, _worldMatrix);
}