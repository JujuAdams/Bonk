// Feather disable all

/// @param box
/// @param cylinder
/// @param [struct]

function BonkRotatedBoxCollideCylinder(_box, _cylinder, _struct = undefined)
{
    return BonkCylinderCollideRotatedBox(_cylinder, _box, _struct).__Reverse(_cylinder);
}