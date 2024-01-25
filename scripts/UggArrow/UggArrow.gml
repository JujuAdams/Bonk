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
    //TODO - Optimise
    
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumeLine            = _global.__volumeLine;
    static _volumePyramid         = _global.__volumePyramid;
    static _wireframePyramid      = _global.__wireframePyramid;
    static _wireframeVertexFormat = _global.__wireframeVertexFormat;
    
    if (_arrowSize == undefined) _arrowSize = 4*_thickness;
    
    var _dx = _x2 - _x1;
    var _dy = _y2 - _y1;
    var _dz = _z2 - _z1;
    
    var _length = sqrt(_dx*_dx + _dy*_dy + _dz*_dz);
    if (_length == 0) return false;
    if (_length < _arrowSize)
    {
        _length = 0;
        
        var _ax = _x1;
        var _ay = _y1;
        var _az = _z1;
    }
    else
    {
        var _factor = (_length - _arrowSize) / _length;
        _length -= _arrowSize;
        
        var _ax = _x1 + _factor*_dx;
        var _ay = _y1 + _factor*_dy;
        var _az = _z1 + _factor*_dz;
    }
    
    var _planeLength = sqrt(_dx*_dx + _dy*_dy);
    var _zAngle = point_direction(0, 0, _planeLength, _dz);
    var _pAngle = point_direction(0, 0, _dx, _dy);
    
    var _worldMatrix = matrix_get(matrix_world);
        
    var _pyramidMatrix = matrix_build(0,0,0,   0,0,0,   _arrowSize, _arrowSize, _arrowSize);
        _pyramidMatrix = matrix_multiply(_pyramidMatrix, matrix_build(0,0,0,   0, -90 - _zAngle, 0,   1,1,1));
        _pyramidMatrix = matrix_multiply(_pyramidMatrix, matrix_build(0,0,0,   0, 0, _pAngle,   1,1,1));
        _pyramidMatrix = matrix_multiply(_pyramidMatrix, matrix_build(_ax, _ay, _az,   0,0,0,   1,1,1));
        _pyramidMatrix = matrix_multiply(_pyramidMatrix, _worldMatrix);
    
    if (_global.__wireframe)
    {
        shader_set(__shdUggWireframe);
        shader_set_uniform_f(_shdUggWireframe_u_vColor, color_get_red(  _color)/255,
                                                        color_get_green(_color)/255,
                                                        color_get_blue( _color)/255);
        
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
        
        matrix_set(matrix_world, _pyramidMatrix);
        vertex_submit(_wireframePyramid, pr_linelist, -1);
    }
    else
    {
        var _lineMatrix = matrix_build(0,0,0,   0,0,0,   _thickness, _thickness, _length);
            _lineMatrix = matrix_multiply(_lineMatrix, matrix_build(0,0,0,   0, -90 - _zAngle, 0,   1,1,1));
            _lineMatrix = matrix_multiply(_lineMatrix, matrix_build(0,0,0,   0, 0, _pAngle,   1,1,1));
            _lineMatrix = matrix_multiply(_lineMatrix, matrix_build(_x1, _y1, _z1,   0,0,0,   1,1,1));
            _lineMatrix = matrix_multiply(_lineMatrix, _worldMatrix);
        
        shader_set(__shdUggVolume);
        shader_set_uniform_f(_shdUggVolume_u_vColor, color_get_red(  _color)/255,
                                                     color_get_green(_color)/255,
                                                     color_get_blue( _color)/255);
        
        matrix_set(matrix_world, _lineMatrix);
        vertex_submit(_volumeLine, pr_trianglelist, -1);
        
        matrix_set(matrix_world, _pyramidMatrix);
        vertex_submit(_volumePyramid, pr_trianglelist, -1);
    }
    
    shader_reset();
    matrix_set(matrix_world, _worldMatrix);
}