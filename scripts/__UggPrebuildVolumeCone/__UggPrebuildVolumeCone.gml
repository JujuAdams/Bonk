// Feather disable all

function __UggPrebuildVolumeCone(_steps)
{
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin(_vertexBuffer, __Ugg().__volumeVertexFormat);
    
    var _incr = 360 / _steps;
    var _angle = 0;
    
    var _bx = dcos(_angle);
    var _by = dsin(_angle);
    
    repeat(_steps)
    {
        _angle += _incr;
        var _cos = dcos(_angle);
        var _sin = dsin(_angle);
        
        var _ax = _bx;
        var _ay = _by;
        var _bx = _cos;
        var _by = _sin;
        
        //Bottom cap
        vertex_position_3d(_vertexBuffer,   0  , 0, 0); vertex_normal(_vertexBuffer, 0, 0, -1);
        vertex_position_3d(_vertexBuffer, _bx, _by, 0); vertex_normal(_vertexBuffer, 0, 0, -1);
        vertex_position_3d(_vertexBuffer, _ax, _ay, 0); vertex_normal(_vertexBuffer, 0, 0, -1);
        
        //Wall
        vertex_position_3d(_vertexBuffer, _ax, _ay, 0); vertex_normal(_vertexBuffer, 0.70710678118*_ax, 0.70710678118*_ay, 0.70710678118);
        vertex_position_3d(_vertexBuffer, _bx, _by, 0); vertex_normal(_vertexBuffer, 0.70710678118*_bx, 0.70710678118*_by, 0.70710678118);
        vertex_position_3d(_vertexBuffer,   0,   0, 1); vertex_normal(_vertexBuffer, 0.70710678118*_ax, 0.70710678118*_ay, 0.70710678118);
    }

    vertex_end(_vertexBuffer);
    //Don't freeze, we'll need this vertex buffer for conversion into the native GML format
    
    return _vertexBuffer;
}