// Feather disable all

/// @param aabb
/// @param sphere

function BonkAABBInSphere(_aabb, _sphere)
{
    with(_aabb)
    {
        var _x = clamp(_sphere.x, x - xHalfSize, x + xHalfSize);
        var _y = clamp(_sphere.y, y - yHalfSize, y + yHalfSize);
        var _z = clamp(_sphere.z, z - zHalfSize, z + zHalfSize);
        
        return (point_distance_3d(_x, _y, _z, _sphere.x, _sphere.y, _sphere.z) < _sphere.radius);
    }
    
    return false;
}