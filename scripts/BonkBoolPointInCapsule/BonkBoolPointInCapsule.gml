// Feather disable all

/// Returns whether a Bonk point lies inside a capsule.
/// 
/// @param point
/// @param capsule

function BonkBoolPointInCapsule(_point, _capsule)
{
    return BonkBoolCoordInCapsule(_point.x, _point.y, _point.z, _capsule);
}