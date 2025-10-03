// Feather disable all

/// Returns whether a Bonk sphere and capsule overlap.
/// 
/// @param sphere
/// @param capsule

function BonkSphereTouchCapsule(_sphere, _capsule)
{
    return BonkCapsuleTouchSphere(_capsule, _sphere);
}