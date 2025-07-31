// Feather disable all

/// @param zSteps
/// @param xySteps

function __UggPrebuildWireframeCapsuleCap(_zSteps, _xySteps)
{
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin(_vertexBuffer, __Ugg().__wireframeVertexFormat);
    
    var _lengthB = 0;
    var _zB      = 1;
    
    var _j = 1;
    repeat(0.5*_zSteps)
    {
        var _lengthA = _lengthB;
        var _zA      = _zB;
        
        var _phi     = 90*(_j / (0.5*_zSteps));
        var _lengthB = dsin(_phi);
        var _zB      = dcos(_phi);
        
        var _i = 0;
        repeat(_xySteps)
        {
            var _theta = 360*(_i / _xySteps);
            var _cos = dcos(_theta);
            var _sin = dsin(_theta);
            var _xA =  _lengthA*_cos;
            var _yA = -_lengthA*_sin;
            var _xB =  _lengthB*_cos;
            var _yB = -_lengthB*_sin;
            
            vertex_position_3d(_vertexBuffer, _xA, _yA, _zA-1); vertex_color(_vertexBuffer, c_white, 1);
            vertex_position_3d(_vertexBuffer, _xB, _yB, _zB-1); vertex_color(_vertexBuffer, c_white, 1);
            
            ++_i;
        }
        
        ++_j;
    }
    
    vertex_end(_vertexBuffer);
    vertex_freeze(_vertexBuffer);
    
    return _vertexBuffer;
}