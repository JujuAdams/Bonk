// Feather disable all

/// @param quad
/// @param sphere

function BonkQuadCollideSphere(_quad, _sphere)
{
    return BonkSphereCollideQuad(_sphere, _quad).Reverse();
}