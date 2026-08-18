function GetHeightmapWireframeVertexFormat()
{
    static _vertexFormat = (function()
    {
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_color();
        return vertex_format_end();
    })();
    
    return _vertexFormat;
}