// Feather disable all

/// @param quad
/// @param sphere

function BonkQuadInSphere(_quad, _sphere)
{
    return BonkSphereInQuad(_sphere, _quad).Reverse();
}