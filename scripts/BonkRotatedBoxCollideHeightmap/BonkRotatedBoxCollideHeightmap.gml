// Feather disable all

/// @param box
/// @param heightmap
/// @param [struct]

function BonkRotatedBoxCollideHeightmap(_box, _heightmap, _struct = undefined)
{
    with(_box)
    {
        return BonkPointCollideHeightmap(x, y, z - zSize/2, _heightmap, _struct);
    }
}