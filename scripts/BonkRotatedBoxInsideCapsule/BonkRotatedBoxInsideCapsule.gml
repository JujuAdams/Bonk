// Feather disable all

/// Returns whether a Bonk rotated box and capsule overlap.
/// 
/// @param box
/// @param capsule

function BonkRotatedBoxInsideCapsule(_box, _capsule)
{
    return BonkCapsuleInsideRotatedBox(_capsule, _box);
}