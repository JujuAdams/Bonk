// Feather disable all

/// @param bonkInstance
/// @param [groupFilter]
/// @param [object]

function BonkInstanceCollideDeepest(_bonkInstance, _groupFilter = undefined, _object = BonkObject)
{
    return BonkCollideDeepest(_bonkInstance, BonkInstancePlaceList(_bonkInstance, 0, 0, 0, _groupFilter, undefined, _object));
}