#macro  BONK_MINIMUM_COLLISION_DEPTH  1

// The default error level in effect if BonkSetErrorLevel() hasn't been called
// Three values are supported:
// 0: No warnings or errors
// 1: Recoverable issues will be outputted to the debug log
// 2: Recoverable issues will result in an error
#macro  BONK_DEFAULT_ERROR_LEVEL  2



#region Debug Draw

#macro  BONK_DRAW_POINT_RADIUS          2
#macro  BONK_DRAW_SPHERE_STEPS          24
#macro  BONK_DRAW_RAY_THICKNESS         2
#macro  BONK_DRAW_RESULT_NORMAL_LENGTH  100
#macro  BONK_DRAW_PLANE_DEFAULT_COLOR   c_gray
#macro  BONK_DRAW_PLANE_SIZE            1000

#macro  BONK_DRAW_DEFAULT_DIFFUSE_COLOR  c_white
#macro  BONK_DRAW_AMBIENT_LIGHT_COLOR    c_gray
#macro  BONK_DRAW_LIGHT_COLOR            c_white
#macro  BONK_DRAW_LIGHT_DIRECTION_X      1
#macro  BONK_DRAW_LIGHT_DIRECTION_Y      1
#macro  BONK_DRAW_LIGHT_DIRECTION_Z      1

#endregion