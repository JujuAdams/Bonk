/// Draws an axis-aligned bounding box
/// 
/// @param xCentre  x-coordinate of the centre of the AABB
/// @param yCentre  y-coordinate of the centre of the AABB
/// @param zCentre  z-coordinate of the centre of the AABB
/// @param xSize    Size of the AABB in the x-axis
/// @param ySize    Size of the AABB in the y-axis
/// @param zSize    Size of the AABB in the z-axis
/// @param [color]  Colour of the AABB (standard GameMaker 24-integer)

function BonkDebugDrawAABB(_x, _y, _z, _xSize, _ySize, _zSize, _color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
{
    matrix_set(matrix_world, matrix_build(_x, _y, _z,   0, 0, 0,   _xSize, _ySize, _zSize));
    
    shader_set(__shdBonk);
    shader_set_uniform_f(global.__bonkUniform_shdBonk_u_vColor, color_get_red(  _color)/255,
                                                                color_get_green(_color)/255,
                                                                color_get_blue( _color)/255);
    vertex_submit(global.__bonkAABB, pr_trianglelist, -1);
    shader_reset();
    
    matrix_set(matrix_world, matrix_build_identity());
}