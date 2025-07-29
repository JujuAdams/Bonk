// Feather disable all

/// Returns whether a Bonk pole and capsule overlap.
///
/// @param pole
/// @param capsule

function BonkPoleInsideCapsule(_pole, _capsule)
{
    with(_pole)
    {
        var _poleZMin = z - 0.5*height;
        var _poleZMax = z + 0.5*height;
    }
    
    with(_capsule)
    {
        var _z1 = clamp(z, _poleZMin, _poleZMax);
        var _z2 = clamp(_z1, z - 0.5*height + radius, z + 0.5*height - radius);
        
        return (point_distance_3d(_pole.x, _pole.y, _z1,   x, y, _z2) < radius);
    }
}