/// @param heightmap
/// @param capsule
/// @param [struct]

function BonkHeightmapCollideCapsule(_heightmap, _capsule, _struct = undefined)
{
    return BonkCapsuleCollideHeightmap(_capsule, _heightmap, _struct).__Reverse(_capsule);
}