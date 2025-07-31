// Feather disable all

/// Returns whether a Bonk quad lies inside a capsule.
/// 
/// @param quad
/// @param capsule

function BonkQuadInsideCapsule(_quad, _capsule)
{
    return BonkCapsuleInsideQuad(_capsule, _quad);
}