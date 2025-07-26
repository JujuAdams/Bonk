// Feather disable all

/// @param quad
/// @param capsule

function BonkQuadCollideCapsule(_quad, _capsule)
{
    return BonkCapsuleCollideQuad(_capsule, _quad).Reverse();
}