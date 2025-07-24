// Feather disable all

/// Returns whether a Bonk AABB and sphere overlap.
///
/// @param capsule
/// @param aabb

function BonkBoolCapsuleInAABB(_capsule, _aabb)
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
    
    with(_aabb)
    {
        var _aabbX = clamp(_capsuleX, x - xHalfSize, x + xHalfSize);
        var _aabbY = clamp(_capsuleY, y - yHalfSize, y + yHalfSize);
        var _aabbZ = clamp(_capsuleZ, z - zHalfSize, z + zHalfSize);
        
        return (point_distance_3d(_aabbX, _aabbY, _aabbZ, _capsuleX, _capsuleY, clamp(_aabbZ, _capsuleZMin, _capsuleZMax)) < _capsuleRadius);
    }
    
    return false;
}