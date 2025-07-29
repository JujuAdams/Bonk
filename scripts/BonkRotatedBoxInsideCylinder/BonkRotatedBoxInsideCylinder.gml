// Feather disable all

/// Returns whether a Bonk rotated box lies inside a capsule.
/// 
/// @param box
/// @param capsule

function BonkRotatedBoxInsideCylinder(_box, _cylinder)
{
    return BonkCylinderInsideRotatedBox(_cylinder, _box);
}