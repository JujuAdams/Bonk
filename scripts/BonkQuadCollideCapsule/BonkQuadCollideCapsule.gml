// Feather disable all

/// @param quad
/// @param capsule
/// @param [struct]

function BonkQuadCollideCapsule(_quad, _capsule, _struct = undefined)
{
    return BonkCapsuleCollideQuad(_capsule, _quad, _struct).__Reverse(_capsule);
}