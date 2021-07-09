/// @param x
/// @param y
/// @param z
/// @param radius
/// @param [color]

function BonkDebugDrawSphere(_x, _y, _z, _radius, _color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
{
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin(_vertexBuffer, global.__bonkVertexFormat);
    
    var _rows = 0.5*BONK_DRAW_SPHERE_STEPS + 0.5;
    
    // Create sin and cos tables
    var _cc;
    var _ss;
    _cc[BONK_DRAW_SPHERE_STEPS] = 0;
    _ss[BONK_DRAW_SPHERE_STEPS] = 0;
    
    for( var _i = 0; _i <= BONK_DRAW_SPHERE_STEPS; _i++)
    {
        var _rad = _i*360/BONK_DRAW_SPHERE_STEPS;
        _cc[_i] = dcos(_rad);
        _ss[_i] = dsin(_rad);
    }
    
    var _vbuff = vertex_create_buffer();
    vertex_begin( _vbuff, global.__bonkVertexFormat);
    
    for(var _j = 0; _j < _rows; _j++)
    {
        var _row1rad = (_j  )*180/_rows;
        var _row2rad = (_j+1)*180/_rows;
        var _rh1 = dcos(_row1rad);
        var _rd1 = dsin(_row1rad);
        var _rh2 = dcos(_row2rad);
        var _rd2 = dsin(_row2rad);
        
        var _i = 0;
        var _this_a = [_rd1*_cc[_i], _rd1*_ss[_i], _rh1,    _rd1*_cc[_i], _rd1*_ss[_i], _rh1];
        var _this_b = [_rd2*_cc[_i], _rd2*_ss[_i], _rh2,    _rd2*_cc[_i], _rd2*_ss[_i], _rh2];
        
        for( var _i = 1; _i <= BONK_DRAW_SPHERE_STEPS; _i++ )
        {
            var _prev_a = _this_a;
            var _prev_b = _this_b;
            
            var _this_a = [_rd1*_cc[_i], _rd1*_ss[_i], _rh1,    _rd1*_cc[_i], _rd1*_ss[_i], _rh1];
            var _this_b = [_rd2*_cc[_i], _rd2*_ss[_i], _rh2,    _rd2*_cc[_i], _rd2*_ss[_i], _rh2];
            
            vertex_position_3d(_vertexBuffer, _prev_a[0], _prev_a[1], _prev_a[2]); vertex_normal(_vertexBuffer, _prev_a[3], _prev_a[4], _prev_a[5]);
            vertex_position_3d(_vertexBuffer, _prev_b[0], _prev_b[1], _prev_b[2]); vertex_normal(_vertexBuffer, _prev_b[3], _prev_b[4], _prev_b[5]);
            vertex_position_3d(_vertexBuffer, _this_a[0], _this_a[1], _this_a[2]); vertex_normal(_vertexBuffer, _this_a[3], _this_a[4], _this_a[5]);
            
            vertex_position_3d(_vertexBuffer, _prev_b[0], _prev_b[1], _prev_b[2]); vertex_normal(_vertexBuffer, _prev_b[3], _prev_b[4], _prev_b[5]);
            vertex_position_3d(_vertexBuffer, _this_b[0], _this_b[1], _this_b[2]); vertex_normal(_vertexBuffer, _this_b[3], _this_b[4], _this_b[5]);
            vertex_position_3d(_vertexBuffer, _this_a[0], _this_a[1], _this_a[2]); vertex_normal(_vertexBuffer, _this_a[3], _this_a[4], _this_a[5]);
        }
    }
    
    vertex_end(_vertexBuffer);
    
    matrix_set(matrix_world, matrix_build(_x, _y, _z,   0, 0, 0,   _radius, _radius, _radius));
    
    shader_set(__shdBonk);
    shader_set_uniform_f(global.__bonkUniform_shdBonk_u_vColor, color_get_red(  _color)/255,
                                                                color_get_green(_color)/255,
                                                                color_get_blue( _color)/255);
    vertex_submit(_vertexBuffer, pr_trianglelist, -1);
    
    shader_reset();
    matrix_set(matrix_world, matrix_build_identity());
    
    vertex_delete_buffer(_vertexBuffer);
}