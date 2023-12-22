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
        if ((z1 < _minZ) || (z2 >= _maxZ)) return false;
        
        return rectangle_in_circle(x1, y1, x2, y2, _cylinder.x, _cylinder.y, _cylinder.radius);
    }
    
    return false;
}