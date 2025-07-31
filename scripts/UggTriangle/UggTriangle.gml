// Feather disable all

/// Draws a triangle stretched over three coordinates. This function presumes a clockwise winding
/// order.
/// 
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
/// @param [wireframe}

function UggTriangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _color = UGG_DEFAULT_DIFFUSE_COLOR, _wireframe = undefined) 
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumeVertexFormat    = _global.__volumeVertexFormat;
    static _wireframeVertexFormat = _global.__wireframeVertexFormat;
    static _nativeVertexFormat    = _global.__nativeVertexFormat;
    static _staticVBuff           = vertex_create_buffer();
    
    if (_wireframe ?? __UGG_WIREFRAME)
    {
        vertex_begin(_staticVBuff, _wireframeVertexFormat);
        vertex_position_3d(_staticVBuff, _x1, _y1, _z1); vertex_color(_staticVBuff, c_white, 1);
        vertex_position_3d(_staticVBuff, _x2, _y2, _z2); vertex_color(_staticVBuff, c_white, 1);
        vertex_position_3d(_staticVBuff, _x2, _y2, _z2); vertex_color(_staticVBuff, c_white, 1);
        vertex_position_3d(_staticVBuff, _x3, _y3, _z3); vertex_color(_staticVBuff, c_white, 1);
        vertex_position_3d(_staticVBuff, _x3, _y3, _z3); vertex_color(_staticVBuff, c_white, 1);
        vertex_position_3d(_staticVBuff, _x1, _y1, _z1); vertex_color(_staticVBuff, c_white, 1);
        vertex_end(_staticVBuff);
        
        __UGG_WIREFRAME_SHADER
        vertex_submit(_staticVBuff, pr_linelist, -1);
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
        
        if (__UGG_USE_SHADERS)
        {
            vertex_begin(_staticVBuff, _volumeVertexFormat);
            vertex_position_3d(_staticVBuff, _x1, _y1, _z1); vertex_normal(_staticVBuff, _normalX, _normalY, _normalZ);
            vertex_position_3d(_staticVBuff, _x2, _y2, _z2); vertex_normal(_staticVBuff, _normalX, _normalY, _normalZ);
            vertex_position_3d(_staticVBuff, _x3, _y3, _z3); vertex_normal(_staticVBuff, _normalX, _normalY, _normalZ);
            vertex_end(_staticVBuff);
        }
        else
        {
            vertex_begin(_staticVBuff, _nativeVertexFormat);
            vertex_position_3d(_staticVBuff, _x1, _y1, _z1); vertex_normal(_staticVBuff, _normalX, _normalY, _normalZ); vertex_color(_staticVBuff, c_white, 1); vertex_texcoord(_staticVBuff, 0, 0);
            vertex_position_3d(_staticVBuff, _x2, _y2, _z2); vertex_normal(_staticVBuff, _normalX, _normalY, _normalZ); vertex_color(_staticVBuff, c_white, 1); vertex_texcoord(_staticVBuff, 0, 0);
            vertex_position_3d(_staticVBuff, _x3, _y3, _z3); vertex_normal(_staticVBuff, _normalX, _normalY, _normalZ); vertex_color(_staticVBuff, c_white, 1); vertex_texcoord(_staticVBuff, 0, 0);
            vertex_end(_staticVBuff);
        }
        
        __UGG_VOLUME_SHADER
        vertex_submit(_staticVBuff, pr_trianglelist, -1);
        
        gpu_set_cullmode(_oldCullmode);
    }
    
    __UGG_RESET_SHADER
}
