// Feather disable all

/// Constructor to make a struct that contains 3D velocity data. This struct is required when using
/// `BonkMoveAndDeflect()` and `BonkMoveAndDeflectExt()`. Structs are created with three variables,
/// `xSpeed` `ySpeed` `zSpeed`, that encode the three components of the velocity. You may read and
/// write these variables freely.
/// 
/// Structs created by this constructor have two methods:
/// 
/// `.GetSpeed()`
///   Return the scalar speed that the struct represents. This is the "length" of the velocity
///   vector.
/// 
/// `.Reset()`
///   Sets the x, y, and z components of the velocity to 0.
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