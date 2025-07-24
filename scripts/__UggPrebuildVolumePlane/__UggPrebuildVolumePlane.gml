// Feather disable all

/// @param size

function __UggPrebuildVolumePlane(_size)
{
    _size *= 0.5;
    
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin( _vertexBuffer, __Ugg().__volumeVertexFormat);
    
    vertex_position_3d(_vertexBuffer, -_size, -_size, 0); vertex_normal(_vertexBuffer, 0,  0,  1);
    vertex_position_3d(_vertexBuffer,  _size, -_size, 0); vertex_normal(_vertexBuffer, 0,  0,  1);
    vertex_position_3d(_vertexBuffer,  _size,  _size, 0); vertex_normal(_vertexBuffer, 0,  0,  1);
    
    vertex_position_3d(_vertexBuffer, -_size, -_size, 0); vertex_normal(_vertexBuffer, 0,  0,  1);
    vertex_position_3d(_vertexBuffer,  _size,  _size, 0); vertex_normal(_vertexBuffer, 0,  0,  1);
    vertex_position_3d(_vertexBuffer, -_size,  _size, 0); vertex_normal(_vertexBuffer, 0,  0,  1);
    
    vertex_end(_vertexBuffer);
    //Don't freeze, we'll need this vertex buffer for conversion into the native GML format
    
    return _vertexBuffer;
}