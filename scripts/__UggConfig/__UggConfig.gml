//Size of `UggPoint()`.
#macro UGG_POINT_RADIUS  2

//Default thickness of `UggLine()`.
#macro UGG_LINE_THICKNESS  2

//Number of facets on smooth shapes. Higher numbers are smoother, lower numbers are faser.
#macro UGG_SPHERE_STEPS    24
#macro UGG_CYLINDER_STEPS  24
#macro UGG_CONE_STEPS      24
#macro UGG_CAPSULE_STEPS   24

//Size of `UggPlane()`. Planes will follow the camera; this value will usually want to be equal to
//your projection's z-far.
#macro UGG_PLANE_SIZE  10_000

//Default base colour for Ugg's shapes.
#macro UGG_DEFAULT_DIFFUSE_COLOR  c_white

//Parameters for Ugg's in-built light source. This light is used to give extra depth to shapes
//which helps with legibility. Set both `UGG_AMBIENT_LIGHT_COLOR` and `UGG_LIGHT_COLOR` to
//`c_white` to turn off lighting entirely.
#macro UGG_AMBIENT_LIGHT_COLOR    c_gray
#macro UGG_LIGHT_COLOR            c_white
#macro UGG_LIGHT_DIRECTION_X      -0.4
#macro UGG_LIGHT_DIRECTION_Y      -0.6
#macro UGG_LIGHT_DIRECTION_Z      -0.8