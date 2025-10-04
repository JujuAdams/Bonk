// Feather disable all

/// @param bonkInstance
/// @param velocityStruct
/// @param [slopeThreshold=0]
/// @param [object=BonkObject]
/// @param [groupFilter]

function BonkInstanceMoveAndDeflect(_bonkInstance, _velocityStruct, _slopeThreshold = 0, _object = BonkObject, _groupFilter = undefined)
{
    return BonkMoveAndDeflect(_bonkInstance, _velocityStruct, BonkInstancePlaceListVelocity(_bonkInstance, _velocityStruct, _object, _groupFilter), _slopeThreshold);
}