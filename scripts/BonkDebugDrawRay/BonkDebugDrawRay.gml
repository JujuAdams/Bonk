/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [color]

function BonkDebugDrawRay(_x1, _y1, _z1, _x2, _y2, _z2, _color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
{
    var _dx = _x2 - _x1;
    var _dy = _y2 - _y1;
    var _dz = _z2 - _z1;
    
    var _length = sqrt(_dx*_dx + _dy*_dy + _dz*_dz);
    if (_length == 0) return false;

    var _plane_length = sqrt(_dx*_dx + _dy*_dy);
    var _z_angle = point_direction(0, 0, _plane_length, _dz);
    var _p_angle = point_direction(0, 0, _dx, _dy);
    
    var _matrix = matrix_build(0,0,0,   0,0,0,   BONK_DRAW_RAY_THICKNESS, BONK_DRAW_RAY_THICKNESS, _length);
    _matrix = matrix_multiply(_matrix, matrix_build(0,0,0,   0, -90 - _z_angle, 0,   1,1,1));
    _matrix = matrix_multiply(_matrix, matrix_build(0,0,0,   0, 0, _p_angle,   1,1,1));
    _matrix = matrix_multiply(_matrix, matrix_build(_x1, _y1, _z1,   0,0,0,   1,1,1));
    
    matrix_set(matrix_world, _matrix);
    
    shader_set(__shdBonk);
    shader_set_uniform_f(global.__bonkUniform_shdBonk_u_vColor, color_get_red(  _color)/255,
                                                                color_get_green(_color)/255,
                                                                color_get_blue( _color)/255);
    vertex_submit(global.__bonkRay, pr_trianglelist, -1);
    shader_reset();
    
    matrix_set(matrix_world, matrix_build_identity());
}