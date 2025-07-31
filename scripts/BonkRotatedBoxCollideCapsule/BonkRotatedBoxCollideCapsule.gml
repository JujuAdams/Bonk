// Feather disable all

/// @param box
/// @param capsule

function BonkRotatedBoxCollideCapsule(_box, _capsule)
{
    return BonkCapsuleCollideRotatedBox(_capsule, _box).__Reverse();
}