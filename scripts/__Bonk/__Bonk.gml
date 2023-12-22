#macro  __BONK_VERSION  "1.0.0"
#macro  __BONK_DATE     "2023-12-22"

#macro __BONK_VERY_LARGE  1000000
#macro __BONK_GLOBAL  static _global = __Bonk();



__Bonk();

function __Bonk()
{
    static _global = undefined;
    if (_global != undefined) return _global;
    _global = {};
    
    __BonkTrace("Welcome to Bonk by Juju Adams! This is version ", __BONK_VERSION, " ", __BONK_DATE);
    
    vertex_format_begin();
    vertex_format_add_position_3d();
    vertex_format_add_normal();
    _global.__bonkVertexFormat = vertex_format_end();
    
    _global.__bonkUniform_shdBonk_u_vColor = shader_get_uniform(__shdBonk, "u_vColor");
    
    _global.__bonkSphere   = __BonkPrebuildSphere();
    _global.__bonkCylinder = __BonkPrebuildCylinder();
    _global.__bonkAABB     = __BonkPrebuildAABB(-0.5, -0.5, -0.5, 0.5, 0.5, 0.5);
    _global.__bonkRay      = __BonkPrebuildAABB(-0.5, -0.5,  0.0, 0.5, 0.5, 1.0);
    
    _global.__bonkIdentityMatrix = matrix_build_identity();
    
    
    
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
    shader_set_uniform_f(_global.__bonkUniform_shdBonk_u_vColor, color_get_red(  BONK_DRAW_DEFAULT_DIFFUSE_COLOR)/255,
                                                                 color_get_green(BONK_DRAW_DEFAULT_DIFFUSE_COLOR)/255,
                                                                 color_get_blue( BONK_DRAW_DEFAULT_DIFFUSE_COLOR)/255);
    shader_reset();
    
    return _global;
}