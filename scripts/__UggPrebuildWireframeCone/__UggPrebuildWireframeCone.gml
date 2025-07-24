// Feather disable all

/// @param baseSteps
/// @param slopeSteps

function __UggPrebuildWireframeCone(_baseSteps, _slopeSteps)
{
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin(_vertexBuffer, __Ugg().__wireframeVertexFormat);
    
    var _incr = 360 / _baseSteps;
    var _angle = 0;
    
    var _bx = dcos(_angle);
    var _by = dsin(_angle);
    
    repeat(_baseSteps)
    {
        _angle += _incr;
        
        var _ax =  _bx;
        var _ay =  _by;
        var _bx =  dcos(_angle);
        var _by = -dsin(_angle);
        
        //Cap
        vertex_position_3d(_vertexBuffer, _ax, _ay, 0); vertex_color(_vertexBuffer, c_white, 1);
        vertex_position_3d(_vertexBuffer, _bx, _by, 0); vertex_color(_vertexBuffer, c_white, 1);
    }
    
    //Slope
    var _incr = 360 / _slopeSteps;
    var _angle = 0;
    repeat(_slopeSteps)
    {
        vertex_position_3d(_vertexBuffer,            0,             0, 1); vertex_color(_vertexBuffer, c_white, 1);
        vertex_position_3d(_vertexBuffer, dcos(_angle), -dsin(_angle), 0); vertex_color(_vertexBuffer, c_white, 1);
        
        _angle += _incr;
    }

    vertex_end(_vertexBuffer);
    vertex_freeze(_vertexBuffer);
    return _vertexBuffer;
}