// Feather disable all

/// Draws an axis direction "gizmo". The x-axis is red, the y-axis is green, and the z-axis is
/// blue.
/// 
/// @param [x=0]
/// @param [y=0]
/// @param [z=0]
/// @param [length=100]
/// @param [thickness=3]
/// @param [wireframe]

function UggAxes(_x = 0, _y = 0, _z = 0, _length = 100, _thickness = 3, _wireframe = undefined)
{
    __UGG_GLOBAL
    
    UggLine(_x, _y, _z,   _x + _length, _y, _z,   c_red,   _thickness);
    UggLine(_x, _y, _z,   _x, _y + _length, _z,   c_lime,  _thickness);
    UggLine(_x, _y, _z,   _x, _y, _z + _length,   c_blue,  _thickness);
    
    if (_wireframe ?? __UGG_WIREFRAME)
    {
        UggPoint(_x, _y, _z, c_white, _wireframe);
    }
    else
    {
        UggSphere(_x, _y, _z, _thickness+2, c_white, _wireframe);
    }
}