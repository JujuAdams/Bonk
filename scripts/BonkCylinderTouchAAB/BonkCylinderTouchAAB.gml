// Feather disable all

/// Returns whether a Bonk cylinder and AAB overlap.
/// 
/// @param cylinder
/// @param aab

function BonkCylinderTouchAAB(_cylinder, _aab)
{
    return BonkAABTouchCylinder(_aab, _cylinder);
}