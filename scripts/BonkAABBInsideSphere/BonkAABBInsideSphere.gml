// Feather disable all

/// Returns whether a Bonk AABB and sphere overlap.
/// 
/// @param aabb
/// @param sphere

function BonkAABBInsideSphere(_aabb, _sphere)
{
    with(_aabb)
    {
        var _x = clamp(_sphere.x, x - 0.5*xSize, x + 0.5*xSize);
        var _y = clamp(_sphere.y, y - 0.5*ySize, y + 0.5*ySize);
        var _z = clamp(_sphere.z, z - 0.5*zSize, z + 0.5*zSize);
        
        return (point_distance_3d(_x, _y, _z, _sphere.x, _sphere.y, _sphere.z) < _sphere.radius);
    }
    
    return false;
}