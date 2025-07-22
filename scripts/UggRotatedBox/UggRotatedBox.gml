// Feather disable all

/// Draws a cuboid with optional rotation in the z axis.
/// 
/// @param xCentre
/// @param yCentre
/// @param zCentre
/// @param xSize
/// @param ySize
/// @param zSize
/// @param [zRotation=0]
/// @param [color]
/// @param [wireframe}

function UggRotatedBox(_x, _y, _z, _xSize, _ySize, _zSize, _zRotation = 0, _color = UGG_DEFAULT_DIFFUSE_COLOR, _wireframe = undefined)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumeAABB    = _global.__volumeAABB;
    static _wireframeAABB = _global.__wireframeAABB;
    static _staticMatrix  = matrix_build_identity();
    
    var _cos = dcos(_zRotation);
    var _sin = dsin(_zRotation);
    
    _staticMatrix[@  0] =  _xSize*_cos;
    _staticMatrix[@  1] = -_xSize*_sin;
    _staticMatrix[@  4] =  _ySize*_sin;
    _staticMatrix[@  5] =  _ySize*_cos;
    _staticMatrix[@ 10] = _zSize;
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
    
    matrix_stack_pop();
    matrix_set(matrix_world, matrix_stack_top());
}