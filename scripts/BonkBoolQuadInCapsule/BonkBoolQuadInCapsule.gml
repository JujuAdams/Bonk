// Feather disable all

/// Returns whether a Bonk quad lies inside a capsule.
/// 
/// @param quad
/// @param capsule

function BonkBoolQuadInCapsule(_quad, _capsule)
{
    return BonkBoolCapsuleInQuad(_capsule, _quad);
}