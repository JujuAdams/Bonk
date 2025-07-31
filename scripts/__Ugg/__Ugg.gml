// Feather disable all

#macro __UGG_GLOBAL  static _global = __Ugg();

#macro __UGG_COLOR_UNIFORMS  static _shdUggVolume_u_vColor    = shader_get_uniform(__shdUggVolume, "u_vColor");\
                             static _shdUggWireframe_u_vColor = shader_get_uniform(__shdUggWireframe, "u_vColor");

#macro __UGG_WIREFRAME    (UGG_FORCE_WIREFRAME ?? _global.__wireframe)
#macro __UGG_USE_SHADERS  (UGG_FORCE_USE_SHADERS ?? _global.__useShaders)

#macro __UGG_WIREFRAME_SHADER  if (__UGG_USE_SHADERS)\
                               {\
                                   shader_set(__shdUggWireframe);\
                                   shader_set_uniform_f(_shdUggWireframe_u_vColor, color_get_red(_color), color_get_green(_color), color_get_blue(_color));\
                               }\
                               else if (UGG_SET_FOG_TO_COLOR)\
                               {\
                                   gpu_set_fog(true, _color, 0, 0);\
                               }

#macro __UGG_VOLUME_SHADER  if (__UGG_USE_SHADERS)\
                            {\
                                shader_set(__shdUggVolume);\
                                shader_set_uniform_f(_shdUggVolume_u_vColor, color_get_red(_color), color_get_green(_color), color_get_blue(_color));\
                            }\
                            else if (UGG_SET_FOG_TO_COLOR)\
                            {\
                                gpu_set_fog(true, _color, 0, 0);\
                            }

#macro __UGG_RESET_SHADER  if (__UGG_USE_SHADERS)\
                           {\
                               shader_reset();\
                           }\
                           else if (UGG_SET_FOG_TO_COLOR)\
                           {\
                               gpu_set_fog(false, c_black, 0, 16000);\
                           }
__Ugg();

function __Ugg()
{
    static _global = undefined;
    if (_global != undefined) return _global;
    
    _global = {};
    with(_global)
    {
        show_debug_message($"Welcome to Ugg by Juju Adams! This is version {UGG_VERSION}, {UGG_DATE}");
        __wireframe = false;
        
        __useShaders = true;
        
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_normal();
        vertex_format_add_color();
        vertex_format_add_texcoord();
        __nativeVertexFormat = vertex_format_end();
        
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_normal();
        __volumeVertexFormat = vertex_format_end();
        
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_color();
        __wireframeVertexFormat = vertex_format_end();
    
        __volumeAABB        = __UggPrebuildVolumeAABB(-0.5, -0.5, -0.5, 0.5, 0.5, 0.5);
        __volumeCapsuleBody = __UggPrebuildVolumeCapsuleBody(UGG_CAPSULE_STEPS);
        __volumeCapsuleCap  = __UggPrebuildVolumeCapsuleCap(UGG_CAPSULE_STEPS);
        __volumeCircle      = __UggPrebuildVolumeCircle(UGG_CIRCLE_STEPS);
        __volumeCone        = __UggPrebuildVolumeCone(UGG_CONE_STEPS);
        __volumeCylinder    = __UggPrebuildVolumeCylinder(UGG_CYLINDER_STEPS);
        __volumeLine        = __UggPrebuildVolumeAABB(-0.5, -0.5,  0.0, 0.5, 0.5, 1.0);
        __volumePlane       = __UggPrebuildVolumePlane(UGG_PLANE_SIZE);
        __volumePoint       = __UggPrebuildVolumeSphere(2);
        __volumePyramid     = __UggPrebuildVolumePyramid();
        __volumeSphere      = __UggPrebuildVolumeSphere(UGG_SPHERE_STEPS);
        
        __nativeAABB        = __UggConvertVolumeToNative(__volumeAABB       );
        __nativeCapsuleBody = __UggConvertVolumeToNative(__volumeCapsuleBody);
        __nativeCapsuleCap  = __UggConvertVolumeToNative(__volumeCapsuleCap );
        __nativeCircle      = __UggConvertVolumeToNative(__volumeCircle     );
        __nativeCone        = __UggConvertVolumeToNative(__volumeCone       );
        __nativeCylinder    = __UggConvertVolumeToNative(__volumeCylinder   );
        __nativeLine        = __UggConvertVolumeToNative(__volumeLine       );
        __nativePlane       = __UggConvertVolumeToNative(__volumePlane      );
        __nativePoint       = __UggConvertVolumeToNative(__volumePoint      );
        __nativePyramid     = __UggConvertVolumeToNative(__volumePyramid    );
        __nativeSphere      = __UggConvertVolumeToNative(__volumeSphere     );
        
        vertex_freeze(__volumeAABB       );
        vertex_freeze(__volumeCapsuleBody);
        vertex_freeze(__volumeCapsuleCap );
        vertex_freeze(__volumeCircle     );
        vertex_freeze(__volumeCone       );
        vertex_freeze(__volumeCylinder   );
        vertex_freeze(__volumeLine       );
        vertex_freeze(__volumePlane      );
        vertex_freeze(__volumePoint      );
        vertex_freeze(__volumePyramid    );
        vertex_freeze(__volumeSphere     );
        
        __wireframeAABB        = __UggPrebuildWireframeAABB(-0.5, -0.5, -0.5, 0.5, 0.5, 0.5);
        __wireframeCapsuleBody = __UggPrebuildWireframeCapsuleBody(UGG_CAPSULE_STEPS, 6);
        __wireframeCapsuleCap  = __UggPrebuildWireframeCapsuleCap(UGG_CAPSULE_STEPS, 6);
        __wireframeCircle      = __UggPrebuildWireframeCircle(UGG_CIRCLE_STEPS);
        __wireframeCone        = __UggPrebuildWireframeCone(UGG_CONE_STEPS, 8);
        __wireframeCylinder    = __UggPrebuildWireframeCylinder(UGG_CYLINDER_STEPS, 8);
        __wireframePlane       = __UggPrebuildWireframePlane(UGG_PLANE_SIZE, 8);
        __wireframePoint       = __UggPrebuildWireframeSphere(4, 4, 1, 1);
        __wireframePyramid     = __UggPrebuildWireframePyramid();
        __wireframeSphere      = __UggPrebuildWireframeSphere(UGG_SPHERE_STEPS, 6, 1, 3);
    }
    
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
    shader_set_uniform_f(shader_get_uniform(__shdUggVolume, "u_vColor"), color_get_red(  UGG_DEFAULT_DIFFUSE_COLOR),
                                                                         color_get_green(UGG_DEFAULT_DIFFUSE_COLOR),
                                                                         color_get_blue( UGG_DEFAULT_DIFFUSE_COLOR));
    shader_reset();
    
    
    
    shader_set(__shdUggWireframe);
    shader_set_uniform_f(shader_get_uniform(__shdUggWireframe, "u_vColor"), color_get_red(  UGG_DEFAULT_DIFFUSE_COLOR),
                                                                            color_get_green(UGG_DEFAULT_DIFFUSE_COLOR),
                                                                            color_get_blue( UGG_DEFAULT_DIFFUSE_COLOR));
    shader_reset();
    
    return _global;
}