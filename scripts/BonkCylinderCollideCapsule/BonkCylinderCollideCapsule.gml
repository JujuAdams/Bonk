// Feather disable all

/// @param cylinder
/// @param capsule

function BonkCylinderCollideCapsule(_cylinder, _capsule)
{
    return BonkCapsuleCollideCylinder(_capsule, _cylinder).Reverse();
}