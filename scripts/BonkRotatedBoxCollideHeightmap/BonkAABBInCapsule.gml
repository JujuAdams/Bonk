// Feather disable all

/// @param aabb
/// @param capsule

function BonkAABBInCapsule(_aabb, _capsule)
{
    return BonkCapsuleInAABB(_capsule, _aabb).Reverse();
}