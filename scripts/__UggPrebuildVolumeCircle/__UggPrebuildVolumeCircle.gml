// Feather disable all

function __UggPrebuildVolumeCircle(_steps)
{
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin(_vertexBuffer, __Ugg().__volumeVertexFormat);
    
    var _x2 = 1;
    var _y2 = 0;
    
    var _i = 0;
    repeat(_steps+1)
    {
        var _x1 = _x2;
        var _y1 = _y2;
        
        var _theta = 360*(_i / _steps);
        _x2 =  dcos(_theta);
        _y2 = -dsin(_theta);
        
        vertex_position_3d(_vertexBuffer,   0,   0,  1); vertex_normal(_vertexBuffer, 0, 0, 1);
        vertex_position_3d(_vertexBuffer, _x2, _y2,  1); vertex_normal(_vertexBuffer, 0, 0, 1);
        vertex_position_3d(_vertexBuffer, _x1, _y1,  1); vertex_normal(_vertexBuffer, 0, 0, 1);
        
        ++_i;
    }
    
    vertex_end(_vertexBuffer);
    //Don't freeze, we'll need this vertex buffer for conversion into the native GML format
    
    return _vertexBuffer;
}