/// @param heightmap
/// @param aab

function BonkHeightmapTouchAAB(_heightmap, _aab)
{
    return BonkCylinderTouchHeightmap(_aab, _heightmap);
}