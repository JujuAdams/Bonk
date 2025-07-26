// Feather disable all

/// @param sphere
/// @param cylinder

function BonkSphereInCylinder(_sphere, _cylinder)
{
    return BonkCylinderInSphere(_cylinder, _sphere).Reverse();
}