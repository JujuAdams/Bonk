// Feather disable all

/// Helper function to create a vertical wall. The wall is an implementation of `BonkInstQuad()` with a
/// friendlier argument order.
/// 
/// @param xBottomLeft
/// @param yBottomLeft
/// @param zBottomLeft
/// @param xTopRight
/// @param yTopRight
/// @param zTopRight

function BonkInstWall(_x1, _y1, _z1, _x2, _y2, _z2)
{
    return BonkInstQuad(_x1, _y1, _z1, _x2, _y2, _z2, _x2, _y2, _z1);
}