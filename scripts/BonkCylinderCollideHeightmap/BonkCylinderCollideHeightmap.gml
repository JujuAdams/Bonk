// Feather disable all

/// @param cylinder
/// @param heightmap
/// @param [struct]

function BonkCylinderCollideHeightmap(_cylinder, _heightmap, _struct = undefined)
{
    with(_cylinder)
    {
        return BonkPointCollideHeightmap(_heightmap, x, y, z - height/2, _struct);
    }
}