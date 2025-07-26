// Feather disable all

/// Returns whether a Bonk AABB and capsule overlap.
/// 
/// @param aabb
/// @param capsule

function BonkBoolAABBInCapsule(_aabb, _capsule)
{
    return BonkBoolCapsuleInAABB(_capsule, _aabb);
}