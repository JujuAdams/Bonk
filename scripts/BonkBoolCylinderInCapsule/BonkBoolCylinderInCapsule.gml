// Feather disable all

/// Returns whether a Bonk cylinder and capsule overlap.
/// 
/// @param cylinder
/// @param capsule

function BonkBoolCylinderInCapsule(_cylinder, _capsule)
{
    return BonkBoolCapsuleInAABB(_capsule, _cylinder);
}