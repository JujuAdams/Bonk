// Feather disable all

/// Returns whether a Bonk capsule and AABB overlap.
///
/// @param capsule
/// @param aabb

function BonkCapsuleInsideAABB(_capsule, _aabb)
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
        var _aabbX = clamp(_capsuleX, x - 0.5*xSize, x + 0.5*xSize);
        var _aabbY = clamp(_capsuleY, y - 0.5*ySize, y + 0.5*ySize);
        var _aabbZ = clamp(_capsuleZ, z - 0.5*zSize, z + 0.5*zSize);
        
    }
    
    return (point_distance_3d(_aabbX, _aabbY, _aabbZ, _capsuleX, _capsuleY, clamp(_aabbZ, _capsuleZMin, _capsuleZMax)) < _capsuleRadius);
}