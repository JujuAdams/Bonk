/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param radius
/// @param [color]

function BonkDebugDrawCapsule(_x1, _y1, _z1, _x2, _y2, _z2, _radius, _color = BONK_DRAW_DEFAULT_DIFFUSE_COLOR)
{
    //FIXME - Do this properly
    BonkDebugDrawSphere(_x1, _y1, _z1, _radius, _color);
    BonkDebugDrawSphere(_x2, _y2, _z2, _radius, _color);
    BonkDebugDrawCylinder(0.5*(_x1 + _x2), 0.5*(_y1 + _y2), 0.5*(_z1 + _z2), abs(_z2 - _z1), _radius, _color);
}