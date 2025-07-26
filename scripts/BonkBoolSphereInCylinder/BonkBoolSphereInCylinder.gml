// Feather disable all

/// Returns whether a Bonk sphere and cylinder overlap.
/// 
/// @param sphere
/// @param cylinder

function BonkBoolSphereInCylinder(_sphere, _cylinder)
{
    return BonkBoolCylinderInSphere(_cylinder, _sphere);
}