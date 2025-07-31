// Feather disable all

/// Returns whether a Bonk sphere and cylinder overlap.
/// 
/// @param sphere
/// @param cylinder

function BonkSphereInsideCylinder(_sphere, _cylinder)
{
    return BonkCylinderInsideSphere(_cylinder, _sphere);
}