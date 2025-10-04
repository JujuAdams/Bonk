// Feather disable all

/// @param bonkInstance
/// @param velocityStruct
/// @param [slopeThreshold=0]
/// @param [groupFilter]
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstanceMoveAndDeflect(_bonkInstance, _velocityStruct, _slopeThreshold = 0, _groupFilter = undefined, _objectXY = BonkObjectXY, _objectXZ = BonkObjectXZ)
{
    return BonkMoveAndDeflect(_bonkInstance, _velocityStruct, BonkInstancePlaceListVelocity(_bonkInstance, _velocityStruct, _groupFilter, undefined, _objectXY, _objectXZ), _slopeThreshold);
}