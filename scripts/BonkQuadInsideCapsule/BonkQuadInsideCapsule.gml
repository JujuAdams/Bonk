// Feather disable all

/// Returns whether a Bonk quad and capsule overlap.
/// 
/// @param quad
/// @param capsule

function BonkQuadInsideCapsule(_quad, _capsule)
{
    return BonkCapsuleInsideQuad(_capsule, _quad);
}