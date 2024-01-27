// Feather disable all

function __UggPrebuildWireframePyramid()
{
	var _vertexBuffer = vertex_create_buffer();
	vertex_begin(_vertexBuffer, __Ugg().__wireframeVertexFormat);
    
    //Slopes
	vertex_position_3d(_vertexBuffer,    0,    0, 1); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer, -0.5, -0.5, 0); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer,    0,    0, 1); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer,  0.5, -0.5, 0); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer,    0,    0, 1); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer,  0.5,  0.5, 0); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer,    0,    0, 1); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer, -0.5,  0.5, 0); vertex_color(_vertexBuffer, c_white, 1);
    
    //Bottom
	vertex_position_3d(_vertexBuffer, -0.5, -0.5, 0); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer,  0.5, -0.5, 0); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer,  0.5, -0.5, 0); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer,  0.5,  0.5, 0); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer,  0.5,  0.5, 0); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer, -0.5,  0.5, 0); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer, -0.5,  0.5, 0); vertex_color(_vertexBuffer, c_white, 1);
	vertex_position_3d(_vertexBuffer, -0.5, -0.5, 0); vertex_color(_vertexBuffer, c_white, 1);

	vertex_end(_vertexBuffer);
	vertex_freeze(_vertexBuffer);
	return _vertexBuffer;
}