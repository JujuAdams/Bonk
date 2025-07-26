// Feather disable all

/// @param sphere
/// @param capsule

function BonkSphereInCapsule(_sphere, _capsule)
{
    return BonkCapsuleInSphere(_capsule, _sphere).Reverse();
}