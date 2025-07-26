// Feather disable all

/// @param sphere
/// @param aabb

function BonkSphereCollideAABB(_sphere, _aabb)
{
    return BonkAABBCollideSphere(_aabb, _sphere).Reverse();
}