// Feather disable all

/// Draws an infinite plane. The plane will follow the camera.
/// 
/// @param x
/// @param y
/// @param z
/// @param normalX
/// @param normalY
/// @param normalZ
/// @param [color]
/// @param [wireframe}

function UggPlane(_x, _y, _z, _dx, _dy, _dz, _color = UGG_DEFAULT_DIFFUSE_COLOR, _wireframe = undefined)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumePlane    = _global.__volumePlane;
    static _wireframePlane = _global.__wireframePlane;
    static _nativePlane    = _global.__nativePlane;
    static _staticMatrix   = matrix_build_identity();
    
    var _length = sqrt(_dx*_dx + _dy*_dy + _dz*_dz);
    if (_length == 0) return false;
    
    _dx /= _length;
    _dy /= _length;
    _dz /= _length;
    
    //TODO - Optimize
    
    var _invViewMatrix = matrix_inverse(matrix_get(matrix_view));
    var _camX = _invViewMatrix[12];
    var _camY = _invViewMatrix[13];
    var _camZ = _invViewMatrix[14];
    
    var _distance = dot_product_3d(_dx, _dy, _dz, _camX, _camY, _camZ) - dot_product_3d(_dx, _dy, _dz, _x, _y, _z);
    _x = _camX - _distance*_dx;
    _y = _camY - _distance*_dy;
    _z = _camZ - _distance*_dz;
    
    if ((_dx == 0) && (_dy == 0) && (_dz == 1))
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
    
    var _ix = _dz*_uy - _dy*_uz;
    var _iy = _dx*_uz - _dz*_ux;
    var _iz = _dy*_ux - _dx*_uy;
    
    var _jx = _dz*_iy - _dy*_iz;
    var _jy = _dx*_iz - _dz*_ix;
    var _jz = _dy*_ix - _dx*_iy;
    
    _staticMatrix[@  0] = _jx;
    _staticMatrix[@  1] = _jy;
    _staticMatrix[@  2] = _jz;
    
    _staticMatrix[@  4] = _ix;
    _staticMatrix[@  5] = _iy;
    _staticMatrix[@  6] = _iz;
    
    _staticMatrix[@  8] = _dx;
    _staticMatrix[@  9] = _dy;
    _staticMatrix[@ 10] = _dz;
    
    _staticMatrix[@ 12] = _x;
    _staticMatrix[@ 13] = _y;
    _staticMatrix[@ 14] = _z;
    
    matrix_stack_push(_staticMatrix);
    matrix_set(matrix_world, matrix_stack_top());
    
    if (_wireframe ?? __UGG_WIREFRAME)
    {
        __UGG_WIREFRAME_SHADER
        vertex_submit(_wireframePlane, pr_linelist, -1);
    }
    else
    {
        var _oldCullmode = gpu_get_cullmode();
        gpu_set_cullmode(cull_noculling);
        
        __UGG_VOLUME_SHADER
        vertex_submit(__UGG_USE_SHADERS? _volumePlane : _nativePlane, pr_trianglelist, -1);
        
        gpu_set_cullmode(_oldCullmode);
    }
    
    __UGG_RESET_SHADER
    
    matrix_stack_pop();
    matrix_set(matrix_world, matrix_stack_top());
}