/// @param heightmap
/// @param cylinder
/// @param [struct]

function BonkHeightmapCollideCylinder(_heightmap, _cylinder, _struct = undefined)
{
    return BonkCylinderCollideHeightmap(_cylinder, _heightmap, _struct).__Reverse(_cylinder);
}