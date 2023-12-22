/// @param x
/// @param y
/// @param z
/// @param xNormal
/// @param yNormal
/// @param zNormal
/// @param [color]

function BonkDebugDrawQuad(_x, _y, _z, _xNormal, _yNormal, _zNormal, _color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
{
    __BONK_GLOBAL
    
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin( _vertexBuffer, _global.__bonkVertexFormat);
    
    var _position = [_x, _y, _z];
    var _normal = BonkVecNormalize([_xNormal, _yNormal, _zNormal]);
    
    if (!BonkVecEqual(_normal, [0, 0, 1]) && !BonkVecEqual(_normal, [0, 0, -1]))
    {
        var _tangent = BonkVecCross(_normal, [0, 0, 1]);
    }
    else
    {
        var _tangent = BonkVecCross(_normal, [1, 0, 0]);
    }
    
    var _bitangent = BonkVecCross(_normal, _tangent);
    
    _tangent   = BonkVecMultiply(_tangent,   BONK_DRAW_PLANE_SIZE);
    _bitangent = BonkVecMultiply(_bitangent, BONK_DRAW_PLANE_SIZE);
    
    var _a = BonkVecAdd(     BonkVecAdd(     _position, _tangent), _bitangent);
    var _b = BonkVecAdd(     BonkVecSubtract(_position, _tangent), _bitangent);
    var _c = BonkVecSubtract(BonkVecAdd(     _position, _tangent), _bitangent);
    var _d = BonkVecSubtract(BonkVecSubtract(_position, _tangent), _bitangent);
    
    vertex_position_3d(_vertexBuffer, _a[0], _a[1], _a[2]); vertex_normal(_vertexBuffer, _xNormal, _yNormal, _zNormal);
    vertex_position_3d(_vertexBuffer, _b[0], _b[1], _b[2]); vertex_normal(_vertexBuffer, _xNormal, _yNormal, _zNormal);
    vertex_position_3d(_vertexBuffer, _d[0], _d[1], _d[2]); vertex_normal(_vertexBuffer, _xNormal, _yNormal, _zNormal);
    
    vertex_position_3d(_vertexBuffer, _a[0], _a[1], _a[2]); vertex_normal(_vertexBuffer, _xNormal, _yNormal, _zNormal);
    vertex_position_3d(_vertexBuffer, _d[0], _d[1], _d[2]); vertex_normal(_vertexBuffer, _xNormal, _yNormal, _zNormal);
    vertex_position_3d(_vertexBuffer, _c[0], _c[1], _c[2]); vertex_normal(_vertexBuffer, _xNormal, _yNormal, _zNormal);
    
    vertex_end(_vertexBuffer);
    
    shader_set(__shdBonk);
    shader_set_uniform_f(_global.__bonkUniform_shdBonk_u_vColor, color_get_red(  _color)/255,
                                                                 color_get_green(_color)/255,
                                                                 color_get_blue( _color)/255);
    vertex_submit(_vertexBuffer, pr_trianglelist, -1);
    shader_reset();
    
    vertex_delete_buffer(_vertexBuffer);
}