// Feather disable all

/// Returns whether a Bonk cylinder and AAB overlap.
/// 
/// @param cylinder
/// @param aab

function BonkCylinderInsideAAB(_cylinder, _aab)
{
    return BonkAABInsideCylinder(_aab, _cylinder);
}