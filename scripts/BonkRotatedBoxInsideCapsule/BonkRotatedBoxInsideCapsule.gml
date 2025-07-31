// Feather disable all

/// Returns whether a Bonk rotated box lies inside a capsule.
/// 
/// @param box
/// @param capsule

function BonkRotatedBoxInsideCapsule(_box, _capsule)
{
    return BonkCapsuleInsideRotatedBox(_capsule, _box);
}