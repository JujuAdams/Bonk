// Feather disable all

/// @param sphere
/// @param heightmap
/// @param [struct]

function BonkSphereCollideHeightmap(_sphere, _heightmap, _struct = undefined)
{
    with(_sphere)
    {
        return BonkPointCollideHeightmap(_heightmap, x, y, z - radius, _struct);
    }
}