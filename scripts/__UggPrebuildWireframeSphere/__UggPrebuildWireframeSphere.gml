// Feather disable all

/// @param stripSteps
/// @param stripCount
/// @param bandCount
/// @param bandAccuracy

function __UggPrebuildWireframeSphere(_stripSteps, _stripCount, _bandCount, _bandAccuracy)
{
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin(_vertexBuffer, __Ugg().__wireframeVertexFormat);
    
    var _lengthB = 0;
    var _zB      = 1;
    
    var _j = 1;
    repeat(_stripSteps)
    {
        var _lengthA = _lengthB;
        var _zA      = _zB;
        
        var _phi     = 180*(_j / _stripSteps);
        var _lengthB = dsin(_phi);
        var _zB      = dcos(_phi);
        
        var _xA = _lengthA;
        var _yA = 0;
        var _xB = _lengthB;
        var _yB = 0;
        
        var _i = 1;
        repeat(_stripCount)
        {
            var _theta = 360*(_i / _stripCount);
            var _cos = dcos(_theta);
            var _sin = dsin(_theta);
            
            _xA =  _lengthA*_cos;
            _yA = -_lengthA*_sin;
            _xB =  _lengthB*_cos;
            _yB = -_lengthB*_sin;
            
            vertex_position_3d(_vertexBuffer, _xA, _yA, _zA); vertex_color(_vertexBuffer, c_white, 1);
            vertex_position_3d(_vertexBuffer, _xB, _yB, _zB); vertex_color(_vertexBuffer, c_white, 1);
            
            ++_i;
        }
        
        ++_j;
    }
    
    var _bandSteps = _stripCount*_bandAccuracy;
    
    var _j = 0;
    repeat(_bandCount)
    {
        //var _phi    = 180*((_j + 1) / (_bandCount + 1));
        //var _length = dsin(_phi);
        //var _z      = dcos(_phi);
        
        var _z = 2*((_j + 1) / (_bandCount + 1)) - 1;
        var _length = sqrt(1 - _z*_z);
        
        var _x2 = _length;
        var _y2 = 0;
        
        var _i = 0;
        repeat(_bandSteps+1)
        {
            var _x1 = _x2;
            var _y1 = _y2;
            
            var _theta = 360*(_i / _bandSteps);
            var _cos = dcos(_theta);
            var _sin = dsin(_theta);
            
            _x2 =  _length*_cos;
            _y2 = -_length*_sin;
            
            vertex_position_3d(_vertexBuffer, _x1, _y1, _z); vertex_color(_vertexBuffer, c_white, 1);
            vertex_position_3d(_vertexBuffer, _x2, _y2, _z); vertex_color(_vertexBuffer, c_white, 1);
            
            ++_i;
        }
        
        ++_j;
    }
    
    vertex_end(_vertexBuffer);
    vertex_freeze(_vertexBuffer);
    
    return _vertexBuffer;
}