// Feather disable all

/// Returns whether a Bonk point lies inside a cylinder.
/// 
/// @param point
/// @param cylinder

function BonkBoolPointInCylinder(_point, _cylinder)
{
    with(_cylinder)
    {
        var _minZ = z - 0.5*height;
        var _maxZ = z + 0.5*height;
    }
    
    with(_point)
    {
        if ((z < _minZ) || (z > _maxZ)) return false;
        return (point_distance(x, y, _cylinder.x, _cylinder.y) < _cylinder.radius);
    }
    
    return false;
}