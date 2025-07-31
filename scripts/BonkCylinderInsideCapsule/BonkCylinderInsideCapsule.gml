// Feather disable all

/// Returns whether a Bonk cylinder and capsule overlap.
/// 
/// @param cylinder
/// @param capsule

function BonkCylinderInsideCapsule(_cylinder, _capsule)
{
    return BonkCapsuleInsideAABB(_capsule, _cylinder);
}