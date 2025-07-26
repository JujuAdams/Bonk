// Feather disable all

/// @param cylinder
/// @param capsule

function BonkCylinderInCapsule(_cylinder, _capsule)
{
    return BonkCapsuleInCylinder(_capsule, _cylinder).Reverse();
}