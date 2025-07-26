// Feather disable all

/// @param cylinder
/// @param aabb

function BonkCylinderInAABB(_cylinder, _aabb)
{
    return BonkAABBInCylinder(_aabb, _cylinder).Reverse();
}