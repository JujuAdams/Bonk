// Feather disable all

/// Returns whether a Bonk sphere and AABB overlap.
/// 
/// @param sphere
/// @param aabb

function BonkSphereInsideAABB(_sphere, _aabb)
{
    return BonkAABBInsideSphere(_aabb, _sphere);
}