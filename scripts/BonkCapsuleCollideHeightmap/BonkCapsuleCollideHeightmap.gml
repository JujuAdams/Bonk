// Feather disable all

/// @param capsule
/// @param heightmap
/// @param [struct]

function BonkCapsuleCollideHeightmap(_capsule, _heightmap, _struct = undefined)
{
    with(_capsule)
    {
        return BonkPointCollideHeightmap(x, y, z - height/2, _heightmap, _struct);
    }
}