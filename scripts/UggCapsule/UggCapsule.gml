// Feather disable all

/// Draws a capsule. The `x` `y` `z` parameters define the centre of the base of the capsule.
/// 
/// @param x
/// @param y
/// @param z
/// @param height
/// @param radius
/// @param [color]
/// @param [wireframe}

function UggCapsule(_x, _y, _z, _height, _radius, _color = UGG_DEFAULT_DIFFUSE_COLOR, _wireframe = undefined)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumeCap     = _global.__volumeCapsuleCap;
    static _volumeBody    = _global.__volumeCapsuleBody;
    static _wireframeCap  = _global.__wireframeCapsuleCap;
    static _wireframeBody = _global.__wireframeCapsuleBody;
    static _staticMatrix  = matrix_build_identity();
    
    _radius = min(_height/2, _radius);
    
    if (_wireframe ?? _global.__wireframe)
    {
        shader_set(__shdUggWireframe);
        shader_set_uniform_f(_shdUggWireframe_u_vColor, color_get_red(  _color)/255,
                                                        color_get_green(_color)/255,
                                                        color_get_blue( _color)/255);
        
        var _primitive = pr_linelist;
        var _cap       = _wireframeCap;
        var _body      = _wireframeBody;
    }
    else
    {
        shader_set(__shdUggVolume);
        shader_set_uniform_f(_shdUggVolume_u_vColor, color_get_red(  _color)/255,
                                                     color_get_green(_color)/255,
                                                     color_get_blue( _color)/255);
        
        var _primitive = pr_trianglelist;
        var _cap       = _volumeCap;
        var _body      = _volumeBody;
    }
    
    _staticMatrix[@  0] = _radius;
    _staticMatrix[@  5] = _radius;
    _staticMatrix[@ 10] = _radius;
    _staticMatrix[@ 12] = _x;
    _staticMatrix[@ 13] = _y;
    _staticMatrix[@ 14] = _z + _height;
    
    matrix_stack_push(_staticMatrix);
    matrix_set(matrix_world, matrix_stack_top());
    vertex_submit(_cap, _primitive, -1);
    matrix_stack_pop();
    
    _staticMatrix[@  0] =  _radius;
    _staticMatrix[@  5] = -_radius;
    _staticMatrix[@ 10] = -_radius;
    _staticMatrix[@ 12] = _x;
    _staticMatrix[@ 13] = _y;
    _staticMatrix[@ 14] = _z;
    
    matrix_stack_push(_staticMatrix);
    matrix_set(matrix_world, matrix_stack_top());
    vertex_submit(_cap, _primitive, -1);
    matrix_stack_pop();
    
    _staticMatrix[@  0] = _radius;
    _staticMatrix[@  5] = _radius;
    _staticMatrix[@ 10] = _height - 2*_radius;
    _staticMatrix[@ 12] = _x;
    _staticMatrix[@ 13] = _y;
    _staticMatrix[@ 14] = _z + _height/2;
    
    matrix_stack_push(_staticMatrix);
    matrix_set(matrix_world, matrix_stack_top());
    vertex_submit(_body, _primitive, -1);
    matrix_stack_pop();
    
    matrix_set(matrix_world, matrix_stack_top());
    
    shader_reset();
}