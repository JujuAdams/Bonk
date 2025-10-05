// Feather disable all

/// @param cylinder
/// @param aab
/// @param [struct]

function BonkCylinderCollideAAB(_cylinder, _aab, _struct = undefined)
{
    return BonkAABCollideCylinder(_aab, _cylinder, _struct).__Reverse(_aab);
}