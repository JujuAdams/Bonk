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

global.__bonkSphere   = __BonkPrebuildSphere();
global.__bonkCylinder = __BonkPrebuildCylinder();
global.__bonkAABB     = __BonkPrebuildAABB(-0.5, -0.5, -0.5, 0.5, 0.5, 0.5);
global.__bonkRay      = __BonkPrebuildAABB(-0.5, -0.5,  0.0, 0.5, 0.5, 1.0);



enum __BONK_TYPE
{
    POINT,
    SPHERE,
    RAY,
    PLANE,
    AABB,
    CYLINDER,
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
        case __BONK_TYPE.CYLINDER: return __CollisionWithCylinder(_other); break;
        
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



function __BonkPrebuildCylinder()
{
    var _x1 = -1;
    var _y1 = -1;
    var _z1 = -0.5;
    var _x2 = 1;
    var _y2 = 1;
    var _z2 = 0.5;
    
	var _cc = array_create(BONK_DRAW_CYLINDER_STEPS, 0);
	var _ss = array_create(BONK_DRAW_CYLINDER_STEPS, 0);

	for(var _i = 0; _i <= BONK_DRAW_CYLINDER_STEPS; _i++)
	{
		var _deg = 360*_i / BONK_DRAW_CYLINDER_STEPS;
		_cc[_i] = dcos(_deg);
		_ss[_i] = dsin(_deg);
	}

	var _mx = 0.5*( _x2 + _x1 );
	var _my = 0.5*( _y2 + _y1 );
	var _rx = 0.5*( _x2 - _x1 );
	var _ry = 0.5*( _y2 - _y1 );

	var _vertexBuffer = vertex_create_buffer();
	vertex_begin(_vertexBuffer, global.__bonkVertexFormat);
  
	var _bx = _mx + _cc[0]*_rx;
	var _by = _my + _ss[0]*_ry;
    
	for(var _i = 1; _i <= BONK_DRAW_CYLINDER_STEPS; _i++)
	{
	    var _j = (_i+1) mod BONK_DRAW_CYLINDER_STEPS;
    
	    var _ax = _bx;
	    var _ay = _by;
	    var _bx = _mx + _cc[_i]*_rx;
	    var _by = _my + _ss[_i]*_ry;
        
        //Top cap
	    vertex_position_3d(_vertexBuffer, _mx, _my, _z2); vertex_normal(_vertexBuffer, 0, 0,  1);
	    vertex_position_3d(_vertexBuffer, _ax, _ay, _z2); vertex_normal(_vertexBuffer, 0, 0,  1);
	    vertex_position_3d(_vertexBuffer, _bx, _by, _z2); vertex_normal(_vertexBuffer, 0, 0,  1);
        
        //Bottom cap
	    vertex_position_3d(_vertexBuffer, _mx, _my, _z1); vertex_normal(_vertexBuffer, 0, 0, -1);
	    vertex_position_3d(_vertexBuffer, _bx, _by, _z1); vertex_normal(_vertexBuffer, 0, 0, -1);
	    vertex_position_3d(_vertexBuffer, _ax, _ay, _z1); vertex_normal(_vertexBuffer, 0, 0, -1);
        
        //Wall
	    vertex_position_3d(_vertexBuffer, _ax, _ay, _z1); vertex_normal(_vertexBuffer, _cc[_i], _ss[_i], 0);
	    vertex_position_3d(_vertexBuffer, _bx, _by, _z1); vertex_normal(_vertexBuffer, _cc[_j], _ss[_j], 0);
	    vertex_position_3d(_vertexBuffer, _bx, _by, _z2); vertex_normal(_vertexBuffer, _cc[_j], _ss[_j], 0);
        
	    vertex_position_3d(_vertexBuffer, _bx, _by, _z2); vertex_normal(_vertexBuffer, _cc[_j], _ss[_j], 0);
	    vertex_position_3d(_vertexBuffer, _ax, _ay, _z2); vertex_normal(_vertexBuffer, _cc[_i], _ss[_i], 0);
	    vertex_position_3d(_vertexBuffer, _ax, _ay, _z1); vertex_normal(_vertexBuffer, _cc[_i], _ss[_i], 0);
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