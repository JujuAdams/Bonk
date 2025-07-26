// Feather disable all

/// Returns whether a Bonk point lies inside a cylinder.
/// 
/// @param point
/// @param cylinder

function BonkBoolPointInCylinder(_point, _cylinder)
{
    return BonkBoolCoordInCylinder(_point.x, _point.y, _point.z, _cylinder);
}