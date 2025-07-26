// Feather disable all

/// @param sphere
/// @param aabb

function BonkSphereInAABB(_sphere, _aabb)
{
    return BonkAABBInSphere(_aabb, _sphere).Reverse();
}