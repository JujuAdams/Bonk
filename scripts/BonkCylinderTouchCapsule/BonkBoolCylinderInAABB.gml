// Feather disable all

/// Returns whether a Bonk cylinder and AABB overlap.
/// 
/// @param cylinder
/// @param aabb

function BonkBoolCylinderInAABB(_cylinder, _aabb)
{
    return BonkBoolAABBInCylinder(_aabb, _cylinder);
}