// Feather disable all

/// Returns whether a Bonk cylinder and capsule overlap.
/// 
/// @param cylinder
/// @param capsule

function BonkCylinderTouchCapsule(_cylinder, _capsule)
{
    return BonkCapsuleTouchAAB(_capsule, _cylinder);
}