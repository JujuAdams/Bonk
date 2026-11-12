// Feather disable all

/// @param aab
/// @param heightmap
/// @param [struct]

function BonkAABCollideHeightmap(_aab, _heightmap, _struct = undefined)
{
    with(_aab)
    {
        return BonkPointCollideHeightmap(_heightmap, x, y, z - zSize/2);
    }
}