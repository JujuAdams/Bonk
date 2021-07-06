/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [color]

function BonkDebugDrawAABB(_x1, _y1, _z1, _x2, _y2, _z2, _color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
{
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin( _vertexBuffer, global.__bonkVertexFormat);
    
    
    
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, -1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, -1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, -1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, -1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, -1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, -1,  0,  0);
    
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  1,  0,  0);
    
    
    
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0, -1,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0, -1,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0, -1,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0, -1,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0, -1,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0, -1,  0);
    
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  1,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  1,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  1,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  1,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  1,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  1,  0);
    
    
    
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  0, -1);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  0, -1);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  0, -1);
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  0, -1);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  0, -1);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z1); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  0, -1);
    
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  0,  1);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  0,  1);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  0,  1);
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  0,  1);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  0,  1);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z2); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer,  0,  0,  1);
    
    
    
    vertex_end(_vertexBuffer);
    
    shader_set(__shdBonk);
    vertex_submit(_vertexBuffer, pr_trianglelist, -1);
    shader_reset();
    
    vertex_delete_buffer(_vertexBuffer);
}