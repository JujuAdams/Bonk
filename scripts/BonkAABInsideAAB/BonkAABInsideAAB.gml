// Feather disable all

/// Returns whether two Bonk AABs overlap.
/// 
/// @param aab1
/// @param aab2

function BonkAABInsideAAB(_aab1, _aab2)
{
    with(_aab1)
    {
        return ((x - 0.5*xSize <= _aab2.x + 0.5*_aab2.xSize) && (y - 0.5*ySize <= _aab2.y + 0.5*_aab2.ySize) && (z - 0.5*zSize <= _aab2.z + 0.5*_aab2.zSize)
             && (x + 0.5*xSize >  _aab2.x - 0.5*_aab2.xSize) && (y + 0.5*ySize >  _aab2.y - 0.5*_aab2.ySize) && (z + 0.5*zSize >  _aab2.z - 0.5*_aab2.zSize));
    }
    
    return false;
}