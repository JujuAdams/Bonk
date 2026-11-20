/// @param heightmap
/// @param box
/// @param [struct]

function BonkHeightmapCollideRotatedBox(_heightmap, _box, _struct = undefined)
{
    return BonkRotatedBoxCollideHeightmap(_box, _heightmap, _struct).__Reverse(_box);
}