// Feather disable all

function __UggPrebuildVolumePyramid()
{
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin(_vertexBuffer, __Ugg().__volumeVertexFormat);
    
    //Slopes
    vertex_position_3d(_vertexBuffer,    0,    0, 1); vertex_normal(_vertexBuffer, 0, -0.44721360, 0.89442719);
    vertex_position_3d(_vertexBuffer, -0.5, -0.5, 0); vertex_normal(_vertexBuffer, 0, -0.44721360, 0.89442719);
    vertex_position_3d(_vertexBuffer,  0.5, -0.5, 0); vertex_normal(_vertexBuffer, 0, -0.44721360, 0.89442719);
    
    vertex_position_3d(_vertexBuffer,    0,    0, 1); vertex_normal(_vertexBuffer, 0.44721360, 0, 0.89442719);
    vertex_position_3d(_vertexBuffer,  0.5, -0.5, 0); vertex_normal(_vertexBuffer, 0.44721360, 0, 0.89442719);
    vertex_position_3d(_vertexBuffer,  0.5,  0.5, 0); vertex_normal(_vertexBuffer, 0.44721360, 0, 0.89442719);
    
    vertex_position_3d(_vertexBuffer,    0,    0, 1); vertex_normal(_vertexBuffer, 0, 0.44721360, 0.89442719);
    vertex_position_3d(_vertexBuffer,  0.5,  0.5, 0); vertex_normal(_vertexBuffer, 0, 0.44721360, 0.89442719);
    vertex_position_3d(_vertexBuffer, -0.5,  0.5, 0); vertex_normal(_vertexBuffer, 0, 0.44721360, 0.89442719);
    
    vertex_position_3d(_vertexBuffer,    0,    0, 1); vertex_normal(_vertexBuffer, -0.44721360, 0, 0.89442719);
    vertex_position_3d(_vertexBuffer, -0.5,  0.5, 0); vertex_normal(_vertexBuffer, -0.44721360, 0, 0.89442719);
    vertex_position_3d(_vertexBuffer, -0.5, -0.5, 0); vertex_normal(_vertexBuffer, -0.44721360, 0, 0.89442719);
    
    //Bottom
    vertex_position_3d(_vertexBuffer, -0.5, -0.5, 0); vertex_normal(_vertexBuffer, 0, 0, -1);
    vertex_position_3d(_vertexBuffer,  0.5,  0.5, 0); vertex_normal(_vertexBuffer, 0, 0, -1);
    vertex_position_3d(_vertexBuffer,  0.5, -0.5, 0); vertex_normal(_vertexBuffer, 0, 0, -1);
    
    vertex_position_3d(_vertexBuffer, -0.5, -0.5, 0); vertex_normal(_vertexBuffer, 0, 0, -1);
    vertex_position_3d(_vertexBuffer, -0.5,  0.5, 0); vertex_normal(_vertexBuffer, 0, 0, -1);
    vertex_position_3d(_vertexBuffer,  0.5,  0.5, 0); vertex_normal(_vertexBuffer, 0, 0, -1);

    vertex_end(_vertexBuffer);
    //Don't freeze, we'll need this vertex buffer for conversion into the native GML format
    
    return _vertexBuffer;
}