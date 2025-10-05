// Feather disable all

/// Returns the "push out" vector that separates a Bonk capsule and sphere.
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
/// @param capsule
/// @param sphere
/// @param [struct]

function BonkCapsuleCollideSphere(_capsule, _sphere, _struct = undefined)
{
    static _staticStruct = new __BonkClassCollideData();
    var _reaction = _struct ?? _staticStruct;
    
    with(_capsule)
    {
        var _capsuleRadius = radius;
        var _capsuleX      = x;
        var _capsuleY      = y;
        var _capsuleZ      = z;
        var _capsuleZMin   = _capsuleZ - 0.5*height + radius;
        var _capsuleZMax   = _capsuleZ + 0.5*height - radius;
    }
    
    with(_sphere)
    {
        var _sphereRadius = radius;
        var _sphereX      = x;
        var _sphereY      = y;
        var _sphereZ      = z;
    }
    
    var _capsuleClosestZ = clamp(_sphereZ, _capsuleZMin, _capsuleZMax);
    
    var _dX = _sphereX - _capsuleX;
    var _dY = _sphereY - _capsuleY;
    var _dZ = _sphereZ - _capsuleClosestZ;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
    if (_dist >= _capsuleRadius + _sphereRadius)
    {
        return _reaction.__Null();
    }
    
    with(_reaction)
    {
        collision = true;
        shape = _sphere;
        
        var _coeff = (_capsuleRadius + _sphereRadius) / _dist;
        dX = -_coeff*_dX + _sphereX - _capsuleX;
        dY = -_coeff*_dY + _sphereY - _capsuleY;
        dZ = -_coeff*_dZ + _sphereZ - _capsuleClosestZ;
    }
    
    return _reaction;
}