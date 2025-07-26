// Feather disable all

/// Returns whether a Bonk point lies inside a sphere.
/// 
/// @param point
/// @param sphere

function BonkBoolPointInSphere(_point, _sphere)
{
    return BonkBoolCoordInSphere(_point.x, _point.y, _point.z, _sphere);
}