// Feather disable all

/// Returns whether a coordinate lies inside a cylinder.
/// 
/// @param capsule
/// @param x
/// @param y
/// @param z

function BonkCoordInsideCapsule(_capsule, _x, _y, _z)
{
    with(_capsule)
    {
        return (point_distance_3d(_x, _y, _z,   x, y, clamp(_z, z - 0.5*height + radius, z + 0.5*height - radius)) < radius);
    }
    
    return false;
}