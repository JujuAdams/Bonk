// Feather disable all

/// @param quad
/// @param capsule

function BonkQuadInCapsule(_quad, _capsule)
{
    return BonkCapsuleInQuad(_capsule, _quad).Reverse();
}