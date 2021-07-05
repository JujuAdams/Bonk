/// @param x
/// @param y
/// @param z
/// @param [color]

function BonkDebugDrawPoint(_x, _y, _z, _color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
{
    return BonkDebugDrawSphere(_x, _y, _z, BONK_DRAW_POINT_RADIUS, _color);
}