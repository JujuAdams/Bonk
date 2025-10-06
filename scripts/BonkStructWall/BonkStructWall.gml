// Feather disable all

/// Helper function to create a vertical wall. The wall is an implementation of `BonkStructQuad()`
/// with a friendlier parameter order.
/// 
/// @param xBottomLeft
/// @param yBottomLeft
/// @param zBottomLeft
/// @param xTopRight
/// @param yTopRight
/// @param zTopRight
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkStructWall(_x1, _y1, _z1, _x2, _y2, _z2, _groupVector = BONK_DEFAULT_GROUP) : BonkStructQuad(_x1, _y1, _z1, _x2, _y2, _z2, _x2, _y2, _z1, _groupVector) constructor
{
    
}