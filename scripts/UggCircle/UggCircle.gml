// Feather disable all

/// Draws a circle on a plane with the given normal. To draw the circle on the XY plane, use
/// (0, 0, 1) as the normal vector.
/// 
/// @param x
/// @param y
/// @param z
/// @param radius
/// @param normalX
/// @param normalY
/// @param normalZ
/// @param [color]
/// @param [wireframe]

function UggCircle(_x, _y, _z, _radius, _normalX, _normalY, _normalZ, _color = UGG_DEFAULT_DIFFUSE_COLOR, _wireframe = undefined)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumeCircle    = _global.__volumeCircle;
    static _wireframeCircle = _global.__wireframeCircle;
    static _nativeCircle    = _global.__nativeCircle;
    static _staticMatrix    = matrix_build_identity();
    
    var _length = sqrt(_normalX*_normalX + _normalY*_normalY + _normalZ*_normalZ);
    if (_length == 0) return false;
    
    _normalX /= _length;
    _normalY /= _length;
    _normalZ /= _length;
    
    //TODO - Optimize
    
    if ((_normalX == 0) && (_normalY == 0) && (abs(_normalZ) == 1))
    {
        var _ux = 0;
        var _uy = 1;
        var _uz = 0;
    }
    else
    {
        var _ux = 0;
        var _uy = 0;
        var _uz = 1;
    }
    
    var _ix = _normalZ*_uy - _normalY*_uz;
    var _iy = _normalX*_uz - _normalZ*_ux;
    var _iz = _normalY*_ux - _normalX*_uy;
    
    var _jx = _normalZ*_iy - _normalY*_iz;
    var _jy = _normalX*_iz - _normalZ*_ix;
    var _jz = _normalY*_ix - _normalX*_iy;
    
    _staticMatrix[@  0] = _jx*_radius;
    _staticMatrix[@  1] = _jy*_radius;
    _staticMatrix[@  2] = _jz*_radius;
    
    _staticMatrix[@  4] = _ix*_radius;
    _staticMatrix[@  5] = _iy*_radius;
    _staticMatrix[@  6] = _iz*_radius;
    
    _staticMatrix[@  8] = _normalX;
    _staticMatrix[@  9] = _normalY;
    _staticMatrix[@ 10] = _normalZ;
    
    _staticMatrix[@ 12] = _x;
    _staticMatrix[@ 13] = _y;
    _staticMatrix[@ 14] = _z;
    
    matrix_stack_push(_staticMatrix);
    matrix_set(matrix_world, matrix_stack_top());
    
    if (_wireframe ?? __UGG_WIREFRAME)
    {
        __UGG_WIREFRAME_SHADER
        vertex_submit(_wireframeCircle, pr_linelist, -1);
    }
    else
    {
        var _oldCullmode = gpu_get_cullmode();
        gpu_set_cullmode(cull_noculling);
        
        __UGG_VOLUME_SHADER
        vertex_submit(__UGG_USE_SHADERS? _volumeCircle : _nativeCircle, pr_trianglelist, -1);
        
        gpu_set_cullmode(_oldCullmode);
    }
    
    __UGG_RESET_SHADER
    
    matrix_stack_pop();
    matrix_set(matrix_world, matrix_stack_top());
}