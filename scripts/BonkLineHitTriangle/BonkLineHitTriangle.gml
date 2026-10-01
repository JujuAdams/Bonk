// Feather disable all

/// @param triangle
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [struct]

function BonkLineHitTriangle(_triangle, _x1, _y1, _z1, _x2, _y2, _z2, _struct = undefined)
{
    static _nullHit = new BonkResultHit();
    
    with(_triangle)
    {
        return __BonkLineHitTriangle(self,   _x1, _y1, _z1,   _x2, _y2, _z2,   x1, y1, z1,   x2, y2, z2,   x3, y3, z3,   _struct);
    }
    
    return _nullHit;
}