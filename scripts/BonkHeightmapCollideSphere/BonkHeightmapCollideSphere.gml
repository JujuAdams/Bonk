/// @param heightmap
/// @param sphere
/// @param [struct]

function BonkHeightmapCollideSphere(_heightmap, _sphere, _struct = undefined)
{
    return BonkSphereCollideHeightmap(_sphere, _heightmap, _struct).__Reverse(_sphere);
}