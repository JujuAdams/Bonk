// Feather disable all

/// @param sphere
/// @param cylinder
/// @param [struct]

function BonkSphereCollideCylinder(_sphere, _cylinder, _struct = undefined)
{
    return BonkCylinderCollideSphere(_cylinder, _sphere, _struct).__Reverse(_cylinder);
}