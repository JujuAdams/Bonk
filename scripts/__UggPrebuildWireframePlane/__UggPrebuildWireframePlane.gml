// Feather disable all

/// @param size
/// @param subdivisions

function __UggPrebuildWireframePlane(_size, _subdivisions)
{
    _size *= 0.5;
    
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin( _vertexBuffer, __Ugg().__wireframeVertexFormat);
    
    //Edge
    vertex_position_3d(_vertexBuffer, -_size, -_size, 0); vertex_color(_vertexBuffer, c_white, 1);
    vertex_position_3d(_vertexBuffer,  _size, -_size, 0); vertex_color(_vertexBuffer, c_white, 1);
    
    vertex_position_3d(_vertexBuffer,  _size, -_size, 0); vertex_color(_vertexBuffer, c_white, 1);
    vertex_position_3d(_vertexBuffer,  _size,  _size, 0); vertex_color(_vertexBuffer, c_white, 1);
    
    vertex_position_3d(_vertexBuffer,  _size,  _size, 0); vertex_color(_vertexBuffer, c_white, 1);
    vertex_position_3d(_vertexBuffer, -_size,  _size, 0); vertex_color(_vertexBuffer, c_white, 1);
    
    vertex_position_3d(_vertexBuffer, -_size,  _size, 0); vertex_color(_vertexBuffer, c_white, 1);
    vertex_position_3d(_vertexBuffer, -_size, -_size, 0); vertex_color(_vertexBuffer, c_white, 1);
    
    if (_subdivisions > 0)
    {
        //Cross
        vertex_position_3d(_vertexBuffer, -_size, -_size, 0); vertex_color(_vertexBuffer, c_white, 1);
        vertex_position_3d(_vertexBuffer,  _size,  _size, 0); vertex_color(_vertexBuffer, c_white, 1);
        
        vertex_position_3d(_vertexBuffer,  _size, -_size, 0); vertex_color(_vertexBuffer, c_white, 1);
        vertex_position_3d(_vertexBuffer, -_size,  _size, 0); vertex_color(_vertexBuffer, c_white, 1);
        
        //Hatching
        var _incr =  1 / (1 + _subdivisions);
        var _t = _incr;
        repeat(_subdivisions)
        {
            var _q = _size*(2*_t - 1);
            
            vertex_position_3d(_vertexBuffer,     _q, -_size, 0); vertex_color(_vertexBuffer, c_white, 1);
            vertex_position_3d(_vertexBuffer, -_size,     _q, 0); vertex_color(_vertexBuffer, c_white, 1);
            
            vertex_position_3d(_vertexBuffer,     _q, -_size, 0); vertex_color(_vertexBuffer, c_white, 1);
            vertex_position_3d(_vertexBuffer,  _size,    -_q, 0); vertex_color(_vertexBuffer, c_white, 1);
            
            vertex_position_3d(_vertexBuffer,    -_q,  _size, 0); vertex_color(_vertexBuffer, c_white, 1);
            vertex_position_3d(_vertexBuffer,  _size,    -_q, 0); vertex_color(_vertexBuffer, c_white, 1);
            
            vertex_position_3d(_vertexBuffer,     -_q, _size, 0); vertex_color(_vertexBuffer, c_white, 1);
            vertex_position_3d(_vertexBuffer,  -_size,    _q, 0); vertex_color(_vertexBuffer, c_white, 1);
            
            _t += _incr;
        }
    }
    
    vertex_end(_vertexBuffer);
    vertex_freeze(_vertexBuffer);
    
    return _vertexBuffer;
}