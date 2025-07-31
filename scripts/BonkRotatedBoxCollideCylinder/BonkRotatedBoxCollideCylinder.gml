// Feather disable all

/// @param box
/// @param cylinder

function BonkRotatedBoxCollideCylinder(_box, _cylinder)
{
    return BonkCylinderCollideRotatedBox(_cylinder, _box).__Reverse();
}