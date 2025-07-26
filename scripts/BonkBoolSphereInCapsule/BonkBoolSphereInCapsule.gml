// Feather disable all

/// Returns whether a Bonk sphere and capsule overlap.
/// 
/// @param sphere
/// @param capsule

function BonkBoolSphereInCapsule(_sphere, _capsule)
{
    return BonkBoolCapsuleInSphere(_capsule, _sphere);
}