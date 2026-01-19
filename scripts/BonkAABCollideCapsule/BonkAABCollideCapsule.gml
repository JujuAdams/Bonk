// Feather disable all

/// @param aab
/// @param capsule
/// @param [struct]

function BonkAABCollideCapsule(_aab, _capsule, _struct = undefined)
{
    return BonkCapsuleCollideAAB(_capsule, _aab, _struct).__Reverse(_capsule);
}