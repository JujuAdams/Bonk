// Feather disable all

/// Returns whether a Bonk cylinder and AABB overlap.
/// 
/// @param cylinder
/// @param aabb

function BonkCylinderInsideAABB(_cylinder, _aabb)
{
    return BonkAABBInsideCylinder(_aabb, _cylinder);
}