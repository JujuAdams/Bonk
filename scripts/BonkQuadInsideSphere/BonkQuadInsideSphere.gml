// Feather disable all

/// Returns whether a Bonk quad and sphere overlap.
/// 
/// @param quad
/// @param sphere

function BonkQuadInsideSphere(_quad, _sphere)
{
    return BonkSphereInsideQuad(_sphere, _quad);
}