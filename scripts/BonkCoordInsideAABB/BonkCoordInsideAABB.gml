// Feather disable all

/// Returns whether a coordinate lies inside an AABB.
/// 
/// @param aabb
/// @param x
/// @param y
/// @param z

function BonkCoordInsideAABB(_aabb, _x, _y, _z)
{
    with(_aabb)
    {
        return ((_x >= x - xHalfSize) && (_y >= y - yHalfSize) && (_z >= z - zHalfSize)
             && (_x <  x + xHalfSize) && (_y <  y + yHalfSize) && (_z <  z + zHalfSize));
    }
    
    return false;
}