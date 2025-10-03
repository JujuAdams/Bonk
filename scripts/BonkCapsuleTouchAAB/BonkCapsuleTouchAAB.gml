// Feather disable all

/// Returns whether a Bonk capsule and AAB overlap.
///
/// @param capsule
/// @param aab

function BonkCapsuleTouchAAB(_capsule, _aab)
{
    with(_capsule)
    {
        var _capsuleRadius = radius;
        var _capsuleX      = x;
        var _capsuleY      = y;
        var _capsuleZ      = z;
        var _capsuleZMin   = _capsuleZ - 0.5*height + radius;
        var _capsuleZMax   = _capsuleZ + 0.5*height - radius;
    }
    
    with(_aab)
    {
        var _aabX = clamp(_capsuleX, x - 0.5*xSize, x + 0.5*xSize);
        var _aabY = clamp(_capsuleY, y - 0.5*ySize, y + 0.5*ySize);
        var _aabZ = clamp(_capsuleZ, z - 0.5*zSize, z + 0.5*zSize);
        
    }
    
    return (point_distance_3d(_aabX, _aabY, _aabZ, _capsuleX, _capsuleY, clamp(_aabZ, _capsuleZMin, _capsuleZMax)) < _capsuleRadius);
}