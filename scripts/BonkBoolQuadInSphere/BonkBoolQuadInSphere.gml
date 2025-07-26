// Feather disable all

/// Returns whether a Bonk quad and sphere overlap.
/// 
/// @param quad
/// @param sphere

function BonkBoolQuadInSphere(_quad, _sphere)
{
    return BonkBoolSphereInQuad(_sphere, _quad);
}