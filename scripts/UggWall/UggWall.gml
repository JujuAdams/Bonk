/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [color]

function UggWall(_x1, _y1, _z1, _x2, _y2, _z2, _color = UGG_DEFAULT_DIFFUSE_COLOR) 
{
    UggQuad(_x2, _y2, _z1,   _x2, _y2, _z2,   _x1, _y1, _z1,   _color);
}
