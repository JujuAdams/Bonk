// Feather disable all

/// @param aabb
/// @param cylinder

function BonkBoolAABBInCylinder(_aabb, _cylinder)
{
    with(_cylinder)
    {
        var _minZ = z - 0.5*height;
        var _maxZ = z + 0.5*height;
    }
    
    with(_aabb)
    {
        if ((z - zHalfSize >= _maxZ) || (z + zHalfSize <= _minZ))
        {
            return false;
        }
        
        var _left   = x - xHalfSize;
        var _top    = y - yHalfSize;
        var _right  = x + xHalfSize;
        var _bottom = y + yHalfSize;
        
        //2D collision check 
        return rectangle_in_circle(_left, _top, _right, _bottom, _cylinder.x, _cylinder.y, _cylinder.radius);
    }
}