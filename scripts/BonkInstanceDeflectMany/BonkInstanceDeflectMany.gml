// Feather disable all

/// @param bonkInstance
/// @param [groupFilter]
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstanceDeflectMany(_bonkInstance, _groupFilter = undefined, _objectXY = BonkObjectXY, _objectXZ = BonkObjectXZ)
{
    return BonkDeflectMany(_bonkInstance, BonkInstancePlaceList(_bonkInstance, 0, 0, 0, _groupFilter, undefined, _objectXY, _objectXZ));
}