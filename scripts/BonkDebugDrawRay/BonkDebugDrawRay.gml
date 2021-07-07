/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [color]

function BonkDebugDrawRay(_in_x1, _in_y1, _in_z1, _in_x2, _in_y2, _in_z2, _color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
{
    var _dx = _in_x2 - _in_x1;
    var _dy = _in_y2 - _in_y1;
    var _dz = _in_z2 - _in_z1;
    
    var _delta = BonkVecNormalize([_dx, _dy, _dz]);
    
    if (!BonkVecEqual(_delta, [0, 0, 1]) && !BonkVecEqual(_delta, [0, 0, -1]))
    {
        var _tangent_normal = BonkVecCross(_delta, [0, 0, 1]);
    }
    else
    {
        var _tangent_normal = BonkVecCross(_delta, [1, 0, 0]);
    }
    
    var _bitangent_normal = BonkVecCross(_delta, _tangent_normal);
    
    
    
    #region Unpack values
    
    var _delta_normal_x = _delta[0];
    var _delta_normal_y = _delta[1];
    var _delta_normal_z = _delta[2];
    
    var _tangent_normal_x = _tangent_normal[0];
    var _tangent_normal_y = _tangent_normal[1];
    var _tangent_normal_z = _tangent_normal[2];
    
    var _bitangent_normal_x = _bitangent_normal[0];
    var _bitangent_normal_y = _bitangent_normal[1];
    var _bitangent_normal_z = _bitangent_normal[2];
    
    var _tangent_x = _tangent_normal_x*(BONK_DRAW_RAY_THICKNESS/2);
    var _tangent_y = _tangent_normal_y*(BONK_DRAW_RAY_THICKNESS/2);
    var _tangent_z = _tangent_normal_z*(BONK_DRAW_RAY_THICKNESS/2);
    
    var _bitangent_x = _bitangent_normal_x*(BONK_DRAW_RAY_THICKNESS/2);
    var _bitangent_y = _bitangent_normal_y*(BONK_DRAW_RAY_THICKNESS/2);
    var _bitangent_z = _bitangent_normal_z*(BONK_DRAW_RAY_THICKNESS/2);
    
    var _a1_x = _in_x1 + _tangent_x + _bitangent_x;
    var _a1_y = _in_y1 + _tangent_y + _bitangent_y;
    var _a1_z = _in_z1 + _tangent_z + _bitangent_z;
    
    var _b1_x = _in_x1 + _tangent_x - _bitangent_x;
    var _b1_y = _in_y1 + _tangent_y - _bitangent_y;
    var _b1_z = _in_z1 + _tangent_z - _bitangent_z;
    
    var _c1_x = _in_x1 - _tangent_x + _bitangent_x;
    var _c1_y = _in_y1 - _tangent_y + _bitangent_y;
    var _c1_z = _in_z1 - _tangent_z + _bitangent_z;
    
    var _d1_x = _in_x1 - _tangent_x - _bitangent_x;
    var _d1_y = _in_y1 - _tangent_y - _bitangent_y;
    var _d1_z = _in_z1 - _tangent_z - _bitangent_z;
    
    var _a2_x = _in_x2 + _tangent_x + _bitangent_x;
    var _a2_y = _in_y2 + _tangent_y + _bitangent_y;
    var _a2_z = _in_z2 + _tangent_z + _bitangent_z;
    
    var _b2_x = _in_x2 + _tangent_x - _bitangent_x;
    var _b2_y = _in_y2 + _tangent_y - _bitangent_y;
    var _b2_z = _in_z2 + _tangent_z - _bitangent_z;
    
    var _c2_x = _in_x2 - _tangent_x + _bitangent_x;
    var _c2_y = _in_y2 - _tangent_y + _bitangent_y;
    var _c2_z = _in_z2 - _tangent_z + _bitangent_z;
    
    var _d2_x = _in_x2 - _tangent_x - _bitangent_x;
    var _d2_y = _in_y2 - _tangent_y - _bitangent_y;
    var _d2_z = _in_z2 - _tangent_z - _bitangent_z;
    
    #endregion
    
    
    
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin( _vertexBuffer, global.__bonkVertexFormat);
    
    
    
    #region Write to the vertex buffer
    
    //Top
    vertex_position_3d(_vertexBuffer, _a1_x, _a1_y, _a1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _bitangent_normal_x, _bitangent_normal_y, _bitangent_normal_z);
    vertex_position_3d(_vertexBuffer, _c1_x, _c1_y, _c1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _bitangent_normal_x, _bitangent_normal_y, _bitangent_normal_z);
    vertex_position_3d(_vertexBuffer, _c2_x, _c2_y, _c2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _bitangent_normal_x, _bitangent_normal_y, _bitangent_normal_z);
    
    vertex_position_3d(_vertexBuffer, _a1_x, _a1_y, _a1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _bitangent_normal_x, _bitangent_normal_y, _bitangent_normal_z);
    vertex_position_3d(_vertexBuffer, _c2_x, _c2_y, _c2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _bitangent_normal_x, _bitangent_normal_y, _bitangent_normal_z);
    vertex_position_3d(_vertexBuffer, _a2_x, _a2_y, _a2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _bitangent_normal_x, _bitangent_normal_y, _bitangent_normal_z);
    
    //Bottom
    _bitangent_normal_x *= -1;
    _bitangent_normal_y *= -1;
    _bitangent_normal_z *= -1;
    
    vertex_position_3d(_vertexBuffer, _b1_x, _b1_y, _b1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _bitangent_normal_x, _bitangent_normal_y, _bitangent_normal_z);
    vertex_position_3d(_vertexBuffer, _d1_x, _d1_y, _d1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _bitangent_normal_x, _bitangent_normal_y, _bitangent_normal_z);
    vertex_position_3d(_vertexBuffer, _d2_x, _d2_y, _d2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _bitangent_normal_x, _bitangent_normal_y, _bitangent_normal_z);
    
    vertex_position_3d(_vertexBuffer, _b1_x, _b1_y, _b1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _bitangent_normal_x, _bitangent_normal_y, _bitangent_normal_z);
    vertex_position_3d(_vertexBuffer, _d2_x, _d2_y, _d2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _bitangent_normal_x, _bitangent_normal_y, _bitangent_normal_z);
    vertex_position_3d(_vertexBuffer, _b2_x, _b2_y, _b2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _bitangent_normal_x, _bitangent_normal_y, _bitangent_normal_z);
    
    
    
    //Rear
    vertex_position_3d(_vertexBuffer, _a1_x, _a1_y, _a1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _tangent_normal_x, _tangent_normal_y, _tangent_normal_z);
    vertex_position_3d(_vertexBuffer, _a2_x, _a2_y, _a2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _tangent_normal_x, _tangent_normal_y, _tangent_normal_z);
    vertex_position_3d(_vertexBuffer, _b2_x, _b2_y, _b2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _tangent_normal_x, _tangent_normal_y, _tangent_normal_z);
    
    vertex_position_3d(_vertexBuffer, _a1_x, _a1_y, _a1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _tangent_normal_x, _tangent_normal_y, _tangent_normal_z);
    vertex_position_3d(_vertexBuffer, _b2_x, _b2_y, _b2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _tangent_normal_x, _tangent_normal_y, _tangent_normal_z);
    vertex_position_3d(_vertexBuffer, _b1_x, _b1_y, _b1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _tangent_normal_x, _tangent_normal_y, _tangent_normal_z);
    
    //Front
    _delta_normal_x *= -1;
    _delta_normal_y *= -1;
    _delta_normal_z *= -1;
    
    vertex_position_3d(_vertexBuffer, _c1_x, _c1_y, _c1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _tangent_normal_x, _tangent_normal_y, _tangent_normal_z);
    vertex_position_3d(_vertexBuffer, _c2_x, _c2_y, _c2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _tangent_normal_x, _tangent_normal_y, _tangent_normal_z);
    vertex_position_3d(_vertexBuffer, _d2_x, _d2_y, _d2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _tangent_normal_x, _tangent_normal_y, _tangent_normal_z);
    
    vertex_position_3d(_vertexBuffer, _c1_x, _c1_y, _c1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _tangent_normal_x, _tangent_normal_y, _tangent_normal_z);
    vertex_position_3d(_vertexBuffer, _d2_x, _d2_y, _d2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _tangent_normal_x, _tangent_normal_y, _tangent_normal_z);
    vertex_position_3d(_vertexBuffer, _d1_x, _d1_y, _d1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _tangent_normal_x, _tangent_normal_y, _tangent_normal_z);
    
    
    
    //B cap
    vertex_position_3d(_vertexBuffer, _a2_x, _a2_y, _a2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _delta_normal_x, _delta_normal_y, _delta_normal_z);
    vertex_position_3d(_vertexBuffer, _b2_x, _b2_y, _b2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _delta_normal_x, _delta_normal_y, _delta_normal_z);
    vertex_position_3d(_vertexBuffer, _d2_x, _d2_y, _d2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _delta_normal_x, _delta_normal_y, _delta_normal_z);
    
    vertex_position_3d(_vertexBuffer, _a2_x, _a2_y, _a2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _delta_normal_x, _delta_normal_y, _delta_normal_z);
    vertex_position_3d(_vertexBuffer, _d2_x, _d2_y, _d2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _delta_normal_x, _delta_normal_y, _delta_normal_z);
    vertex_position_3d(_vertexBuffer, _c2_x, _c2_y, _c2_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _delta_normal_x, _delta_normal_y, _delta_normal_z);
    
    //A cap
    _delta_normal_x *= -1;
    _delta_normal_y *= -1;
    _delta_normal_z *= -1;
    
    vertex_position_3d(_vertexBuffer, _a1_x, _a1_y, _a1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _delta_normal_x, _delta_normal_y, _delta_normal_z);
    vertex_position_3d(_vertexBuffer, _b1_x, _b1_y, _b1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _delta_normal_x, _delta_normal_y, _delta_normal_z);
    vertex_position_3d(_vertexBuffer, _d1_x, _d1_y, _d1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _delta_normal_x, _delta_normal_y, _delta_normal_z);
    
    vertex_position_3d(_vertexBuffer, _a1_x, _a1_y, _a1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _delta_normal_x, _delta_normal_y, _delta_normal_z);
    vertex_position_3d(_vertexBuffer, _d1_x, _d1_y, _d1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _delta_normal_x, _delta_normal_y, _delta_normal_z);
    vertex_position_3d(_vertexBuffer, _c1_x, _c1_y, _c1_z); vertex_color(_vertexBuffer, _color, 1.0); vertex_normal(_vertexBuffer, _delta_normal_x, _delta_normal_y, _delta_normal_z);
    
    #endregion
    
    
    
    vertex_end(_vertexBuffer);
    
    shader_set(__shdBonk);
    vertex_submit(_vertexBuffer, pr_trianglelist, -1);
    shader_reset();
    
    vertex_delete_buffer(_vertexBuffer);
}