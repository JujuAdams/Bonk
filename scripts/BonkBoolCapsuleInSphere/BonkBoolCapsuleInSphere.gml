// Feather disable all

/// Returns whether a Bonk capsule and sphere overlap.
///
/// @param capsule
/// @param sphere

function BonkBoolCapsuleInSphere(_capsule, _sphere)
{
    with(_capsule)
    {
        var _capsuleZMin = z - 0.5*height + radius;
        var _capsuleZMax = z + 0.5*height - radius;
    }
    
    with(_sphere)
    {
        return (point_distance_3d(x, y, z, _capsule.x, _capsule.y, clamp(z, _capsuleZMin, _capsuleZMax)) < radius + _capsule.radius);
    }
}