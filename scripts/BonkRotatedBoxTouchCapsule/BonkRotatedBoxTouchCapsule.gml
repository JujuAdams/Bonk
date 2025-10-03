// Feather disable all

/// Returns whether a Bonk rotated box and capsule overlap.
/// 
/// @param box
/// @param capsule

function BonkRotatedBoxTouchCapsule(_box, _capsule)
{
    return BonkCapsuleTouchRotatedBox(_capsule, _box);
}