// Feather disable all

/// Returns the "push out" vector that separates a Bonk capsule and AABB.
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
/// @param capsule
/// @param aabb

function BonkCapsuleCollideAABB(_capsule, _aabb)
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
    
    with(_aabb)
    {
        var _aabbX = clamp(_capsuleX, x - 0.5*xSize, x + 0.5*xSize);
        var _aabbY = clamp(_capsuleY, y - 0.5*ySize, y + 0.5*ySize);
        var _aabbZ = clamp(_capsuleZ, z - 0.5*zSize, z + 0.5*zSize);
    }
    
    var _capsuleClosestZ = clamp(_aabbZ, _capsuleZMin, _capsuleZMax);
    
    var _dX = _aabbX - _capsuleX;
    var _dY = _aabbY - _capsuleY;
    var _dZ = _aabbZ - _capsuleClosestZ;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
    if ((_dist <= 0) || (_dist >= _capsuleRadius))
    {
        return _nullReaction;
    }
    
    var _coeff = _capsuleRadius / _dist;
    var _capsuleClosestX = _coeff*_dX + _capsuleX;
    var _capsuleClosestY = _coeff*_dY + _capsuleY;
    var _capsuleClosestZ = _coeff*_dZ + _capsuleClosestZ;
    
    with(_reaction)
    {
        dX = _aabbX - _capsuleClosestX;
        dY = _aabbY - _capsuleClosestY;
        dZ = _aabbZ - _capsuleClosestZ;
    }
    
    return _reaction;
}