// Feather disable all

/// @param subjectInstance
/// @param velocityStruct
/// @param [slopeThreshold=0]
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]

function BonkInstanceMoveAndDeflect(_subjectInstance, _velocityStruct, _slopeThreshold = 0, _objectOrArray = BonkObject, _groupFilter = -1)
{
    return BonkMoveAndDeflect(_subjectInstance, _velocityStruct, BonkInstancePlaceListVelocity(_subjectInstance, _velocityStruct, _objectOrArray), _slopeThreshold, _groupFilter);
}