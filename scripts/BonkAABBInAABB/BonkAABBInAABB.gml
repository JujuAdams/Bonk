// Feather disable all

/// @param aabb1
/// @param aabb2

function BonkAABBInAABB(_aabb1, _aabb2)
{
    with(_aabb1)
    {
        return ((x1 <= _aabb2.x2) && (y1 <= _aabb2.y2) && (z1 <= _aabb2.z2)
             && (x2 >  _aabb2.x1) && (y2 >  _aabb2.y1) && (z2 >  _aabb2.z1));
    }
    
    return false;
}