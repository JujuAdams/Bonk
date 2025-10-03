// Feather disable all

/// Returns whether a Bonk quad and capsule overlap.
/// 
/// @param quad
/// @param capsule

function BonkQuadTouchCapsule(_quad, _capsule)
{
    return BonkCapsuleTouchQuad(_capsule, _quad);
}