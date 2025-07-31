// Feather disable all

/// Returns whether two Bonk AABBs overlap.
/// 
/// @param aabb1
/// @param aabb2

function BonkAABBInsideAABB(_aabb1, _aabb2)
{
    with(_aabb1)
    {
        return ((x - 0.5*xSize <= _aabb2.x + 0.5*_aabb2.xSize) && (y - 0.5*ySize <= _aabb2.y + 0.5*_aabb2.ySize) && (z - 0.5*zSize <= _aabb2.z + 0.5*_aabb2.zSize)
             && (x + 0.5*xSize >  _aabb2.x - 0.5*_aabb2.xSize) && (y + 0.5*ySize >  _aabb2.y - 0.5*_aabb2.ySize) && (z + 0.5*zSize >  _aabb2.z - 0.5*_aabb2.zSize));
    }
    
    return false;
}