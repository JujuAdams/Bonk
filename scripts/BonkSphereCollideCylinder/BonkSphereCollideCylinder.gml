// Feather disable all

/// @param sphere
/// @param cylinder

function BonkSphereCollideCylinder(_sphere, _cylinder)
{
    return BonkCylinderCollideSphere(_cylinder, _sphere).__Reverse();
}