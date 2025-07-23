// Feather disable all

/// Returns whether two Bonk AABBs overlap.
/// 
/// @param aabb1
/// @param aabb2

function BonkBoolAABBInAABB(_aabb1, _aabb2)
{
    with(_aabb1)
    {
        return ((x - xHalfSize <= _aabb2.x + _aabb2.xHalfSize) && (y - yHalfSize <= _aabb2.y + _aabb2.yHalfSize) && (z - zHalfSize <= _aabb2.z + _aabb2.zHalfSize)
             && (x + xHalfSize >  _aabb2.x - _aabb2.xHalfSize) && (y + yHalfSize >  _aabb2.y - _aabb2.yHalfSize) && (z + zHalfSize >  _aabb2.z - _aabb2.zHalfSize));
    }
    
    return false;
}