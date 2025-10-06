// Feather disable all

/// Helper function to create a vertical wall. The wall is an implementation of `BonkCreateQuad()` with a
/// friendlier parameter order. Please see `BonkCreateQuad()` for more details.
/// 
/// @param xBottomLeft
/// @param yBottomLeft
/// @param zBottomLeft
/// @param xTopRight
/// @param yTopRight
/// @param zTopRight
/// @param [object=BonkObject]
/// @param [variableStruct]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkCreateWall(_x1, _y1, _z1, _x2, _y2, _z2, _object = undefined, _variableStruct = undefined, _groupVector = BONK_DEFAULT_GROUP)
{
    return BonkCreateQuad(_x1, _y1, _z1,   _x2, _y2, _z2,   _x2, _y2, _z1,   _object, _variableStruct, _groupVector);
}