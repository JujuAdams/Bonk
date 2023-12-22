// Feather disable all

/// @param point
/// @param aabb

function BonkPointInAABB(_point, _aabb)
{
    with(_point)
    {
        return ((x >= _aabb.x1) && (y >= _aabb.y1) && (z >= _aabb.z1)
             && (x <  _aabb.x2) && (y <  _aabb.y2) && (z <  _aabb.z2));
    }
    
    return false;
}