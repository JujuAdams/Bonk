// Feather disable all

/// @param bonkInstance
/// @param [object=BonkObject]
/// @param [groupFilter]

function BonkInstanceTouchAny(_bonkInstance, _object = BonkObject, _groupFilter = undefined)
{
    return BonkTouchAny(_bonkInstance, BonkInstancePlaceList(_bonkInstance, 0, 0, 0, _object, _groupFilter));
}