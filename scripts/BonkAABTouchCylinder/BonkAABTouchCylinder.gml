// Feather disable all

/// Returns whether a Bonk AAB and cylinder overlap.
/// 
/// @param aab
/// @param cylinder

function BonkAABTouchCylinder(_aab, _cylinder)
{
    with(_cylinder)
    {
        var _minZ = z - 0.5*height;
        var _maxZ = z + 0.5*height;
    }
    
    with(_aab)
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