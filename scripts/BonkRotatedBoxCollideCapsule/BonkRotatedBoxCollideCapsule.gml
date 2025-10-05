// Feather disable all

/// @param box
/// @param capsule
/// @param [struct]

function BonkRotatedBoxCollideCapsule(_box, _capsule, _struct = undefined)
{
    return BonkCapsuleCollideRotatedBox(_capsule, _box, _struct).__Reverse(_capsule);
}