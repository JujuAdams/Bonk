// Feather disable all

/// Returns whether a Bonk point lies inside an AABB.
/// 
/// @param point
/// @param aabb

function BonkBoolPointInAABB(_point, _aabb)
{
    return BonkBoolCoordInAABB(_point.x, _point.y, _point.z, _aabb);
}