// Feather disable all

/// Returns whether a Bonk point lies inside a sphere.
/// 
/// @param point
/// @param sphere

function BonkBoolPointInSphere(_point, _sphere)
{
    with(_point)
    {
        return (point_distance_3d(x, y, z, _sphere.x, _sphere.y, _sphere.z) < _sphere.radius);
    }
    
    return false;
}