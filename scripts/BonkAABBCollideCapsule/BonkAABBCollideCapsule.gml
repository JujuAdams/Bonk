// Feather disable all

/// @param aabb
/// @param capsule

function BonkAABBCollideCapsule(_aabb, _capsule)
{
    return BonkCapsuleCollideAABB(_capsule, _aabb).Reverse();
}