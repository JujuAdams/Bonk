// Feather disable all

/// Returns whether a Bonk cylinder and capsule overlap.
/// 
/// @param cylinder
/// @param capsule

function BonkCylinderInsideCapsule(_cylinder, _capsule)
{
    return BonkCapsuleInsideAAB(_capsule, _cylinder);
}