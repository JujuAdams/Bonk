// Feather disable all

/// Helper function to create a vertical wall which is, in reality, a special case of the "quad"
/// Bonk instance type. Please see `BonkSetupQuad()` for more details.
/// 
/// @param xBottomLeft
/// @param yBottomLeft
/// @param zBottomLeft
/// @param xTopRight
/// @param yTopRight
/// @param zTopRight
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkSetupWall(_x1, _y1, _z1, _x2, _y2, _z2, _groupVector = BONK_DEFAULT_GROUP)
{
    return BonkSetupQuad(_x1, _y1, _z1,   _x2, _y2, _z2,   _x2, _y2, _z1);
}