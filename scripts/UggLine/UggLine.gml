/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [color]
/// @param [thickness]

function UggLine(_x1, _y1, _z1, _x2, _y2, _z2, _color = UGG_DEFAULT_DIFFUSE_COLOR, _thickness = UGG_LINE_THICKNESS)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumeLine = _global.__volumeLine;
    static _wireframeVertexFormat = _global.__wireframeVertexFormat;
    
    if (_global.__wireframe)
    {
    	var _vertexBuffer = vertex_create_buffer();
    	vertex_begin(_vertexBuffer, _wireframeVertexFormat);
        
    	vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_color(_vertexBuffer, c_white, 1);
    	vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_color(_vertexBuffer, c_white, 1);
        
    	vertex_end(_vertexBuffer);
        
        shader_set(__shdUggWireframe);
        shader_set_uniform_f(_shdUggWireframe_u_vColor, color_get_red(  _color)/255,
                                                        color_get_green(_color)/255,
                                                        color_get_blue( _color)/255);
        vertex_submit(_vertexBuffer, pr_linelist, -1);
        
        vertex_delete_buffer(_vertexBuffer);
    }
    else
    {
        var _dx = _x2 - _x1;
        var _dy = _y2 - _y1;
        var _dz = _z2 - _z1;
        
        var _length = sqrt(_dx*_dx + _dy*_dy + _dz*_dz);
        if (_length == 0) return false;
        
        var _planeLength = sqrt(_dx*_dx + _dy*_dy);
        var _zAngle = point_direction(0, 0, _planeLength, _dz);
        var _pAngle = point_direction(0, 0, _dx, _dy);
        
        var _worldMatrix = matrix_get(matrix_world);
        var _matrix = matrix_build(0,0,0,   0,0,0,   _thickness, _thickness, _length);
            _matrix = matrix_multiply(_matrix, matrix_build(0,0,0,   0, -90 - _zAngle, 0,   1,1,1));
            _matrix = matrix_multiply(_matrix, matrix_build(0,0,0,   0, 0, _pAngle,   1,1,1));
            _matrix = matrix_multiply(_matrix, matrix_build(_x1, _y1, _z1,   0,0,0,   1,1,1));
            _matrix = matrix_multiply(_matrix, _worldMatrix);
        matrix_set(matrix_world, _matrix);
        
        shader_set(__shdUggVolume);
        shader_set_uniform_f(_shdUggVolume_u_vColor, color_get_red(  _color)/255,
                                                     color_get_green(_color)/255,
                                                     color_get_blue( _color)/255);
        vertex_submit(_volumeLine, pr_trianglelist, -1);
        matrix_set(matrix_world, _worldMatrix);
    }
    
    shader_reset();
}