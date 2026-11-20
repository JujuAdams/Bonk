/// @param heightmap
/// @param aab
/// @param [struct]

function BonkHeightmapCollideAAB(_heightmap, _aab, _struct = undefined)
{
    return BonkAABCollideHeightmap(_aab, _heightmap, _struct).__Reverse(_aab);
}