#macro  __BONK_VERSION  "0.0.0"
#macro  __BONK_DATE     "2021-07-04"

__BonkTrace("Welcome to Bonk by @jujuadams! This is version ", __BONK_VERSION, " ", __BONK_DATE);



vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
vertex_format_add_normal();
global.__bonkVertexFormat = vertex_format_end();

global.__bonkErrorLevel = BONK_DEFAULT_ERROR_LEVEL;



enum __BONK_TYPE
{
    POINT,
    SPHERE,
    RAY,
    PLANE,
    AABB,
    TRIANGLE,
    QUAD,
    CAPSULE,
    OBB,
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
shader_reset();



function __BonkTrace()
{
    var _string = "Bonk: ";
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
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
        case __BONK_TYPE.POINT:  return __CollisionWithPoint( _other); break;
        case __BONK_TYPE.SPHERE: return __CollisionWithSphere(_other); break;
        case __BONK_TYPE.RAY:    return __CollisionWithRay(   _other); break;
        case __BONK_TYPE.AABB:   return __CollisionWithAABB(  _other); break;
        
        default:
            switch(global.__bonkErrorLevel)
            {
                case __BONK_ERROR_LEVEL.FATAL:   __BonkError("Unsupported collision, self=", self, ", other=", _other); break;
                case __BONK_ERROR_LEVEL.WARNING: __BonkTrace("Unsupported collision, self=", self, ", other=", _other); break;
            }
            
            return new BonkResult();
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
