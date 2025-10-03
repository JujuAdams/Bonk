// Feather disable all

/// Returns whether a Bonk rotated box and cylinder overlap.
/// 
/// @param box
/// @param cylinder

function BonkRotatedBoxTouchCylinder(_box, _cylinder)
{
    return BonkCylinderTouchRotatedBox(_cylinder, _box);
}