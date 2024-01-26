// Feather disable all

/// @param aabb
/// @param cylinder

function BonkAABBInCylinder(_aabb, _cylinder)
{
    with(_cylinder)
    {
        var _minZ = z - height;
        var _maxZ = z + height;
    }
    
    with(_aabb)
    {
        if ((z - zHalfSize < _minZ) || (z + zHalfSize >= _maxZ)) return false;
        
        return rectangle_in_circle(x - xHalfSize, y - yHalfSize,
                                   x + xHalfSize, y + yHalfSize,
                                   _cylinder.x, _cylinder.y, _cylinder.radius);
    }
    
    return false;
}