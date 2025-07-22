// Feather disable all

/// Draws an arrow between two coordinates, with the head of the arrow pointed at the second
/// coordinate.
/// 
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [arrowSize]
/// @param [color]
/// @param [thickness]

function UggArrow(_x1, _y1, _z1, _x2, _y2, _z2, _arrowSize = undefined, _color = UGG_DEFAULT_DIFFUSE_COLOR, _thickness = UGG_LINE_THICKNESS)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumeLine            = _global.__volumeLine;
    static _volumePyramid         = _global.__volumePyramid;
    static _wireframePyramid      = _global.__wireframePyramid;
    static _wireframeVertexFormat = _global.__wireframeVertexFormat;
    static _vectorMatrix          = matrix_build_identity();
    static _workMatrix            = matrix_build_identity();
    static _staticVBuff           = vertex_create_buffer();
    
    if (_arrowSize == undefined) _arrowSize = 4*_thickness;
    
    var _dx = _x2 - _x1;
    var _dy = _y2 - _y1;
    var _dz = _z2 - _z1;
    
    var _length = sqrt(_dx*_dx + _dy*_dy + _dz*_dz);
    if (_length == 0) return false;
    
    _dx /= _length;
    _dy /= _length;
    _dz /= _length;
    
    //TODO - Optimize
    
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
    
    _vectorMatrix[@  0] = _jx;
    _vectorMatrix[@  1] = _jy;
    _vectorMatrix[@  2] = _jz;
    
    _vectorMatrix[@  4] = _ix;
    _vectorMatrix[@  5] = _iy;
    _vectorMatrix[@  6] = _iz;
    
    _vectorMatrix[@  8] = _dx;
    _vectorMatrix[@  9] = _dy;
    _vectorMatrix[@ 10] = _dz;
    
    _length = max(0, _length - _arrowSize);
    
    _x2 = _x1 + _length*_dx;
    _y2 = _y1 + _length*_dy;
    _z2 = _z1 + _length*_dz;
    
    if (_global.__wireframe)
    {
        shader_set(__shdUggWireframe);
        shader_set_uniform_f(_shdUggWireframe_u_vColor, color_get_red(  _color)/255,
                                                        color_get_green(_color)/255,
                                                        color_get_blue( _color)/255);
        
    	vertex_begin(_staticVBuff, _wireframeVertexFormat);
    	vertex_position_3d(_staticVBuff, _x1, _y1, _z1); vertex_color(_staticVBuff, c_white, 1);
    	vertex_position_3d(_staticVBuff, _x2, _y2, _z2); vertex_color(_staticVBuff, c_white, 1);
    	vertex_end(_staticVBuff);
        
        vertex_submit(_staticVBuff, pr_linelist, -1);
    }
    else
    {
        shader_set(__shdUggVolume);
        shader_set_uniform_f(_shdUggVolume_u_vColor, color_get_red(  _color)/255,
                                                     color_get_green(_color)/255,
                                                     color_get_blue( _color)/255);
        
        _workMatrix[@  0] = _vectorMatrix[@  0]*_thickness;
        _workMatrix[@  1] = _vectorMatrix[@  1]*_thickness;
        _workMatrix[@  2] = _vectorMatrix[@  2]*_thickness;
        
        _workMatrix[@  4] = _vectorMatrix[@  4]*_thickness;
        _workMatrix[@  5] = _vectorMatrix[@  5]*_thickness;
        _workMatrix[@  6] = _vectorMatrix[@  6]*_thickness;
        
        _workMatrix[@  8] = _vectorMatrix[@  8]*_length;
        _workMatrix[@  9] = _vectorMatrix[@  9]*_length;
        _workMatrix[@ 10] = _vectorMatrix[@ 10]*_length;
        
        _workMatrix[@ 12] = _x1;
        _workMatrix[@ 13] = _y1;
        _workMatrix[@ 14] = _z1;
        
        matrix_stack_push(_workMatrix);
        matrix_set(matrix_world, matrix_stack_top());
        vertex_submit(_volumeLine, pr_trianglelist, -1);
    }
    
    _workMatrix[@  0] = _vectorMatrix[@  0]*_arrowSize;
    _workMatrix[@  1] = _vectorMatrix[@  1]*_arrowSize;
    _workMatrix[@  2] = _vectorMatrix[@  2]*_arrowSize;
    
    _workMatrix[@  4] = _vectorMatrix[@  4]*_arrowSize;
    _workMatrix[@  5] = _vectorMatrix[@  5]*_arrowSize;
    _workMatrix[@  6] = _vectorMatrix[@  6]*_arrowSize;
        
    _workMatrix[@  8] = _vectorMatrix[@  8]*_arrowSize;
    _workMatrix[@  9] = _vectorMatrix[@  9]*_arrowSize;
    _workMatrix[@ 10] = _vectorMatrix[@ 10]*_arrowSize;
    
    _workMatrix[@ 12] = _x2;
    _workMatrix[@ 13] = _y2;
    _workMatrix[@ 14] = _z2;
    
    matrix_stack_pop();
    matrix_stack_push(_workMatrix);
    matrix_set(matrix_world, matrix_stack_top());
    
    if (_global.__wireframe)
    {
        vertex_submit(_wireframePyramid, pr_linelist, -1);
    }
    else
    {
        vertex_submit(_volumePyramid, pr_trianglelist, -1);
    }
    
    shader_reset();
    matrix_stack_pop();
    matrix_set(matrix_world, matrix_stack_top());
}