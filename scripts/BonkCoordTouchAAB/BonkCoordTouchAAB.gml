// Feather disable all

/// Returns whether a coordinate lies inside an AAB.
/// 
/// @param aab
/// @param x
/// @param y
/// @param z

function BonkCoordTouchAAB(_aab, _x, _y, _z)
{
    with(_aab)
    {
        return ((_x >= x - 0.5*xSize) && (_y >= y - 0.5*ySize) && (_z >= z - 0.5*zSize)
             && (_x <  x + 0.5*xSize) && (_y <  y + 0.5*ySize) && (_z <  z + 0.5*zSize));
    }
    
    return false;
}