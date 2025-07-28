// Feather disable all

/// Constructor to make a struct that contains 3D velocity data. This struct is required when using
/// `BonkMoveAndCollide()`. Struct are created with three member variables, `xSpeed` `ySpeed` and
/// `zSpeed`, that encode the three components of the velocity. You may get and set these variables
/// as you see fit.
/// 
/// Structs created by this constructor has two methods:
/// 
/// `.GetSpeed()`
///     Return the scalar speed that the struct represents. This is the "length" of the velocity
///     vector.
/// 
/// `.Reset()`
///     Sets the x, y, and z components of the velocity to 0.
/// 
/// @param [xSpeed=0]
/// @param [ySpeed=0]
/// @param [zSpeed=0]

function BonkVelocity(_xSpeed = 0, _ySpeed = 0, _zSpeed = 0) constructor
{
    xSpeed = _xSpeed;
    ySpeed = _ySpeed;
    zSpeed = _zSpeed;
    
    static GetSpeed = function()
    {
        return sqrt(xSpeed*xSpeed + ySpeed*ySpeed + zSpeed*zSpeed);
    }
    
    static Reset = function()
    {
        xSpeed = 0;
        ySpeed = 0;
        zSpeed = 0;
    }
}