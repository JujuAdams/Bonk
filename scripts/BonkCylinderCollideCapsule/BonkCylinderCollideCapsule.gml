// Feather disable all

/// @param cylinder
/// @param capsule
/// @param [struct]

function BonkCylinderCollideCapsule(_cylinder, _capsule, _struct = undefined)
{
    return BonkCapsuleCollideCylinder(_capsule, _cylinder, _struct).__Reverse(_capsule);
}