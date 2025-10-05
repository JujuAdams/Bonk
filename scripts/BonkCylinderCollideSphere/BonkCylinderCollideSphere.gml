// Feather disable all

/// Returns the "push out" vector that separates a Bonk cylinder and sphere.
/// 
/// This function returns a struct containing the following variables:
/// 
/// `.collision`
///     Whether a collision was found. If no collision is found, this variable is set to `false`.
/// 
/// `.x` `.y` `.z`
///     The vector that separates the two shapes. If there is no collision, all three variables
///     will be set to `0`.
/// 
/// N.B. The returned struct is statically allocated. Reusing this function may cause the same struct
///      to be returned.
/// 
/// @param cylinder
/// @param sphere
/// @param [struct]

function BonkCylinderCollideSphere(_cylinder, _sphere, _struct = undefined)
{
    static _staticStruct = new __BonkClassCollideData();
    var _reaction = _struct ?? _staticStruct;
    
    with(_cylinder)
    {
        var _x      = x;
        var _y      = y;
        var _radius = radius;
        var _zMin   = z - 0.5*height;
        var _zMax   = z + 0.5*height;
    }
    
    with(_sphere)
    {
        var _sphereX = x;
        var _sphereY = y;
        var _sphereZ = z;
        var _sphereRadius = radius;
    }
    
    var _dX = _sphereX - _x;
    var _dY = _sphereY - _y;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY);
    if (_dist > _radius)
    {
        var _coeff = _radius / _dist;
        var _cylinderClosestX = _x + _coeff*_dX;
        var _cylinderClosestY = _y + _coeff*_dY;
    }
    else
    {
        var _cylinderClosestX = _sphereX;
        var _cylinderClosestY = _sphereY;
    }
    
    var _cylinderClosestZ = clamp(_sphere.z, _zMin, _zMax);
    
    var _dX = _cylinderClosestX - _sphereX;
    var _dY = _cylinderClosestY - _sphereY;
    var _dZ = _cylinderClosestZ - _sphereZ;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
    if (_dist >= _sphereRadius)
    {
        return _reaction.__Null();
    }
    
    var _coeff = _sphereRadius / _dist;
    var _sphereClosestX = _coeff*_dX + _sphereX;
    var _sphereClosestY = _coeff*_dY + _sphereY;
    var _sphereClosestZ = _coeff*_dZ + _sphereZ;
    
    with(_reaction)
    {
        collision = true;
        shape = _sphere;
        
        dX = _sphereClosestX - _cylinderClosestX;
        dY = _sphereClosestY - _cylinderClosestY;
        dZ = _sphereClosestZ - _cylinderClosestZ;
    }
    
    return _reaction;
}