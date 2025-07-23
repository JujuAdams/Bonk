// Feather disable all

/// Returns whether a Bonk point lies inside an AABB.
/// 
/// @param point
/// @param aabb

function BonkBoolPointInAABB(_point, _aabb)
{
    with(_aabb)
    {
        var _x = _point.x;
        var _y = _point.y;
        var _z = _point.z;
        
        return ((_x >= x - xHalfSize) && (_y >= y - yHalfSize) && (_z >= z - zHalfSize)
             && (_x <  x + xHalfSize) && (_y <  y + yHalfSize) && (_z <  z + zHalfSize));
    }
    
    return false;
}