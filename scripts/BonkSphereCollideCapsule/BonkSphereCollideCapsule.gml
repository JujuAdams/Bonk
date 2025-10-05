// Feather disable all

/// @param sphere
/// @param capsule
/// @param [struct]

function BonkSphereCollideCapsule(_sphere, _capsule, _struct = undefined)
{
    return BonkCapsuleCollideSphere(_capsule, _sphere, _struct).__Reverse(_capsule);
}