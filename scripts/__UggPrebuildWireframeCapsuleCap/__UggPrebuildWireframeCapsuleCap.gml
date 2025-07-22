// Feather disable all

function __UggPrebuildWireframeCapsuleCap(_steps)
{
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin(_vertexBuffer, __Ugg().__wireframeVertexFormat);
    
    var _phi    = 90 / _steps;
    var _length = dsin(_phi);
    var _z      = dcos(_phi);
    
    var _x2 = _length;
    var _y2 = 0;
    
    var _i = 1;
    repeat(_steps)
    {
        var _x1 = _x2;
        var _y1 = _y2;
        
        var _theta = 360*(_i / _steps);
        _x2 =  _length*dcos(_theta);
        _y2 = -_length*dsin(_theta);
        
        vertex_position_3d(_vertexBuffer,   0,   0,    0); vertex_color(_vertexBuffer, c_white, 1);
        vertex_position_3d(_vertexBuffer, _x1, _y1, _z-1); vertex_color(_vertexBuffer, c_white, 1);
        
        vertex_position_3d(_vertexBuffer, _x1, _y1, _z-1); vertex_color(_vertexBuffer, c_white, 1);
        vertex_position_3d(_vertexBuffer, _x2, _y2, _z-1); vertex_color(_vertexBuffer, c_white, 1);
        
        ++_i;
    }
    
    //Borrow values from the cap calculations
    var _lengthB = _length;
    var _zB      = _z;
    
    var _j = 2;
    repeat(_steps-1)
    {
        var _lengthA = _lengthB;
        var _zA      = _zB;
        
        var _phi     = 90*(_j / _steps);
        var _lengthB = dsin(_phi);
        var _zB      = dcos(_phi);
        
        var _x2A = _lengthA;
        var _y2A = 0;
        var _x2B = _lengthB;
        var _y2B = 0;
        
        var _i = 1;
        repeat(_steps)
        {
            var _x1A = _x2A;
            var _y1A = _y2A;
            var _x1B = _x2B;
            var _y1B = _y2B;
            
            var _theta = 360*(_i / _steps);
            var _cos = dcos(_theta);
            var _sin = dsin(_theta);
            _x2A =  _lengthA*_cos;
            _y2A = -_lengthA*_sin;
            _x2B =  _lengthB*_cos;
            _y2B = -_lengthB*_sin;
            
            vertex_position_3d(_vertexBuffer, _x1A, _y1A, _zA-1); vertex_color(_vertexBuffer, c_white, 1);
            vertex_position_3d(_vertexBuffer, _x2A, _y2A, _zA-1); vertex_color(_vertexBuffer, c_white, 1);
            
            vertex_position_3d(_vertexBuffer, _x2A, _y2A, _zA-1); vertex_color(_vertexBuffer, c_white, 1);
            vertex_position_3d(_vertexBuffer, _x2B, _y2B, _zB-1); vertex_color(_vertexBuffer, c_white, 1);
            
            vertex_position_3d(_vertexBuffer, _x2B, _y2B, _zB-1); vertex_color(_vertexBuffer, c_white, 1);
            vertex_position_3d(_vertexBuffer, _x1B, _y1B, _zB-1); vertex_color(_vertexBuffer, c_white, 1);
            
            vertex_position_3d(_vertexBuffer, _x1B, _y1B, _zB-1); vertex_color(_vertexBuffer, c_white, 1);
            vertex_position_3d(_vertexBuffer, _x1A, _y1A, _zA-1); vertex_color(_vertexBuffer, c_white, 1);
            
            ++_i;
        }
        
        ++_j;
    }
    
    vertex_end(_vertexBuffer);
	vertex_freeze(_vertexBuffer);
    
    return _vertexBuffer;
}