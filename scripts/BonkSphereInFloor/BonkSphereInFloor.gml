// Feather disable all

/// @param sphere
/// @param floor

function BonkSphereInFloor(_sphere, _floor)
{
    with(_sphere)
    {
        var _x = clamp(x, _floor.x1, _floor.x2);
        var _y = clamp(y, _floor.y1, _floor.y2);
        return (point_distance_3d(_x, _y, _floor.z, x, y, z) < radius);
    }
    
    return false;
}