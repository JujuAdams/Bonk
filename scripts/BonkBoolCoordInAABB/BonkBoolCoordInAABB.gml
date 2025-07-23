// Feather disable all

/// Returns whether a coordinate lies inside an AABB.
/// 
/// @param x
/// @param y
/// @param z
/// @param aabb

function BonkBoolCoordInAABB(_x, _y, _z, _aabb)
{
    with(_aabb)
    {
        return ((_x >= x - xHalfSize) && (_y >= y - yHalfSize) && (_z >= z - zHalfSize)
             && (_x <  x + xHalfSize) && (_y <  y + yHalfSize) && (_z <  z + zHalfSize));
    }
    
    return false;
}