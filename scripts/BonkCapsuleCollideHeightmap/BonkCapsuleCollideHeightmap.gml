// Feather disable all

/// @param capsule
/// @param heightmap
/// @param [struct]

function BonkCapsuleCollideHeightmap(_capsule, _heightmap, _struct = undefined)
{
    return _heightmap.Collide(_capsule, undefined, _struct).__Reverse(_heightmap);
}