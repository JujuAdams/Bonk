// Feather disable all

/// Returns whether a Bonk AABB and sphere overlap.
///
/// @param capsule
/// @param aabb

function BonkBoolCapsuleInAABB(_capsule, _aabb)
{
    with(_aabb)
    {
        var _x = clamp(_capsule.x, x - xHalfSize, x + xHalfSize);
        var _y = clamp(_capsule.y, y - yHalfSize, y + yHalfSize);
        var _z = clamp(_capsule.z, z - zHalfSize, z + zHalfSize);
        
        return (point_distance_3d(_x, _y, _z, _capsule.x, _capsule.y, _capsule.z) < _capsule.radius);
    }
    
    return false;
}