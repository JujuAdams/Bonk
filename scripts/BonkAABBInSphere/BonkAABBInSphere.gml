// Feather disable all

/// @param aabb
/// @param sphere

function BonkAABBInSphere(_aabb, _sphere)
{
    with(_aabb)
    {
        var _x = clamp(_sphere.x, x1, x2);
        var _y = clamp(_sphere.y, y1, y2);
        var _z = clamp(_sphere.z, z1, z2);
        
        return (point_distance_3d(_x, _y, _z, _sphere.x, _sphere.y, _sphere.z) < _sphere.radius);
    }
    
    return false;
}