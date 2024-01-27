/// Draws an axis-aligned bounding box
/// 
/// @param  xCentre   x-coordinate of the centre of the AABB
/// @param  yCentre   y-coordinate of the centre of the AABB
/// @param  zCentre   z-coordinate of the centre of the AABB
/// @param  xSize     Size of the AABB in the x-axis
/// @param  ySize     Size of the AABB in the y-axis
/// @param  zSize     Size of the AABB in the z-axis
/// @param  [color]   Colour of the AABB (standard GameMaker 24-integer)

function UggAABB(_x, _y, _z, _xSize, _ySize, _zSize, _color = UGG_DEFAULT_DIFFUSE_COLOR)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumeAABB    = _global.__volumeAABB;
    static _wireframeAABB = _global.__wireframeAABB;
    
    var _worldMatrix = matrix_get(matrix_world);
    var _matrix = matrix_build(_x, _y, _z,   0, 0, 0,   _xSize, _ySize, _zSize);
        _matrix = matrix_multiply(_matrix, _worldMatrix);
    matrix_set(matrix_world, _matrix);
    
    if (_global.__wireframe)
    {
        shader_set(__shdUggWireframe);
        shader_set_uniform_f(_shdUggWireframe_u_vColor, color_get_red(  _color)/255,
                                                        color_get_green(_color)/255,
                                                        color_get_blue( _color)/255);
        vertex_submit(_wireframeAABB, pr_linelist, -1);
        shader_reset();
    }
    else
    {
        shader_set(__shdUggVolume);
        shader_set_uniform_f(_shdUggVolume_u_vColor, color_get_red(  _color)/255,
                                                     color_get_green(_color)/255,
                                                     color_get_blue( _color)/255);
        vertex_submit(_volumeAABB, pr_trianglelist, -1);
        shader_reset();
    }
    
    matrix_set(matrix_world, _worldMatrix);
}