// Feather disable all

/// @param cylinder
/// @param aabb

function BonkCylinderCollideAABB(_cylinder, _aabb)
{
    return BonkAABBCollideCylinder(_aabb, _cylinder).__Reverse();
}