// Feather disable all

/// Returns the "push out" vector that separates a Bonk capsule and cylinder.
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
/// @param cylinder

function BonkCapsuleCollideCylinder(_capsule, _cylinder)
{
    static _nullReaction = __Bonk().__nullReaction;
    static _reaction     = new __BonkClassReaction();
    
    with(_capsule)
    {
        var _capsuleRadius = radius;
        var _capsuleX      = x;
        var _capsuleY      = y;
        var _capsuleZ      = z;
        var _capsuleZMin   = _capsuleZ - 0.5*height + radius;
        var _capsuleZMax   = _capsuleZ + 0.5*height - radius;
    }
    
    with(_cylinder)
    {
        var _dX = _capsuleX - x;
        var _dY = _capsuleY - y;
        
        var _dist = sqrt(_dX*_dX + _dY*_dY);
        if (_dist <= 0)
        {
            var _cylinderX = _capsuleX;
            var _cylinderY = _capsuleY;
        }
        else
        {
            var _coeff = min(1, radius/_dist);
            var _cylinderX = x + _coeff*_dX;
            var _cylinderY = y + _coeff*_dY;
        }
        
        var _cylinderZ = clamp(_capsuleZ, z - 0.5*height, z + 0.5*height);
    }
    
    var _capsuleClosestZ = clamp(_cylinderZ, _capsuleZMin, _capsuleZMax);
    
    var _dX = _cylinderX - _capsuleX;
    var _dY = _cylinderY - _capsuleY;
    var _dZ = _cylinderZ - _capsuleClosestZ;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
    if (_dist >= _capsuleRadius)
    {
        return _nullReaction;
    }
    
    var _coeff = _capsuleRadius / _dist;
    var _capsuleClosestX = _coeff*_dX + _capsuleX;
    var _capsuleClosestY = _coeff*_dY + _capsuleY;
    var _capsuleClosestZ = _coeff*_dZ + _capsuleClosestZ;
    
    with(_reaction)
    {
        dX = _cylinderX - _capsuleClosestX;
        dY = _cylinderY - _capsuleClosestY;
        dZ = _cylinderZ - _capsuleClosestZ;
    }
    
    return _reaction;
}