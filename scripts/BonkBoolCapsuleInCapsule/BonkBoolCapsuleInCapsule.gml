// Feather disable all

/// Returns whether twos Bonk capsules overlap.
///
/// @param capsule1
/// @param capsule2

function BonkBoolCapsuleInCapsule(_capsule1, _capsule2)
{
    with(_capsule1)
    {
        var _capsuleZMin1 = z - 0.5*height + radius;
        var _capsuleZMax1 = z + 0.5*height - radius;
    }
    
    with(_capsule2)
    {
        var _z1 = clamp(z, _capsuleZMin1, _capsuleZMax1);
        var _z2 = clamp(_z1, z - 0.5*height + radius, z + 0.5*height - radius);
        
        return (point_distance_3d(_capsule1.x, _capsule1.y,   _z1, x, y, _z2) < radius + _capsule1.radius);
    }
}