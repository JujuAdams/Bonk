// Feather disable all

/// @param sphere
/// @param capsule

function BonkSphereCollideCapsule(_sphere, _capsule)
{
    return BonkCapsuleCollideSphere(_capsule, _sphere).__Reverse();
}