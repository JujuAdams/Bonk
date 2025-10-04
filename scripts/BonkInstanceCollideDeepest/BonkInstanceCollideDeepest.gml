// Feather disable all

/// @param bonkInstance
/// @param [groupFilter]
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstanceCollideDeepest(_bonkInstance, _groupFilter = undefined, _objectXY = BonkObjectXY, _objectXZ = BonkObjectXZ)
{
    return BonkCollideDeepest(_bonkInstance, BonkInstancePlaceList(_bonkInstance, 0, 0, 0, _groupFilter, undefined, _objectXY, _objectXZ));
}