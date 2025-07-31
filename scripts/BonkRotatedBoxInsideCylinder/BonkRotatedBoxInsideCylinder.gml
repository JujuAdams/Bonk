// Feather disable all

/// Returns whether a Bonk rotated box and cylinder overlap.
/// 
/// @param box
/// @param cylinder

function BonkRotatedBoxInsideCylinder(_box, _cylinder)
{
    return BonkCylinderInsideRotatedBox(_cylinder, _box);
}