// Feather disable all

/// @param bonkInstance
/// @param [groupFilter]
/// @param [object]

function BonkInstanceCollideMany(_bonkInstance, _groupFilter = undefined, _object = BonkObject)
{
    return BonkCollideMany(_bonkInstance, BonkInstancePlaceList(_bonkInstance, 0, 0, 0, _groupFilter, undefined, _object));
}