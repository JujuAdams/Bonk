// Feather disable all

/// @param point
/// @param sphere

function BonkPointInSphere(_point, _sphere)
{
    with(_point)
    {
        return (point_distance_3d(x, y, z, _sphere.x, _sphere.y, _sphere.z) < _sphere.radius);
    }
    
    return false;
}