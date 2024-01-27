/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param x3
/// @param y3
/// @param z3
/// @param [color]

function UggQuad(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _color = UGG_DEFAULT_DIFFUSE_COLOR) 
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumeVertexFormat    = _global.__volumeVertexFormat;
    static _wireframeVertexFormat = _global.__wireframeVertexFormat;
    
    if (_global.__wireframe)
    {
        var _x4 = _x2 + _x3 - _x1;
        var _y4 = _y2 + _y3 - _y1;
        var _z4 = _z2 + _z3 - _z1;
        
    	var _vertexBuffer = vertex_create_buffer();
    	vertex_begin(_vertexBuffer, _wireframeVertexFormat);
        
    	vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_color(_vertexBuffer, c_white, 1);
    	vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_color(_vertexBuffer, c_white, 1);
    	vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_color(_vertexBuffer, c_white, 1);
    	vertex_position_3d(_vertexBuffer, _x4, _y4, _z4); vertex_color(_vertexBuffer, c_white, 1);
    	vertex_position_3d(_vertexBuffer, _x4, _y4, _z4); vertex_color(_vertexBuffer, c_white, 1);
    	vertex_position_3d(_vertexBuffer, _x3, _y3, _z3); vertex_color(_vertexBuffer, c_white, 1);
    	vertex_position_3d(_vertexBuffer, _x3, _y3, _z3); vertex_color(_vertexBuffer, c_white, 1);
    	vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_color(_vertexBuffer, c_white, 1);
        
    	vertex_end(_vertexBuffer);
        
        shader_set(__shdUggWireframe);
        shader_set_uniform_f(_shdUggWireframe_u_vColor, color_get_red(  _color)/255,
                                                        color_get_green(_color)/255,
                                                        color_get_blue( _color)/255);
        vertex_submit(_vertexBuffer, pr_linelist, -1);
        shader_reset();
    }
    else
    {
        var _oldCullmode = gpu_get_cullmode();
        gpu_set_cullmode(cull_noculling);
        
        var _dx12 = _x2 - _x1;
        var _dy12 = _y2 - _y1;
        var _dz12 = _z2 - _z1;
        var _dx13 = _x3 - _x1;
        var _dy13 = _y3 - _y1;
        var _dz13 = _z3 - _z1;
        
        var _normalX = -(_dz12*_dy13 - _dy12*_dz13);
        var _normalY = -(_dx12*_dz13 - _dz12*_dx13);
        var _normalZ = -(_dy12*_dx13 - _dx12*_dy13);
        
        var _x4 = _x2 + _dx13;
        var _y4 = _y2 + _dy13;
        var _z4 = _z2 + _dz13;
        
    	var _vertexBuffer = vertex_create_buffer();
    	vertex_begin(_vertexBuffer, _volumeVertexFormat);
    	vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_normal(_vertexBuffer, _normalX, _normalY, _normalZ);
    	vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_normal(_vertexBuffer, _normalX, _normalY, _normalZ);
    	vertex_position_3d(_vertexBuffer, _x3, _y3, _z3); vertex_normal(_vertexBuffer, _normalX, _normalY, _normalZ);
        
    	vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_normal(_vertexBuffer, _normalX, _normalY, _normalZ);
    	vertex_position_3d(_vertexBuffer, _x4, _y4, _z4); vertex_normal(_vertexBuffer, _normalX, _normalY, _normalZ);
    	vertex_position_3d(_vertexBuffer, _x3, _y3, _z3); vertex_normal(_vertexBuffer, _normalX, _normalY, _normalZ);
        
    	vertex_end(_vertexBuffer);
        
        shader_set(__shdUggVolume);
        shader_set_uniform_f(_shdUggVolume_u_vColor, color_get_red(  _color)/255,
                                               color_get_green(_color)/255,
                                               color_get_blue( _color)/255);
        vertex_submit(_vertexBuffer, pr_trianglelist, -1);
        shader_reset();
        
        gpu_set_cullmode(_oldCullmode);
    }
    
    vertex_delete_buffer(_vertexBuffer);
}
