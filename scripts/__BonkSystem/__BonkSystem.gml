#macro  __BONK_VERSION  "0.0.0"
#macro  __BONK_DATE     "2021-07-04"

#macro __BONK_VERY_LARGE  1000000

__BonkTrace("Welcome to Bonk by @jujuadams! This is version ", __BONK_VERSION, " ", __BONK_DATE);



vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
global.__bonkVertexFormat = vertex_format_end();

global.__bonkUniform_shdBonk_u_vColor = shader_get_uniform(__shdBonk, "u_vColor");

global.__bonkErrorLevel = BONK_DEFAULT_ERROR_LEVEL;

global.__bonkSphere = __BonkPrebuildSphere();
global.__bonkAABB   = __BonkPrebuildAABB(-0.5, -0.5, -0.5, 0.5, 0.5, 0.5);
global.__bonkRay    = __BonkPrebuildAABB(-0.5, -0.5,  0.0, 0.5, 0.5, 1.0);



enum __BONK_TYPE
{
    POINT,
    SPHERE,
    RAY,
    PLANE,
    AABB,
    OBB,
    CAPSULE,
    TRIANGLE,
    CONVEX,
    __SIZE
}



enum __BONK_ERROR_LEVEL
{
    NONE    = 0,
    WARNING = 1,
    FATAL   = 2,
}



shader_set(__shdBonk);
shader_set_uniform_f(shader_get_uniform(__shdBonk, "u_vAmbientColor"),
                     color_get_red(  BONK_DRAW_AMBIENT_LIGHT_COLOR)/255,
                     color_get_green(BONK_DRAW_AMBIENT_LIGHT_COLOR)/255,
                     color_get_blue( BONK_DRAW_AMBIENT_LIGHT_COLOR)/255);

shader_set_uniform_f(shader_get_uniform(__shdBonk, "u_vDirectLightColor"),
                     color_get_red(  BONK_DRAW_LIGHT_COLOR)/255,
                     color_get_green(BONK_DRAW_LIGHT_COLOR)/255,
                     color_get_blue( BONK_DRAW_LIGHT_COLOR)/255);

var _inverseLength = 1/sqrt(BONK_DRAW_LIGHT_DIRECTION_X*BONK_DRAW_LIGHT_DIRECTION_X
                          + BONK_DRAW_LIGHT_DIRECTION_Y*BONK_DRAW_LIGHT_DIRECTION_Y
                          + BONK_DRAW_LIGHT_DIRECTION_Z*BONK_DRAW_LIGHT_DIRECTION_Z);
var _directionX = BONK_DRAW_LIGHT_DIRECTION_X*_inverseLength;
var _directionY = BONK_DRAW_LIGHT_DIRECTION_Y*_inverseLength;
var _directionZ = BONK_DRAW_LIGHT_DIRECTION_Z*_inverseLength;

shader_set_uniform_f(shader_get_uniform(__shdBonk, "u_vDirectLightDirection"), _directionX, _directionY, _directionZ);
shader_set_uniform_f(global.__bonkUniform_shdBonk_u_vColor, color_get_red(  BONK_DRAW_DEFAULT_DIFFUSE_COLOR)/255,
                                                            color_get_green(BONK_DRAW_DEFAULT_DIFFUSE_COLOR)/255,
                                                            color_get_blue( BONK_DRAW_DEFAULT_DIFFUSE_COLOR)/255);
shader_reset();



function __BonkTrace()
{
    var _string = "Bonk: ";
    var _i = 0;
    repeat(argument_count)
    {
        if (is_numeric(argument[_i]))
        {
            _string += string_format(argument[_i], 0, 7);
        }
        else
        {
            _string += string(argument[_i]);
        }
        
        ++_i;
    }
    
    show_debug_message(_string);
}

function __BonkError()
{
    var _string = "Bonk: ";
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message(_string);
    show_error(_string + "\n ", false);
}



function __BonkSharedCollisionHandler(_other)
{
    if (!variable_struct_exists(_other, "__bonkType"))
    {
        __BonkError("Other is not a Bonk primitive (instanceof = ", instanceof(_other), ")");
    }
    
    switch(_other.__bonkType)
    {
        case __BONK_TYPE.POINT:    return __CollisionWithPoint(   _other); break;
        case __BONK_TYPE.SPHERE:   return __CollisionWithSphere(  _other); break;
        case __BONK_TYPE.RAY:      return __CollisionWithRay(     _other); break;
        case __BONK_TYPE.AABB:     return __CollisionWithAABB(    _other); break;
        case __BONK_TYPE.PLANE:    return __CollisionWithPlane(   _other); break;
        case __BONK_TYPE.TRIANGLE: return __CollisionWithTriangle(_other); break;
        
        default:
            switch(global.__bonkErrorLevel)
            {
                case __BONK_ERROR_LEVEL.FATAL:   __BonkError("Unsupported collision, self=", self, ", other=", _other); break;
                case __BONK_ERROR_LEVEL.WARNING: __BonkTrace("Unsupported collision, self=", self, ", other=", _other); break;
            }
            
            return new BonkResult(false);
        break;
    }
}



/// @param point
/// @param aabbMin
/// @param aabbMax
function __BonkAABBPointInsideMinMax(_point, _min, _max)
{
    if (_point[0] < _min[0]) return false;
    if (_point[1] < _min[1]) return false;
    if (_point[2] < _min[2]) return false;
    if (_point[0] > _max[0]) return false;
    if (_point[1] > _max[1]) return false;
    if (_point[2] > _max[2]) return false;
    
    return true;
}



function __BonkPrebuildSphere()
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
	vertex_freeze(_vertexBuffer);
    
    return _vertexBuffer;
}



function __BonkPrebuildAABB(_x1, _y1, _z1, _x2, _y2, _z2)
{
    var _vertexBuffer = vertex_create_buffer();
    vertex_begin( _vertexBuffer, global.__bonkVertexFormat);
    
    
    
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_normal(_vertexBuffer, -1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z2); vertex_normal(_vertexBuffer, -1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z2); vertex_normal(_vertexBuffer, -1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_normal(_vertexBuffer, -1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z2); vertex_normal(_vertexBuffer, -1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z1); vertex_normal(_vertexBuffer, -1,  0,  0);
    
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z1); vertex_normal(_vertexBuffer,  1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z1); vertex_normal(_vertexBuffer,  1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_normal(_vertexBuffer,  1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z1); vertex_normal(_vertexBuffer,  1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_normal(_vertexBuffer,  1,  0,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z2); vertex_normal(_vertexBuffer,  1,  0,  0);
    
    
    
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_normal(_vertexBuffer,  0, -1,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z2); vertex_normal(_vertexBuffer,  0, -1,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z2); vertex_normal(_vertexBuffer,  0, -1,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_normal(_vertexBuffer,  0, -1,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z1); vertex_normal(_vertexBuffer,  0, -1,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z2); vertex_normal(_vertexBuffer,  0, -1,  0);
    
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z1); vertex_normal(_vertexBuffer,  0,  1,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z2); vertex_normal(_vertexBuffer,  0,  1,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_normal(_vertexBuffer,  0,  1,  0);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z1); vertex_normal(_vertexBuffer,  0,  1,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_normal(_vertexBuffer,  0,  1,  0);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z1); vertex_normal(_vertexBuffer,  0,  1,  0);
    
    
    
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_normal(_vertexBuffer,  0,  0, -1);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z1); vertex_normal(_vertexBuffer,  0,  0, -1);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z1); vertex_normal(_vertexBuffer,  0,  0, -1);
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z1); vertex_normal(_vertexBuffer,  0,  0, -1);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z1); vertex_normal(_vertexBuffer,  0,  0, -1);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z1); vertex_normal(_vertexBuffer,  0,  0, -1);
    
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z2); vertex_normal(_vertexBuffer,  0,  0,  1);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_normal(_vertexBuffer,  0,  0,  1);
    vertex_position_3d(_vertexBuffer, _x1, _y2, _z2); vertex_normal(_vertexBuffer,  0,  0,  1);
    vertex_position_3d(_vertexBuffer, _x1, _y1, _z2); vertex_normal(_vertexBuffer,  0,  0,  1);
    vertex_position_3d(_vertexBuffer, _x2, _y1, _z2); vertex_normal(_vertexBuffer,  0,  0,  1);
    vertex_position_3d(_vertexBuffer, _x2, _y2, _z2); vertex_normal(_vertexBuffer,  0,  0,  1);
    
    
    
    vertex_end(_vertexBuffer);
	vertex_freeze(_vertexBuffer);
    
    return _vertexBuffer;
}



// Support for the static test query.
function __BonkDiskOverlapsPoint(_x, _y, _radius)
{
    return (_x*_x + _y*_y <= _radius*_radius);
}

function __BonkDiskOverlapsSegment(_x0, _y0, _x1, _y1, _radius)
{
    var _sqrRadius = _radius*_radius;
    var _dx = _x0 - _x1;
    var _dy = _y0 - _y1;
    
    var _dot = dot_product(_x0, _y0, _dx, _dy);
    if (_dot <= 0) return (_x0*_x0 + _y0*_y0 <= _sqrRadius);

    var _sqrLength = _dx*_dx + _dy*_dy;
    if (_dot >= _sqrLength) return (_x1*_x1 + _y1*_y1 <= _sqrRadius);

    var _perpDot = _dx*_y0 - _dy*_x0;
    return (_perpDot*_perpDot <= _sqrLength*_sqrRadius);
}

function __BonkDiskOverlapsTriangle(_x0, _y0, _x1, _y1, _x2, _y2, _radius)
{
    //Test whether the polygon contains the origin (0,0)
    var _positive = 0;
    var _negative = 0;
    
    // p0 -> p1
    var _dx = _x0 - _x1;
    var _dy = _y0 - _y1;
    var _perpDot = _x0*_dy - _y0*_dx;
    if (_perpDot > 0) { _positive = true; } else if (_perpDot < 0) { _negative = true; }
    
    // p1 -> p2
    var _dx = _x1 - _x2;
    var _dy = _y1 - _y2;
    var _perpDot = _x1*_dy - _y1*_dx;
    if (_perpDot > 0) { _positive = true; } else if (_perpDot < 0) { _negative = true; }
    
    // p2 -> p1
    var _dx = _x2 - _x0;
    var _dy = _y2 - _y0;
    var _perpDot = _x2*_dy - _y2*_dx;
    if (_perpDot > 0) { _positive = true; } else if (_perpDot < 0) { _negative = true; }
    
    if (!_positive || !_negative) return true;
    
    //Test whether any edge is overlapped by the disk
    if (__BonkDiskOverlapsSegment(_x0, _y0, _x1, _y1, _radius)) return true;
    if (__BonkDiskOverlapsSegment(_x1, _y1, _x2, _y2, _radius)) return true;
    if (__BonkDiskOverlapsSegment(_x2, _y2, _x0, _y0, _radius)) return true;
    
    return false;
}

function __BonkDiskOverlapsQuad(_x0, _y0, _x1, _y1, _x2, _y2, _x3, _y3, _radius)
{
    //Test whether the polygon contains the origin (0,0)
    var _positive = 0;
    var _negative = 0;
    
    // p0 -> p1
    var _dx = _x0 - _x1;
    var _dy = _y0 - _y1;
    var _perpDot = _x0*_dy - _y0*_dx;
    if (_perpDot > 0) { _positive = true; } else if (_perpDot < 0) { _negative = true; }
    
    // p1 -> p2
    var _dx = _x1 - _x2;
    var _dy = _y1 - _y2;
    var _perpDot = _x1*_dy - _y1*_dx;
    if (_perpDot > 0) { _positive = true; } else if (_perpDot < 0) { _negative = true; }
    
    // p2 -> p3
    var _dx = _x2 - _x3;
    var _dy = _y2 - _y3;
    var _perpDot = _x2*_dy - _y2*_dx;
    if (_perpDot > 0) { _positive = true; } else if (_perpDot < 0) { _negative = true; }
    
    // p3 -> p0
    var _dx = _x3 - _x0;
    var _dy = _y3 - _y0;
    var _perpDot = _x3*_dy - _y3*_dx;
    if (_perpDot > 0) { _positive = true; } else if (_perpDot < 0) { _negative = true; }
    
    if (!_positive || !_negative) return true;
    
    //Test whether any edge is overlapped by the disk
    if (__BonkDiskOverlapsSegment(_x0, _y0, _x1, _y1, _radius)) return true;
    if (__BonkDiskOverlapsSegment(_x1, _y1, _x2, _y2, _radius)) return true;
    if (__BonkDiskOverlapsSegment(_x2, _y2, _x3, _y3, _radius)) return true;
    if (__BonkDiskOverlapsSegment(_x3, _y3, _x0, _y0, _radius)) return true;
    
    return false;
}

function __BonkDiskOverlapsPentagon(_x0, _y0, _x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4, _radius)
{
    //Test whether the polygon contains the origin (0,0)
    var _positive = 0;
    var _negative = 0;
    
    // p0 -> p1
    var _dx = _x0 - _x1;
    var _dy = _y0 - _y1;
    var _perpDot = _x0*_dy - _y0*_dx;
    if (_perpDot > 0) { _positive = true; } else if (_perpDot < 0) { _negative = true; }
    
    // p1 -> p2
    var _dx = _x1 - _x2;
    var _dy = _y1 - _y2;
    var _perpDot = _x1*_dy - _y1*_dx;
    if (_perpDot > 0) { _positive = true; } else if (_perpDot < 0) { _negative = true; }
    
    // p2 -> p3
    var _dx = _x2 - _x3;
    var _dy = _y2 - _y3;
    var _perpDot = _x2*_dy - _y2*_dx;
    if (_perpDot > 0) { _positive = true; } else if (_perpDot < 0) { _negative = true; }
    
    // p3 -> p4
    var _dx = _x3 - _x4;
    var _dy = _y3 - _y4;
    var _perpDot = _x3*_dy - _y3*_dx;
    if (_perpDot > 0) { _positive = true; } else if (_perpDot < 0) { _negative = true; }
    
    // p4 -> p0
    var _dx = _x4 - _x0;
    var _dy = _y4 - _y0;
    var _perpDot = _x4*_dy - _y4*_dx;
    if (_perpDot > 0) { _positive = true; } else if (_perpDot < 0) { _negative = true; }
    
    if (!_positive || !_negative) return true;
    
    //Test whether any edge is overlapped by the disk
    if (__BonkDiskOverlapsSegment(_x0, _y0, _x1, _y1, _radius)) return true;
    if (__BonkDiskOverlapsSegment(_x1, _y1, _x2, _y2, _radius)) return true;
    if (__BonkDiskOverlapsSegment(_x2, _y2, _x3, _y3, _radius)) return true;
    if (__BonkDiskOverlapsSegment(_x3, _y3, _x4, _y4, _radius)) return true;
    if (__BonkDiskOverlapsSegment(_x4, _y4, _x0, _y0, _radius)) return true;
    
    return false;
}