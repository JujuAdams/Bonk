// Feather disable all

/// Returns whether a Bonk pole and AABB overlap.
///
/// @param pole
/// @param aabb

function BonkPoleInsideAABB(_pole, _aabb)
{
    with(_pole)
    {
        var _capsuleX    = x;
        var _capsuleY    = y;
        var _capsuleZMin = z - 0.5*height;
        var _capsuleZMax = z + 0.5*height;
    }
    
    with(_aabb)
    {
        return ((_capsuleX    > x - 0.5*xSize) && (_capsuleX    < x + 0.5*xSize)
            &&  (_capsuleY    > y - 0.5*ySize) && (_capsuleY    < y + 0.5*ySize)
            &&  (_capsuleZMin < z + 0.5*zSize) && (_capsuleZMax > z - 0.5*zSize))
    }
}