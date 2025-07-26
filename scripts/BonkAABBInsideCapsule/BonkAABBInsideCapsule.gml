// Feather disable all

/// Returns whether a Bonk AABB and capsule overlap.
/// 
/// @param aabb
/// @param capsule

function BonkAABBInsideCapsule(_aabb, _capsule)
{
    return BonkCapsuleInsideAABB(_capsule, _aabb);
}