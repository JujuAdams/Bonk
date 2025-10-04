// Feather disable all

/// @param bonkInstance
/// @param [object=BonkObject]
/// @param [groupFilter]

function BonkInstanceCollideDeepest(_bonkInstance, _object = BonkObject, _groupFilter = undefined)
{
    return BonkCollideDeepest(_bonkInstance, BonkInstancePlaceList(_bonkInstance, 0, 0, 0, _object, _groupFilter));
}