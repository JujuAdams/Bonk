// Feather disable all

/// Returns whether a Bonk AABB and cylinder overlap.
/// 
/// @param aabb
/// @param cylinder

function BonkAABBInsideCylinder(_aabb, _cylinder)
{
    with(_cylinder)
    {
        var _minZ = z - 0.5*height;
        var _maxZ = z + 0.5*height;
    }
    
    with(_aabb)
    {
        if ((z - 0.5*zSize >= _maxZ) || (z + 0.5*zSize <= _minZ))
        {
            return false;
        }
        
        var _left   = x - 0.5*xSize;
        var _top    = y - 0.5*ySize;
        var _right  = x + 0.5*xSize;
        var _bottom = y + 0.5*ySize;
        
        //2D collision check 
        return rectangle_in_circle(_left, _top, _right, _bottom, _cylinder.x, _cylinder.y, _cylinder.radius);
    }
}