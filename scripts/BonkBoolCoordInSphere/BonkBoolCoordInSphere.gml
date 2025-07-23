// Feather disable all

/// Returns whether a coordinate lies inside a sphere.
/// 
/// @param x
/// @param y
/// @param z
/// @param sphere

function BonkBoolCoordInSphere(_x, _y, _z, _sphere)
{
    with(_sphere)
    {
        return (point_distance_3d(_x, _y, _z, x, y, z) < radius);
    }
    
    return false;
}