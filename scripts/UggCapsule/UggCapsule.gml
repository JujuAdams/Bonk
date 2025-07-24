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
    static _nativeCap     = _global.__nativeCapsuleCap;
    static _nativeBody    = _global.__nativeCapsuleBody;
    static _staticMatrix  = matrix_build_identity();
    
    _radius = min(_height/2, _radius);
    
    if (_wireframe ?? __UGG_WIREFRAME)
    {
        __UGG_WIREFRAME_SHADER
        
        var _primitive = pr_linelist;
        var _cap       = _wireframeCap;
        var _body      = _wireframeBody;
    }
    else
    {
        var _primitive = pr_trianglelist;
        
        __UGG_VOLUME_SHADER
        
        if (__UGG_USE_SHADERS)
        {
            var _cap  = _volumeCap;
            var _body = _volumeBody;
        }
        else
        {
            var _cap  = _nativeCap;
            var _body = _nativeBody;
        }
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
    
    __UGG_RESET_SHADER
}