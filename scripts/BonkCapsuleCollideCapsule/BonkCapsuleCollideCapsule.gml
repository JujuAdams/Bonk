// Feather disable all

/// Returns the "push out" vector that separates two Bonk capsules.
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
/// @param capsule1
/// @param capsule2
/// @param [struct]

function BonkCapsuleCollideCapsule(_capsule1, _capsule2, _struct = undefined)
{
    static _staticStruct = new __BonkClassCollideData();
    var _reaction = _struct ?? _staticStruct;
    
    with(_capsule1)
    {
        var _capsuleRadius1 = radius;
        var _capsuleX1      = x;
        var _capsuleY1      = y;
        var _capsuleZ1      = z;
        var _capsuleZMin1   = _capsuleZ1 - 0.5*height + radius;
        var _capsuleZMax1   = _capsuleZ1 + 0.5*height - radius;
    }
    
    with(_capsule2)
    {
        var _capsuleRadius2 = radius;
        var _capsuleX2      = x;
        var _capsuleY2      = y;
        var _capsuleZ2      = z;
        var _capsuleZMin2   = _capsuleZ2 - 0.5*height + radius;
        var _capsuleZMax2   = _capsuleZ2 + 0.5*height - radius;
    }
    
    var _capsuleClosestZ1 = clamp(_capsuleZ2, _capsuleZMin1, _capsuleZMax1);
    var _capsuleClosestZ2 = clamp(_capsuleZ1, _capsuleZMin2, _capsuleZMax2);
    
    var _dX = _capsuleX2 - _capsuleX1;
    var _dY = _capsuleY2 - _capsuleY1;
    var _dZ = _capsuleClosestZ2 - _capsuleClosestZ1;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
    if (_dist >= _capsuleRadius1 + _capsuleRadius2)
    {
        return _reaction.__Null();
    }
    
    with(_reaction)
    {
        shape = _capsule2;
        
        if (_dist != 0)
        {
            var _coeff = (_capsuleRadius1 + _capsuleRadius2) / _dist;
            dX = -_coeff*_dX + _capsuleX2 - _capsuleX1;
            dY = -_coeff*_dY + _capsuleY2 - _capsuleY1;
            dZ = -_coeff*_dZ + _capsuleClosestZ2 - _capsuleClosestZ1;
        }
        else
        {
            //Panic! Pick a randomish direction to push out in
            dX = 1 - 2*floor(abs(_capsuleX1) mod 2);
            dY = 1 - 2*floor(abs(_capsuleY1) mod 2);
            dZ = 1 - 2*floor(abs(_capsuleZ1) mod 2);
        }
    }
    
    return _reaction;
}