// Feather disable all

/// Returns whether a Bonk sphere and AABB overlap.
/// 
/// @param sphere
/// @param aabb

function BonkBoolSphereInAABB(_sphere, _aabb)
{
    return BonkBoolAABBInSphere(_aabb, _sphere);
}