// Feather disable all

/// Returns whether a Bonk sphere and capsule overlap.
/// 
/// @param sphere
/// @param capsule

function BonkSphereInsideCapsule(_sphere, _capsule)
{
    return BonkCapsuleInsideSphere(_capsule, _sphere);
}