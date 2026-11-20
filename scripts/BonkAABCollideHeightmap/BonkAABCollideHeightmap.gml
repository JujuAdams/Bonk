// Feather disable all

/// @param aab
/// @param heightmap
/// @param [struct]

function BonkAABCollideHeightmap(_aab, _heightmap, _struct = undefined)
{
    with(_aab)
    {
        return BonkPointCollideHeightmap(x, y, z - zSize/2, _heightmap, _struct);
    }
}