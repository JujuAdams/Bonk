// Feather disable all

/// @param capSteps
/// @param wallSteps

function __UggPrebuildWireframeCylinder(_capSteps, _wallSteps)
{
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin(_vertexBuffer, __Ugg().__wireframeVertexFormat);
    
    var _x2 = 1;
    var _y2 = 0;
    
    var _i = 0;
    repeat(_capSteps+1)
    {
        var _x1 = _x2;
        var _y1 = _y2;
        
        var _theta = 360*(_i / _capSteps);
        _x2 =  dcos(_theta);
        _y2 = -dsin(_theta);
        
        vertex_position_3d(_vertexBuffer, _x1, _y1, 1); vertex_color(_vertexBuffer, c_white, 1);
        vertex_position_3d(_vertexBuffer, _x2, _y2, 1); vertex_color(_vertexBuffer, c_white, 1);
        
        vertex_position_3d(_vertexBuffer, _x2, _y2, 0); vertex_color(_vertexBuffer, c_white, 1);
        vertex_position_3d(_vertexBuffer, _x1, _y1, 0); vertex_color(_vertexBuffer, c_white, 1);
        
        ++_i;
    }
    
    var _i = 0;
    repeat(_wallSteps+1)
    {
        var _theta = 360*(_i / _wallSteps);
        var _x =  dcos(_theta);
        var _y = -dsin(_theta);
        
        vertex_position_3d(_vertexBuffer, _x, _y, 0); vertex_color(_vertexBuffer, c_white, 1);
        vertex_position_3d(_vertexBuffer, _x, _y, 1); vertex_color(_vertexBuffer, c_white, 1);
        
        ++_i;
    }
    
    vertex_end(_vertexBuffer);
    vertex_freeze(_vertexBuffer);
    
    return _vertexBuffer;
}