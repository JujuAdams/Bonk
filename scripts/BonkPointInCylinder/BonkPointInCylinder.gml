// Feather disable all

/// @param point
/// @param cylinder

function BonkPointInCylinder(_point, _cylinder)
{
    with(_cylinder)
    {
        var _minZ = z - height;
        var _maxZ = z + height;
    }
    
    with(_point)
    {
        if ((z < _minZ) || (z > _maxZ)) return false;
        return (point_distance(x, y, _cylinder.x, _cylinder.y) < _cylinder.radius);
    }
    
    return false;
}