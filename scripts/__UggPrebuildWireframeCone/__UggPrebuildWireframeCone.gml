// Feather disable all

function __UggPrebuildWireframeCone()
{
	var _vertexBuffer = vertex_create_buffer();
	vertex_begin(_vertexBuffer, __Ugg().__wireframeVertexFormat);
    
    var _incr = 360 / UGG_CONE_STEPS;
    var _angle = _incr/2;
    
	var _bx = dcos(_angle);
	var _by = dsin(_angle);
    
    repeat(UGG_CONE_STEPS)
    {
        _angle += _incr;
        var _cos = dcos(_angle);
        var _sin = dsin(_angle);
        
	    var _ax = _bx;
	    var _ay = _by;
	    var _bx = _cos;
	    var _by = _sin;
        
        //Cap
	    vertex_position_3d(_vertexBuffer, _ax, _ay, 0); vertex_color(_vertexBuffer, c_white, 1);
	    vertex_position_3d(_vertexBuffer, _bx, _by, 0); vertex_color(_vertexBuffer, c_white, 1);
        
        //Slope
	    vertex_position_3d(_vertexBuffer,   0,   0, 1); vertex_color(_vertexBuffer, c_white, 1);
	    vertex_position_3d(_vertexBuffer, _ax, _ay, 0); vertex_color(_vertexBuffer, c_white, 1);
	}

	vertex_end(_vertexBuffer);
	vertex_freeze(_vertexBuffer);
	return _vertexBuffer;
}