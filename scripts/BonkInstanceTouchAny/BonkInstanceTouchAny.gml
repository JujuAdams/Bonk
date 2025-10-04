// Feather disable all

/// @param bonkInstance
/// @param [groupFilter]
/// @param [object]

function BonkInstanceTouchAny(_bonkInstance, _groupFilter = undefined, _object = BonkObject)
{
    return BonkTouchAny(_bonkInstance, BonkInstancePlaceList(_bonkInstance, 0, 0, 0, _groupFilter, undefined, _object));
}