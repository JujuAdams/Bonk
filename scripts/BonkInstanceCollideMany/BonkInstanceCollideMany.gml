// Feather disable all

/// @param bonkInstance
/// @param [object=BonkObject]
/// @param [groupFilter]

function BonkInstanceCollideMany(_bonkInstance, _object = BonkObject, _groupFilter = -1)
{
    return BonkCollideMany(_bonkInstance, BonkInstancePlaceList(_bonkInstance, 0, 0, 0, _object, _groupFilter));
}