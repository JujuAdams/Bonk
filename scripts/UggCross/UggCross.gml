// Feather disable all

/// Draws an axis direction "gizmo". The x-axis is red, the y-axis is green, and the z-axis is
/// blue.
/// 
/// @param x
/// @param y
/// @param z
/// @param radius
/// @param [color]
/// @param [thickness=1]
/// @param [wireframe}

function UggCross(_x, _y, _z, _radius, _color = c_white, _thickness = 1, _wireframe = undefined)
{
    UggLine(_x - _radius, _y, _z,   _x + _radius, _y, _z,   _color,  _thickness, _wireframe);
    UggLine(_x, _y - _radius, _z,   _x, _y + _radius, _z,   _color,  _thickness, _wireframe);
    UggLine(_x, _y, _z - _radius,   _x, _y, _z + _radius,   _color,  _thickness, _wireframe);
}