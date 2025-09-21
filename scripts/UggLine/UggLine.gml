// Feather disable all

/// Draws a line between two coordinates.
/// 
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [color]
/// @param [thickness]
/// @param [wireframe]

function UggLine(_x1, _y1, _z1, _x2, _y2, _z2, _color = UGG_DEFAULT_DIFFUSE_COLOR, _thickness = UGG_LINE_THICKNESS, _wireframe = undefined)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _nativeLine            = _global.__nativeLine;
    static _volumeLine            = _global.__volumeLine;
    static _wireframeVertexFormat = _global.__wireframeVertexFormat;
    static _staticMatrix          = matrix_build_identity();
    static _staticVBuff           = vertex_create_buffer();
    
    if (_wireframe ?? __UGG_WIREFRAME)
    {
        vertex_begin(_staticVBuff, _wireframeVertexFormat);
        vertex_position_3d(_staticVBuff, _x1, _y1, _z1); vertex_color(_staticVBuff, c_white, 1);
        vertex_position_3d(_staticVBuff, _x2, _y2, _z2); vertex_color(_staticVBuff, c_white, 1);
        vertex_end(_staticVBuff);
        
        __UGG_WIREFRAME_SHADER
        vertex_submit(_staticVBuff, pr_linelist, -1);
    }
    else
    {
        var _dx = _x2 - _x1;
        var _dy = _y2 - _y1;
        var _dz = _z2 - _z1;
        
        var _length = sqrt(_dx*_dx + _dy*_dy + _dz*_dz);
        if (_length == 0) return false;
        
        _dx /= _length;
        _dy /= _length;
        _dz /= _length;
        
        //TODO - Optimize
        
        if ((_dx == 0) && (_dy == 0) && (abs(_dz) == 1))
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
        //Make sure this is normalized so we don't get any deformation
        var _iLength = sqrt(_ix*_ix + _iy*_iy + _iz*_iz);
        _ix /= _iLength;
        _iy /= _iLength;
        _iz /= _iLength;
        
        var _jx = _dz*_iy - _dy*_iz;
        var _jy = _dx*_iz - _dz*_ix;
        var _jz = _dy*_ix - _dx*_iy;
        //Make sure this is normalized so we don't get any deformation
        var _jLength = sqrt(_jx*_jx + _jy*_jy + _jz*_jz);
        _jx /= _jLength;
        _jy /= _jLength;
        _jz /= _jLength;
        
        _staticMatrix[@  0] = _jx*_thickness;
        _staticMatrix[@  1] = _jy*_thickness;
        _staticMatrix[@  2] = _jz*_thickness;
        
        _staticMatrix[@  4] = _ix*_thickness;
        _staticMatrix[@  5] = _iy*_thickness;
        _staticMatrix[@  6] = _iz*_thickness;
        
        _staticMatrix[@  8] = _dx*_length;
        _staticMatrix[@  9] = _dy*_length;
        _staticMatrix[@ 10] = _dz*_length;
        
        _staticMatrix[@ 12] = _x1;
        _staticMatrix[@ 13] = _y1;
        _staticMatrix[@ 14] = _z1;
        
        matrix_stack_push(_staticMatrix);
        matrix_set(matrix_world, matrix_stack_top());
        
        __UGG_VOLUME_SHADER
        vertex_submit(__UGG_USE_SHADERS? _volumeLine : _nativeLine, pr_trianglelist, -1);
        
        matrix_stack_pop();
        matrix_set(matrix_world, matrix_stack_top());
    }
    
    __UGG_RESET_SHADER
}