// Feather disable all

/// @param sphere
/// @param heightmap
/// @param [struct]

function BonkSphereCollideHeightmap(_sphere, _heightmap, _struct = undefined)
{
    return _heightmap.Collide(_sphere, undefined, _struct).__Reverse(_heightmap);
}