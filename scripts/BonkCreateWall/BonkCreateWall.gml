// Feather disable all

/// Helper function to create a vertical wall. The wall is an implementation of `BonkCreateQuad()` with a
/// friendlier argument order.
/// 
/// @param xBottomLeft
/// @param yBottomLeft
/// @param zBottomLeft
/// @param xTopRight
/// @param yTopRight
/// @param zTopRight
/// @param [object]


function BonkCreateWall(_x1, _y1, _z1, _x2, _y2, _z2, _object = undefined)
{
    return BonkCreateQuad(_x1, _y1, _z1,   _x2, _y2, _z2,   _x2, _y2, _z1,   _object);
}