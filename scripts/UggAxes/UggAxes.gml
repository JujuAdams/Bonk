// Feather disable all

/// Draws an axis direction "gizmo". The x-axis is red, the y-axis is green, and the z-axis is
/// blue.
/// 
/// @param [x=0]
/// @param [y=0]
/// @param [z=0]
/// @param [length=100]
/// @param [thickness=3]

function UggAxes(_x = 0, _y = 0, _z = 0, _length = 100, _thickness = 3)
{
    __UGG_GLOBAL
    
    UggLine(_x, _y, _z,   _length, 0, 0,   c_red,   _thickness);
    UggLine(_x, _y, _z,   0, _length, 0,   c_lime,  _thickness);
    UggLine(_x, _y, _z,   0, 0, _length,   c_blue,  _thickness);
    
    if (_global.__wireframe)
    {
        UggPoint(_x, _y, _z, c_white);
    }
    else
    {
        UggSphere(_x, _y, _z, _thickness+2, c_white);
    }
}