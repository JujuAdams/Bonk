

#macro __UGG_GLOBAL  static _global = __Ugg();
#macro __UGG_COLOR_UNIFORMS  static _shdUggVolume_u_vColor    = shader_get_uniform(__shdUggVolume, "u_vColor");\
                             static _shdUggWireframe_u_vColor = shader_get_uniform(__shdUggWireframe, "u_vColor");



__Ugg();

function __Ugg()
{
    static _global = undefined;
    if (_global != undefined) return _global;
    _global = {};
    
    show_debug_message($"Welcome to Ugg by Juju Adams! This is version {UGG_VERSION}, {UGG_DATE}");
    
    
    
    _global.__wireframe = false;
    
    vertex_format_begin();
    vertex_format_add_position_3d();
    vertex_format_add_normal();
    _global.__volumeVertexFormat = vertex_format_end();
    
    vertex_format_begin();
    vertex_format_add_position_3d();
    vertex_format_add_color();
    _global.__wireframeVertexFormat = vertex_format_end();
    
    
    
    _global.__volumeSphere      = __UggPrebuildVolumeSphere(UGG_SPHERE_STEPS);
    _global.__volumePoint       = __UggPrebuildVolumeSphere(2);
    _global.__volumeCylinder    = __UggPrebuildVolumeCylinder(UGG_CYLINDER_STEPS);
    _global.__volumeCone        = __UggPrebuildVolumeCone();
    _global.__volumePyramid     = __UggPrebuildVolumePyramid();
    _global.__volumeAABB        = __UggPrebuildVolumeAABB(-0.5, -0.5, -0.5, 0.5, 0.5, 0.5);
    _global.__volumeLine        = __UggPrebuildVolumeAABB(-0.5, -0.5,  0.0, 0.5, 0.5, 1.0);
    _global.__volumePlane       = __UggPrebuildVolumePlane(UGG_PLANE_SIZE);
    _global.__volumeCapsuleCap  = __UggPrebuildVolumeCapsuleCap(UGG_CAPSULE_STEPS);
    _global.__volumeCapsuleBody = __UggPrebuildVolumeCapsuleBody(UGG_CAPSULE_STEPS);
    
    
    
    _global.__wireframeSphere      = __UggPrebuildWireframeSphere(UGG_SPHERE_STEPS);
    _global.__wireframePoint       = __UggPrebuildWireframeSphere(2);
    _global.__wireframeCylinder    = __UggPrebuildWireframeCylinder(UGG_CYLINDER_STEPS);
    _global.__wireframeCone        = __UggPrebuildWireframeCone();
    _global.__wireframePyramid     = __UggPrebuildWireframePyramid();
    _global.__wireframeAABB        = __UggPrebuildWireframeAABB(-0.5, -0.5, -0.5, 0.5, 0.5, 0.5);
    _global.__wireframePlane       = __UggPrebuildWireframePlane(UGG_PLANE_SIZE, 8);
    _global.__wireframeCapsuleCap  = __UggPrebuildWireframeCapsuleCap(UGG_CAPSULE_STEPS);
    _global.__wireframeCapsuleBody = __UggPrebuildWireframeCapsuleBody(UGG_CAPSULE_STEPS);
    
    
    
    shader_set(__shdUggVolume);
    shader_set_uniform_f(shader_get_uniform(__shdUggVolume, "u_vAmbientColor"),
                         color_get_red(  UGG_AMBIENT_LIGHT_COLOR)/255,
                         color_get_green(UGG_AMBIENT_LIGHT_COLOR)/255,
                         color_get_blue( UGG_AMBIENT_LIGHT_COLOR)/255);
    
    shader_set_uniform_f(shader_get_uniform(__shdUggVolume, "u_vDirectLightColor"),
                         color_get_red(  UGG_LIGHT_COLOR)/255,
                         color_get_green(UGG_LIGHT_COLOR)/255,
                         color_get_blue( UGG_LIGHT_COLOR)/255);
    
    var _inverseLength = 1/sqrt(UGG_LIGHT_DIRECTION_X*UGG_LIGHT_DIRECTION_X
                              + UGG_LIGHT_DIRECTION_Y*UGG_LIGHT_DIRECTION_Y
                              + UGG_LIGHT_DIRECTION_Z*UGG_LIGHT_DIRECTION_Z);
    var _directionX = UGG_LIGHT_DIRECTION_X*_inverseLength;
    var _directionY = UGG_LIGHT_DIRECTION_Y*_inverseLength;
    var _directionZ = UGG_LIGHT_DIRECTION_Z*_inverseLength;
    
    shader_set_uniform_f(shader_get_uniform(__shdUggVolume, "u_vDirectLightDirection"), _directionX, _directionY, _directionZ);
    shader_set_uniform_f(shader_get_uniform(__shdUggVolume, "u_vColor"), color_get_red(  UGG_DEFAULT_DIFFUSE_COLOR)/255,
                                                                         color_get_green(UGG_DEFAULT_DIFFUSE_COLOR)/255,
                                                                         color_get_blue( UGG_DEFAULT_DIFFUSE_COLOR)/255);
    shader_reset();
    
    
    
    shader_set(__shdUggWireframe);
    shader_set_uniform_f(shader_get_uniform(__shdUggWireframe, "u_vColor"), color_get_red(  UGG_DEFAULT_DIFFUSE_COLOR)/255,
                                                                       color_get_green(UGG_DEFAULT_DIFFUSE_COLOR)/255,
                                                                       color_get_blue( UGG_DEFAULT_DIFFUSE_COLOR)/255);
    shader_reset();
    
    
    
    return _global;
}