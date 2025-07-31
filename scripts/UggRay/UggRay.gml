// Feather disable all

/// Draws a line between two coordinates.
/// 
/// @param x
/// @param y
/// @param z
/// @param dX
/// @param dY
/// @param dZ
/// @param [color]
/// @param [thickness]
/// @param [wireframe}

function UggRay(_x, _y, _z, _dX, _dY, _dZ, _color = UGG_DEFAULT_DIFFUSE_COLOR, _thickness = UGG_LINE_THICKNESS, _wireframe = undefined)
{
    UggLine(_x, _y, _z,   _x + UGG_RAY_LENGTH*_dX, _y + UGG_RAY_LENGTH*_dY, _z + UGG_RAY_LENGTH*_dZ,   _color, _thickness, _wireframe);
}