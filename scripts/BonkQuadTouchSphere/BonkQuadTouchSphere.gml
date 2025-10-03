// Feather disable all

/// Returns whether a Bonk quad and sphere overlap.
/// 
/// @param quad
/// @param sphere

function BonkQuadTouchSphere(_quad, _sphere)
{
    return BonkSphereTouchQuad(_sphere, _quad);
}