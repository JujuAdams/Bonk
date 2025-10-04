// Feather disable all

/// @param bonkInstance
/// @param [object=BonkObject]
/// @param [groupFilter]

function BonkInstanceDeflectMany(_bonkInstance, _object = BonkObject, _groupFilter = -1)
{
    return BonkDeflectMany(_bonkInstance, BonkInstancePlaceList(_bonkInstance, 0, 0, 0, _object, _groupFilter));
}